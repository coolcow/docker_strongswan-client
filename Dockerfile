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

CMD \
    # adding a loopback alias for the tunnel ip of the client
    ip addr add ${LOCAL_IP} dev lo label lo:${PROFILE_NAME} \
    # install ipsec.conf and ipsec.secrets with the correct permissions
    ;  install -D -m 644 /install/ipsec.conf /etc/ipsec.conf \
    && install -D -m 644 /install/ipsec.secrets /etc/ipsec.secrets \
    # start ipsec
    && ipsec start \
    # wait a little bit (to make sure ipsec is fully started)
    && sleep ${WAIT_AFTER_START} \
    # try to ipsec up the profile until success
    && until ipsec up ${PROFILE_NAME}; do sleep 1; done \
    # keep alive check
    && if [ ! -z "$KEEPALIVE_CHECK" ]; then eval 'while $KEEPALIVE_CHECK &> /dev/null; do sleep $KEEPALIVE_CHECK_INTERVAL; done; killall tail;' & fi \
    # keep alive
    tail -f /var/log/charon.log
