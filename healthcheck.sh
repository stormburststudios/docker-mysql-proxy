#!/bin/bash
export MYSQL_PWD="${MYSQL_PASSWORD}"
mysqladmin ping \
	-h "${PROXY_DB_HOST:-"127.0.0.1"}" \
	-P "${PROXY_DB_PORT}" \
	-u "${MYSQL_USER}"
