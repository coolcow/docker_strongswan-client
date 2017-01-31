FROM alpine:latest

MAINTAINER Jean-Michel Ruiz <mail@coolcow.org>

ENV PROFILE_NAME "default"
ENV LOCAL_IP "127.0.0.1"
ENV WAIT_AFTER_START "10"
ENV RECONNECT_IF_NOT ""
ENV RECONNECT_IF_NOT_INTERVAL "10"

RUN apk add --no-cache --update strongswan

COPY charon-logging.conf /etc/strongswan.d/charon-logging.conf
COPY cmd.sh /tmp/cmd.sh

RUN chmod +x /tmp/cmd.sh

CMD /tmp/cmd.sh

