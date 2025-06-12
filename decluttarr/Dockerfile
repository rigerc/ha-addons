#################
# 1 Build Image #
#################

ARG BUILD_FROM
ARG BUILD_VERSION
ARG BUILD_ARCH
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Environment variables
ENV \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_VERBOSITY=2

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install packages based on distribution
RUN \
    set -x \
    && if command -v apk >/dev/null 2>&1; then \
        # Alpine Linux
        apk add --no-cache \
            bash \
            bind-tools \
            ca-certificates \
            curl \
            jq \
            libstdc++ \
            tzdata \
            xz \
            libgcc \
            git; \
    elif command -v apt-get >/dev/null 2>&1; then \
        # Debian/Ubuntu
        apt-get update \
        && apt-get install -y --no-install-recommends \
            bash \
            dnsutils \
            ca-certificates \
            curl \
            jq \
            libstdc++6 \
            tzdata \
            xz-utils \
            libgcc-s1 \
            git \
        && rm -rf /var/lib/apt/lists/*; \
    else \
        echo "Unsupported package manager" && exit 1; \
    fi

ARG BASHIO_VERSION="v0.17.0"



RUN git clone -b latest https://github.com/ManiMatter/decluttarr.git /app
# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

COPY rootfs/ /

RUN \
    if [ -d /etc/cont-init.d ]; then \
        chown -R "root:root" /etc/cont-init.d && \
        chmod -R 755 /etc/cont-init.d; \
    fi && \
    if [ -d /etc/services.d ]; then \
        chown -R "root:root" /etc/services.d && \
        chmod -R 755 /etc/services.d; \
    fi && \
    if [ -d /etc/s6-overlay/s6-rc.d ]; then \
        chown -R "root:root" /etc/s6-overlay/s6-rc.d && \
        chmod -R 755 /etc/s6-overlay/s6-rc.d; \
    fi

############
# 5 Labels #
############

ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ENV BUILD_VERSION="${BUILD_VERSION}"

LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="rigerc" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="rigerc's add-ons" \
    org.opencontainers.image.authors="rigerc" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/rigerc" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/rigerc/hd-addons/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}