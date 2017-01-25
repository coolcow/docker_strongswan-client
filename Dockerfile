FROM alpine:latest

MAINTAINER Jean-Michel Ruiz <mail@coolcow.org>

ENV PROFILE_NAME "default"
ENV LOCAL_IP "127.0.0.1"
ENV WAIT_AFTER_START "10"
ENV INTERVAL_STATUSCHECK "10"
ENV KEEPALIVE_CHECK ""
ENV KEEPALIVE_CHECK_INTERVAL "10"

RUN apk add --no-cache --update strongswan

COPY charon-logging.conf /etc/strongswan.d/charon-logging.conf
COPY cmd.sh /tmp/cmd.sh

RUN chmod +x /tmp/cmd.sh

CMD /tmp/cmd.sh

