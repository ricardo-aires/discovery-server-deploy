FROM openjdk:8

ARG MIRROR=https://repo1.maven.org/maven2/com/facebook/airlift/discovery/discovery-server
ARG VERSION=1.30
ARG DISTRO_NAME=discovery-server-$VERSION

ENV DISCOVERY_ENV=docker \
    DISCOVERY_HEAP_SIZE=1G \
    DISCOVERY_DATA_DIR=/data \
    DISCOVERY_CFG_DIR=/$DISTRO_NAME/etc \
    PATH=$PATH:/$DISTRO_NAME/bin

RUN set -eux && \
    groupadd -r presto --gid=1000 && \
    useradd -r -g presto --uid=1000 presto && \
    wget "$MIRROR/$VERSION/$DISTRO_NAME.tar.gz" -O "$DISTRO_NAME.tar.gz" && \
	tar xvzf "$DISTRO_NAME.tar.gz" && \
    rm -rf  "$DISTRO_NAME.tar.gz" && \
    mkdir -p $DISCOVERY_DATA_DIR $DISCOVERY_CFG_DIR && \
    chown -R presto:presto "/$DISTRO_NAME" "$DISCOVERY_DATA_DIR" "$DISCOVERY_CFG_DIR"

WORKDIR $DISTRO_NAME
VOLUME ["$DISCOVERY_DATA_DIR"]

EXPOSE 8411

USER presto
COPY --chown=presto:presto docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["launcher", "run"]