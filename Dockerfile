FROM ubuntu:trusty

MAINTAINER Jean-Michel Ruiz "mail@coolcow.org"

# ENV
ENV IPSEC_PROFILE ""

RUN apt-get update \
  && apt-get upgrade -y
RUN apt-get install -y strongswan strongswan-plugin-kernel-libipsec autossh libcap-ng-utils iptables

RUN rm -rf /var/lib/apt/lists/* src/*

CMD ipsec start \
  && sleep 5 \
  && ipsec up ${IPSEC_PROFILE} \
  && tail -f /dev/null
