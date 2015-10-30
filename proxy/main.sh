#!/usr/bin/env bash

service rsyslog start
postconf -e "myhostname = `hostname`"
service postfix start
service nginx start

sleep infinity
