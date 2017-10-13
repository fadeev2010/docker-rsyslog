# docker-rsyslog
Docker Rsyslog image with logrotate

## Run container with 514 port UPD and TCP
docker run -d --name rsyslog -p 514:514/udp -p 514:514 droid-rsyslog

## Run container with different timezone
docker run -d --name rsyslog -e TZ=America/Chicago droid-rsyslog
