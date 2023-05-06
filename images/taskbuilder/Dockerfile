FROM python:3.6-bullseye

USER root

ENV TZ=UTC

ARG CMS_UID=1000
ARG CMS_GID=1000
ARG CMS_VERSION=v1.4.rc1

#
# Create 'cmsuser' user and group
#
RUN addgroup --gid ${CMS_GID} cmsuser \
    && adduser --uid ${CMS_UID} --gid ${CMS_GID} --gecos '' cmsuser

#
# Update system and install dependencies
#
RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get upgrade -y \
    && apt-get install -y \
      a2ps \
      build-essential \
      cgroup-tools \
      cgroupfs-mount \
      citation-style-language-styles \
      context \
      cppreference-doc-en-html \
      curl \
      fp-compiler \
      gcc \
      gettext \
      git \
      groff \
      haskell-platform \
      iso-codes \
      libc6 \
      libcap-dev \
      libcups2-dev \
      libffi-dev \
      libjpeg-dev \
      libjs-mathjax \
      libldap2-dev \
      libpq-dev \
      libpython3-dev \
      librsvg2-bin \
      libsasl2-dev \
      libxml2-dev \
      libxslt1-dev \
      libyaml-dev \
      libyaml-dev \
      linux-headers-amd64 \
      linux-libc-dev \
      mono-mcs \
      node-katex \
      nodejs \
      openjdk-17-jdk-headless \
      pandoc \
      pandoc-citeproc \
      php \
      php-cli \
      python3 \
      python3-dev \
      python3-pip \
      r-base-core \
      ruby \
      rustc \
      shared-mime-info \
      stl-manual \
      texlive-latex-extra \
      texlive-latex-recommended \
      texlive-luatex \
      texlive-xetex \
      tzdata \
      wget \
      wkhtmltopdf \
      zip \
      zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

#
# Install CMS
#
RUN wget -O cms.tar.gz https://github.com/cms-dev/cms/releases/download/${CMS_VERSION}/${CMS_VERSION}.tar.gz \
    && mkdir -p /usr/local/src/cms \
    && tar -xvzC /usr/local/src/cms --strip-components=1 -f cms.tar.gz \
    && rm cms.tar.gz \
    && cd /usr/local/src/cms \
    && pip install --no-cache-dir -r requirements.txt \
    && python ./prerequisites.py --as-root build \
    && python ./prerequisites.py --yes --as-root install \
    && python ./setup.py install \
    \
    && pip install --no-cache-dir jsonpath-ng \
    \
    && ldconfig \
    && rm -rf /tmp/* 

USER cmsuser
WORKDIR /home/cmsuser

COPY --chown=cmsuser:cmsuser entrypoint.sh /home/cmsuser/entrypoint.sh

ENTRYPOINT [ "/home/cmsuser/entrypoint.sh" ]
CMD ["help"]
