#!/bin/bash

PID=`cat /run/haproxy.pid`
COMMAND=`ps -e -o command | grep '/usr/local/sbin/haproxy ' | grep -v grep`
kill -9 $PID
nohup $COMMAND &
