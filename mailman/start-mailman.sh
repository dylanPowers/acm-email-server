#!/bin/bash

service rsyslog start
service postfix start
service lighttpd start
service mailman start

sleep infinity
