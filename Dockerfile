FROM rockylinux:9

RUN dnf -y update && dnf install -y postfix \
    s-nail \
    cyrus-sasl \
    cyrus-sasl-plain \
    stunnel \
    net-tools \
    vim \
    procps-ng \
    && dnf clean all;

# Postfix configuration: main.cf 
RUN echo -e "smtp_sasl_auth_enable=yes\n\
smtp_sasl_security_options=\n\
relayhost=[127.0.0.1]:11125\n\
smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd\n\
mynetworks=127.0.0.0/8,172.0.0.0/8\n\
maillog_file=/dev/stdout\n" >> /etc/postfix/main.cf\
&& sed -i '/inet_interfaces = localhost/c inet_interfaces = all' /etc/postfix/main.cf

ADD run.sh  /root/run.sh
ADD stunnel.conf /etc/stunnel/stunnel.conf

RUN chmod 700 /root/run.sh

ENV SMTP_RELAY=dummy\
    SMTP_LOGIN=dummy\
    SMTP_PASSWORD=dummy

VOLUME ["/var/spool"]

CMD ["/root/run.sh"]

