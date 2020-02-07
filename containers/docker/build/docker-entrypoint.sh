#!/bin/bash
set -e


if [[ ! -f "$DISCOVERY_CFG_DIR/config.properties" ]]; then
    CONFIG_PROPERTIES="$DISCOVERY_CFG_DIR/config.properties"
    {
        echo "http-server.http.port=8411"
        echo "discovery.uri=http://localhost:8411"
    } >> "$CONFIG_PROPERTIES"
fi

if [[ ! -f "$DISCOVERY_CFG_DIR/jvm.config" ]]; then
    JVM_CONFIG="$DISCOVERY_CFG_DIR/jvm.config"
    {
        echo "-server"
        echo "-Xmx$DISCOVERY_HEAP_SIZE"
        echo "-XX:+UseConcMarkSweepGC"
        echo "-XX:+ExplicitGCInvokesConcurrent"
        echo "-XX:+AggressiveOpts"
        echo "-XX:+HeapDumpOnOutOfMemoryError"
        echo "-XX:OnOutOfMemoryError=kill -9 %p"
    } >> "$JVM_CONFIG"
fi

if [[ ! -f "$DISCOVERY_CFG_DIR/node.properties" ]]; then
    NODE_PROPERTIES="$DISCOVERY_CFG_DIR/node.properties"
    {
        echo "node.environment=$DISCOVERY_ENV"
        echo "node.id=$HOSTNAME"
        echo "node.data-dir=$DISCOVERY_DATA_DIR"
    } >> "$NODE_PROPERTIES"
fi

exec "$@"