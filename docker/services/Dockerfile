# syntax=docker/dockerfile:1
FROM cmsorbits/cms:1.4.rc1

USER root

ENV TZ=Europe/Rome

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get upgrade -y \
      wait-for-it \
    && rm -rf /var/lib/apt/lists/*
