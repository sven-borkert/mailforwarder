#!/bin/bash

postalias /etc/aliases

echo "[127.0.0.1]:11125		${SMTP_LOGIN}:${SMTP_PASSWORD}" > /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

sed -i "/connect = /c connect = ${SMTP_RELAY}" /etc/stunnel/stunnel.conf
SMTP_RELAY_HOSTNAME=$(echo $SMTP_RELAY | awk -F ':' '{ print $1; }')
sed -i "/checkHost = /c checkHost = ${SMTP_RELAY_HOSTNAME}" /etc/stunnel/stunnel.conf

stunnel /etc/stunnel/stunnel.conf 
/usr/sbin/postfix start-fg
