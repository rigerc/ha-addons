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
    CARGO_NET_GIT_FETCH_WITH_CLI=true \
    HOME="/root" \
    LANG="C.UTF-8" \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_EXTRA_INDEX_URL="https://wheels.home-assistant.io/musllinux-index/" \
    PIP_NO_CACHE_DIR=1 \
    PIP_PREFER_BINARY=1 \
    PS1="$(whoami)@$(hostname):$(pwd)$ " \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_VERBOSITY=0 \
    TERM="xterm-256color" 
# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG KAPOWARR_VERSION=1.2.0
# hadolint ignore=DL3003,DL3042
RUN \
  curl -J -L -o /tmp/kapowarr.tar.gz \
      "https://github.com/Casvt/Kapowarr/archive/refs/tags/V${KAPOWARR_VERSION}.tar.gz" \
  && mkdir -p /app \
  && tar zxvf \
      /tmp/kapowarr.tar.gz \
      --strip 1 -C /app \
  \
  && rm -f -r \
    /tmp/* \
    /app/Kapowarr.Update \
  && pip3 install --no-cache-dir -r /app/requirements.txt
# Copy root filesystem
COPY rootfs /

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
        fi && \
        if [ -d /scripts ]; then \
            chown -R "root:root" /scripts && \
            chmod -R 755 /scripts; \
        fi

    EXPOSE 5656
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