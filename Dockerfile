FROM marshall:version AS mysql-proxy

LABEL maintainer="Matthew Baggett <matthew@baggett.me>" \
      org.label-schema.vcs-url="https://github.com/benzine-framework/docker-mysql-proxy" \
      org.opencontainers.image.source="https://github.com/benzine-framework/docker-mysql-proxy"

ENV MYSQL_PROXY_VERSION=0.8.5 \
    MYSQL_PROXY_TAR_NAME=mysql-proxy-$MYSQL_PROXY_VERSION-linux-debian6.0-x86-64bit \
    DEBIAN_FRONTEND=noninteractive

RUN adduser mysql && \
    apt-get update && \
    apt-get upgrade -y ca-certificates tzdata && \
    apt-get -y install --no-install-recommends \
      wget \
      mysql-client \
      socat \
    && \
    wget -q https://downloads.mysql.com/archives/get/p/21/file/$MYSQL_PROXY_TAR_NAME.tar.gz && \
    tar -xzvf $MYSQL_PROXY_TAR_NAME.tar.gz && \
    mv $MYSQL_PROXY_TAR_NAME /opt/mysql-proxy && \
    rm $MYSQL_PROXY_TAR_NAME.tar.gz && \
    DEBIAN_FRONTEND=noninteractive apt-get -y remove wget && \
    apt-get autoremove -yqq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/ && \
    chown -R mysql:mysql /opt/mysql-proxy

COPY main.lua /opt/mysql-proxy/conf/main.lua
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/healthcheck.sh
CMD [ "/usr/local/bin/entrypoint.sh" ]

HEALTHCHECK --interval=5s --timeout=3s --start-period=5s --retries=3 \
    CMD /usr/local/bin/healthcheck.sh || exit 1

USER mysql
