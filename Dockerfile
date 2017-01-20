FROM alpine:latest

MAINTAINER Jean-Michel Ruiz <mail@coolcow.org>

ENV LOCAL_IP "127.0.0.1"
ENV WAIT_AFTER_START "10"
ENV INTERVAL_STATUSCHECK "10"

RUN apk add --no-cache --update strongswan

COPY charon-logging.conf /etc/strongswan.d/charon-logging.conf

CMD \
    # adding a loopback alias for the tunnel ip of the client
    ip addr add ${LOCAL_IP} dev lo label lo:strongswan \
    # install ipsec.conf and ipsec.secrets with the correct permissions
    ;  install -D -m 644 /install/ipsec.conf /etc/ipsec.conf \
    && install -D -m 644 /install/ipsec.secrets /etc/ipsec.secrets \
    # start ipsec
    && ipsec start \
    && tail -f /etc/strongswan.d/charon-logging.conf

