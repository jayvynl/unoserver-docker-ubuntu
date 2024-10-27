FROM ubuntu:24.04

ARG UID=app
ARG GID=app
ARG UNOSERVER_VERSION=3.0.1
ARG WORKDIR=/app

ENV DEBIAN_FRONTEND noninteractive
RUN echo '''\
deb http://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse\n\
# deb-src http://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse\n\
deb http://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse\n\
# deb-src http://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse\n\
deb http://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse\n\
# deb-src http://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse\
''' > /etc/apt/sources.list \
    && apt-get -y update \
    && apt-get install -y --no-install-recommends libreoffice default-jre \
        libreoffice-java-common python3-pip python3-uno \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN groupadd -r ${GID} \
    && useradd -m -d /tmp -s /bin/false -g ${GID} ${UID} \
    && mkdir -p ${WORKDIR} \
    && pip3 install --break-system-packages --no-cache-dir --trusted-host mirrors.aliyun.com -i http://mirrors.aliyun.com/pypi/web/simple \
        unoserver==${UNOSERVER_VERSION}

COPY ./fonts/* /usr/share/fonts
COPY --chown=${GID}:${UID} health_check.py ${WORKDIR}

USER ${GID}:${UID}
WORKDIR ${WORKDIR}

HEALTHCHECK --interval=10s --timeout=10s --retries=100 \
    CMD python3 health_check.py

EXPOSE 2003
CMD ["unoserver", "--interface", "0.0.0.0", "--port", "2003"]
