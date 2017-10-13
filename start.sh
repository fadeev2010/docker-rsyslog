#!/bin/bash
set -e

rm -rf /var/run/rsyslogd.pid

chown root:root -R /etc/cron.d/*
chmod 600 -R /etc/cron.d/*

touch /var/log/cron.log

echo $TZ > /etc/timezone && \
rm /etc/localtime && \
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
dpkg-reconfigure -f noninteractive tzdata


echo "Starting rsyslog"
/usr/sbin/rsyslogd -f /etc/rsyslog.conf

echo "Starting cron"
cron -f
