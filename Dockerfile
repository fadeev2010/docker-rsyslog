FROM ubuntu:16.04
MAINTAINER Sergey Fadeev, DroidLabs LLC

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get -y --no-install-suggests --no-install-recommends install \
    software-properties-common \
 && add-apt-repository ppa:adiscon/v8-stable \
 && apt-get update \
 && apt-get -y --no-install-suggests --no-install-recommends install \
    rsyslog cron logrotate tzdata \
 && apt-get -y --purge --autoremove remove software-properties-common \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN sed 's/#$ModLoad imudp/$ModLoad imudp/' -i /etc/rsyslog.conf
RUN sed 's/#$UDPServerRun 514/$UDPServerRun 514/' -i /etc/rsyslog.conf
RUN sed 's/#$ModLoad imtcp/$ModLoad imtcp/' -i /etc/rsyslog.conf
RUN sed 's/#$InputTCPServerRun 514/$InputTCPServerRun 514/' -i /etc/rsyslog.conf
RUN sed 's/$ModLoad imklog/#$ModLoad imklog/' -i /etc/rsyslog.conf
RUN sed 's/$FileOwner syslog/$FileOwner root/' -i /etc/rsyslog.conf
RUN sed 's/$PrivDropToUser syslog/#$PrivDropToUser syslog/' -i /etc/rsyslog.conf
RUN sed 's/$PrivDropToGroup syslog/#$PrivDropToGroup syslog/' -i /etc/rsyslog.conf

COPY logrotate_rsyslog.conf /etc/logrotate.d/rsyslog
RUN chmod 0644 /etc/logrotate.d/rsyslog

COPY cron_logrotate.conf /etc/cron.d/cron_logrotate.conf

RUN touch /var/log/cron.log

RUN sed 's/#cron.*/cron.*/' -i /etc/rsyslog.d/50-default.conf

# default timezone
ENV TZ=Europe/Moscow

COPY start.sh /start.sh

EXPOSE 514/tcp 514/udp
CMD ["/start.sh"]
