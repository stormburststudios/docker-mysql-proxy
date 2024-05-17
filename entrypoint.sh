#!/bin/bash

echo "Starting MySQL Proxy..."
echo "Configured to listen as ${PROXY_DB_HOST}:${PROXY_DB_PORT}"
echo "Configured to forward to ${REMOTE_DB_HOST}:${REMOTE_DB_PORT}"
exec /opt/mysql-proxy/bin/mysql-proxy \
	--keepalive \
	--log-level=error \
	--plugins=proxy \
	--proxy-address="${PROXY_DB_HOST}":"${PROXY_DB_PORT}" \
	--proxy-backend-addresses="${REMOTE_DB_HOST}":"${REMOTE_DB_PORT}" \
	--proxy-lua-script=/opt/mysql-proxy/conf/main.lua
