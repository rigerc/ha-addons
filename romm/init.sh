#!/bin/sh
# shellcheck disable=SC2015
set -e

# --- Configuration Variables ---
BASHIO_VERSION="v0.17.0"
S6_OVERLAY_VERSION="3.2.0.2"
TEMPIO_VERSION="2024.11.2" # Note: The original script had 2024.11.2, which might be a future date.

# --- Error Handling for Build Architecture ---
# Check if the build architecture argument is provided
if [ -z "$1" ]; then
  echo "Error: Build architecture not provided."
  echo "Usage: $0 <build_arch>"
  echo "Example: $0 amd64"
  exit 1
fi
BUILD_ARCH="$1"

# --- Package Installation ---
# Update package lists and install essential packages
# The script attempts to use apt-get first, then falls back to apk if apt-get is not found.
echo "Updating package lists and installing essential packages (bash, curl)..."
if command -v apt-get >/dev/null 2>&1; then
    # Debian/Ubuntu based
    apt-get update >/dev/null
    apt-get install -yqq --no-install-recommends bash curl >/dev/null
    # Install build dependencies (tar, xz-utils) and runtime dependencies
    echo "Installing build and runtime dependencies (tar, xz, libcrypto, libssl, musl, jq, tzdata)..."
    apt-get install -yqq --no-install-recommends tar xz-utils libcrypto3 libssl3 musl-utils musl jq tzdata mariadb-client >/dev/null
elif command -v apk >/dev/null 2>&1; then
    # Alpine based
    apk add --no-cache bash curl >/dev/null
    # Install build dependencies (tar, xz) and runtime dependencies
    echo "Installing build and runtime dependencies (tar, xz, libcrypto, libssl, musl, jq, tzdata)..."
    apk add --no-cache --virtual .build-dependencies tar xz >/dev/null
    apk add --no-cache libcrypto3 libssl3 musl-utils musl jq tzdata mariadb-client >/dev/null
else
    echo "Error: Neither apt-get nor apk found. Cannot install packages."
    exit 1
fi

# --- Determine S6_ARCH based on BUILD_ARCH ---
echo "Determining S6_ARCH for BUILD_ARCH: ${BUILD_ARCH}"
case "${BUILD_ARCH}" in
    "i386")
        S6_ARCH="i686"
        ;;
    "amd64")
        S6_ARCH="x86_64"
        ;;
    "armv7")
        S6_ARCH="arm"
        ;;
    "aarch64")
        S6_ARCH="aarch64"
        ;;
    # Add other architectures as needed
    *)
        echo "Warning: Unsupported BUILD_ARCH: ${BUILD_ARCH}. Setting S6_ARCH to BUILD_ARCH."
        S6_ARCH="${BUILD_ARCH}"
        ;;
esac
echo "S6_ARCH set to: ${S6_ARCH}"

# --- Download and extract s6-overlay components ---
S6_BASE_URL="https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}"

echo "Downloading s6-overlay components..."
# Function to download and extract a tarball
download_and_extract() {
    local url="$1"
    local component_name="$2"
    echo "Downloading ${component_name} from ${url}"
    if curl -L -s "${url}" | tar -C / -Jxpf -; then
        echo "${component_name} downloaded and extracted successfully."
    else
        echo "Error: Failed to download or extract ${component_name} from ${url}"
        exit 1
    fi
}

download_and_extract "${S6_BASE_URL}/s6-overlay-noarch.tar.xz" "s6-overlay-noarch.tar.xz"
download_and_extract "${S6_BASE_URL}/s6-overlay-${S6_ARCH}.tar.xz" "s6-overlay-${S6_ARCH}.tar.xz"
download_and_extract "${S6_BASE_URL}/s6-overlay-symlinks-noarch.tar.xz" "s6-overlay-symlinks-noarch.tar.xz"
download_and_extract "${S6_BASE_URL}/s6-overlay-symlinks-arch.tar.xz" "s6-overlay-symlinks-arch.tar.xz"

# --- Download and install bashio ---
echo "Downloading and installing bashio version ${BASHIO_VERSION}..."
BASHIO_URL="https://github.com/hassio-addons/bashio/archive/${BASHIO_VERSION}.tar.gz"
BASHIO_TMP_DIR="/tmp/bashio_install" # Use a more specific temp directory

