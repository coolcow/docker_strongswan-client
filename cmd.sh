#!/bin/sh

tunnel_up () { 
  list of commands

  # wait a little bit (to make sure ipsec is fully started)
  sleep ${WAIT_AFTER_START}

  # try to ipsec up the profile until success
  until ipsec up ${PROFILE_NAME}
  do 
    sleep 1
  done
}

tunnel_down() {
  ipsec down ${PROFILE_NAME}
}

# adding a loopback alias for the tunnel ip of the client
ip addr add ${LOCAL_IP} dev lo label lo:${PROFILE_NAME}

# install ipsec.conf and ipsec.secrets with the correct permissions
install -D -m 644 /install/ipsec.conf /etc/ipsec.conf
install -D -m 644 /install/ipsec.secrets /etc/ipsec.secrets

# start ipsec
ipsec start

# connect tunnel
tunnel_up

if [ ! -z "$RECONNECT_IF_NOT" ]; then
  tail -f /var/log/charon.log &
  # keep alive
  eval 'while true; sleep $RECONNECT_IF_NOT_INTERVAL; do while $RECONNECT_IF_NOT &> /dev/null; do sleep $RECONNECT_IF_NOT_INTERVAL; done; tunnel_down; tunnel_up; done'
else
  # keep alive
  tail -f /var/log/charon.log
fi

# disconnect tunnel
tunnel_down

