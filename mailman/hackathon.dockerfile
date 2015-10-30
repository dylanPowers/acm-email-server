FROM ubuntu:14.04


ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        postfix

RUN apt-get install -y --no-install-recommends \
        mailman \
        lighttpd \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
ADD start-mailman.sh /usr/local/bin/start-mailman.sh

COPY hackathon.transport /etc/postfix/transport
COPY hackathon.mm_cfg.py /usr/lib/mailman/Mailman/mm_cfg.py
RUN postconf -e 'relay_domains = hackathon.eecs.wsu.edu' && \ 
    postconf -e 'transport_maps = hash:/etc/postfix/transport' && \
    postconf -e 'mailman_destination_recipient_limit = 1' && \
    postmap -v /etc/postfix/transport

ADD mailman-config /
ADD default-list-config /
RUN chmod 660 mailman-config default-list-config

ADD mailman-ssl.pem /
RUN chmod 400 mailman-ssl.pem

RUN . /mailman-config && \
    newlist mailman $ADMIN_EMAIL $ADMIN_PASS && \
    config_list -i /var/lib/mailman/data/sitelist.cfg mailman
RUN . /mailman-config && \
    newlist sponsor $ADMIN_EMAIL $ADMIN_PASS && \
    config_list -i default-list-config sponsor
RUN . /mailman-config && \
    newlist hacker $ADMIN_EMAIL $ADMIN_PASS && \
    config_list -i default-list-config hacker
RUN . /mailman-config && \
    newlist contact $ADMIN_EMAIL $ADMIN_PASS && \
    config_list -i default-list-config contact

RUN /usr/lib/mailman/bin/check_perms -f

EXPOSE 25 80
VOLUME [ "/var/lib/mailman/data", "/var/lib/mailman/lists", "/var/lib/mailman/archives" ]
CMD [ "/usr/local/bin/start-mailman.sh" ]
