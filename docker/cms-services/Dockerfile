# syntax=docker/dockerfile:1
FROM cmsorbits/cms:1.4.rc1

USER root

# caveat emptor:
#   https://stackoverflow.com/a/75731734/2377454
ARG TZ=UTC
ENV TZ=${TZ}

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get upgrade -y \
      apt-utils \
      locales \
    && locale-gen en_US.UTF-8 C.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive \
    && dpkg-reconfigure tzdata

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get upgrade -y \
      wait-for-it \
      xz-utils \
      wget \
    && rm -rf /var/lib/apt/lists/*


# s6 overlay
ARG S6_OVERLAY_VERSION=3.1.5.0
RUN mkdir -pv /opt/overlay \
    && S6_DOWNLOAD_URL='https://github.com/just-containers/s6-overlay/releases/download' \
    && wget -P /opt/overlay \
        ${S6_DOWNLOAD_URL}/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz \
    && wget -P /opt/overlay \
        ${S6_DOWNLOAD_URL}/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz.sha256 \
    && wget -P /opt/overlay \
         ${S6_DOWNLOAD_URL}/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz \
    && wget -P /opt/overlay \
         ${S6_DOWNLOAD_URL}/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz.sha256
RUN cd  /opt/overlay \
    && sha256sum -c s6-overlay-noarch.tar.xz.sha256 \
    && tar -C / -Jxpf s6-overlay-noarch.tar.xz \
    && sha256sum -c s6-overlay-x86_64.tar.xz.sha256 \
    && tar -C / -Jxpf s6-overlay-x86_64.tar.xz \
    && rm -rf /opt/overlay

COPY --chmod=755 rootfs /

ENTRYPOINT ["/init"]
