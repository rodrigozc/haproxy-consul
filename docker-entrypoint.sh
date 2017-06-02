#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
	# if the user wants "haproxy", let's use "haproxy-systemd-wrapper" instead so we can have proper reloadability implemented by upstream
	shift # "haproxy"
	set -- "$(which haproxy-systemd-wrapper)" -p /run/haproxy.pid "$@"
fi

IP=`ip -f inet addr | grep inet | grep -m 1 $CONSUL_INTERFACE | awk '{ print $2; }' | awk 'BEGIN { FS="/"; } { print $1;  }'`

echo "Initializing consul..."
nohup consul agent -advertise $IP -client 0.0.0.0 -retry-join $CONSUL_SERVER -data-dir /opt/consul/data -config-dir /opt/consul/config -node-id `cat /proc/sys/kernel/random/uuid` > /app/logs/consul.log 2>&1&

echo "Initializing consul template..."
nohup consul-template -template "/usr/local/etc/haproxy/haproxy.template:/usr/local/etc/haproxy/haproxy.cfg:$@" > /app/logs/consul-template.log 2>&1&

exec "$@"