echo "Creating temporary directory for bashio at ${BASHIO_TMP_DIR}..."
mkdir -p "${BASHIO_TMP_DIR}"

echo "Downloading bashio from ${BASHIO_URL}..."
if curl -J -L -o "${BASHIO_TMP_DIR}/bashio.tar.gz" "${BASHIO_URL}"; then
    echo "Bashio downloaded successfully."
else
    echo "Error: Failed to download bashio from ${BASHIO_URL}"
    exit 1
fi

echo "Extracting bashio..."
if tar zxvf "${BASHIO_TMP_DIR}/bashio.tar.gz" --strip 1 -C "${BASHIO_TMP_DIR}"; then
    echo "Bashio extracted successfully."
else
    echo "Error: Failed to extract bashio."
    exit 1
fi

echo "Moving bashio library to /usr/lib/bashio..."
mkdir -p /usr/lib # Ensure the target directory /usr/lib exists
if mv "${BASHIO_TMP_DIR}/lib" /usr/lib/bashio; then
    echo "Bashio library moved successfully."
else
    echo "Error: Failed to move bashio library."
    exit 1
fi

echo "Creating symlink for bashio executable at /usr/bin/bashio..."
# Ensure the target directory /usr/bin exists (it should by now)
if ln -sf /usr/lib/bashio/bashio /usr/bin/bashio; then # Use -sf for force and symbolic
    echo "Bashio symlink created successfully."
else
    echo "Error: Failed to create bashio symlink."
    # Attempt to remove existing file if it's not a symlink and try again
    if [ -f /usr/bin/bashio ] && [ ! -L /usr/bin/bashio ]; then
        echo "Attempting to remove existing /usr/bin/bashio and recreate symlink..."
        rm -f /usr/bin/bashio && ln -sf /usr/lib/bashio/bashio /usr/bin/bashio || {
            echo "Error: Still failed to create bashio symlink."
            exit 1
        }
    else
        exit 1 # Exit if ln -sf failed for other reasons
    fi
fi

# --- Download and install tempio ---
echo "Downloading and installing tempio version ${TEMPIO_VERSION} for arch ${BUILD_ARCH}..."
TEMPIO_URL="https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}"

echo "Downloading tempio from ${TEMPIO_URL}..."
if curl -L -s -o /usr/bin/tempio "${TEMPIO_URL}"; then
    echo "Tempio downloaded successfully."
else
    echo "Error: Failed to download tempio from ${TEMPIO_URL}"
    exit 1
fi

echo "Making tempio executable..."
if chmod a+x /usr/bin/tempio; then
    echo "Tempio made executable successfully."
else
    echo "Error: Failed to make tempio executable."
    exit 1
fi

# --- Clean up ---
echo "Cleaning up build dependencies and temporary files..."

if command -v apk >/dev/null 2>&1; then
    echo "Alpine-based system detected. Cleaning up with apk..."
    if apk del --no-cache --purge .build-dependencies; then # .build-dependencies was defined during apk add
        echo "Build dependencies removed successfully."
    else
        echo "Warning: Failed to remove build dependencies with apk."
    fi
elif command -v apt-get >/dev/null 2>&1; then
    echo "Debian-based system detected. Cleaning up with apt-get..."
    echo "Purging xz-utils (and other specified build dependencies if any)..."
    # Note: Only xz-utils was explicitly installed as a build dep that might need removal.
    # tar is often essential, so not removing it by default.
    if apt-get purge -y --auto-remove xz-utils; then
        echo "apt-get purge successful."
    else
        echo "Warning: apt-get purge encountered issues."
    fi
    echo "Running apt-get clean..."
    apt-get clean >/dev/null
else
    echo "No known package manager (apk or apt-get) found for cleanup."
fi

echo "Cleaning up temporary directories (/tmp/bashio_install)..."
rm -rf "${BASHIO_TMP_DIR}"
# General /tmp cleanup can be risky if other processes are using it.
# The original script had a broad /tmp/* cleanup. Keeping it specific.
# If a general /tmp cleanup is desired, uncomment the next line carefully:
# rm -rf /tmp/*

if command -v apt-get >/dev/null 2>&1; then
    echo "Removing apt cache and log files for Debian-based systems..."
    rm -rf \
        /var/cache/apt/* \
        /var/log/apt/* \
        /var/lib/apt/lists/*
fi

echo "Script finished."
exit 0
