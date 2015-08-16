FROM ubuntu:14.04

## Build:
## docker build -t hackathon-email .
## Run:
## docker run -d -p 8080:80 -p 25:25 hackathon-email
##


ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        mailman \
        lighttpd \
        postfix \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
ADD start-mailman.sh /usr/local/bin/start-mailman.sh

ADD transport /etc/postfix/
ADD mm_cfg.py /usr/lib/mailman/Mailman/
RUN postconf -e 'relay_domains = hackathon.eecs.wsu.edu' && \ 
    postconf -e 'transport_maps = hash:/etc/postfix/transport' && \
    postconf -e 'mailman_destination_recipient_limit = 1' && \
    postmap -v /etc/postfix/transport
RUN /usr/lib/mailman/bin/check_perms -f

ADD mailman-config /
ADD default-list-config /
RUN . /mailman-config && /usr/lib/mailman/bin/newlist mailman $ADMIN_EMAIL $ADMIN_PASS
RUN . /mailman-config && \
    /usr/lib/mailman/bin/newlist sponsor $ADMIN_EMAIL $ADMIN_PASS && \
    /usr/lib/mailman/bin/config_list -i default-list-config sponsor
RUN . /mailman-config && \
    /usr/lib/mailman/bin/newlist hacker $ADMIN_EMAIL $ADMIN_PASS && \
    /usr/lib/mailman/bin/config_list -i default-list-config hacker

EXPOSE 25 8080
VOLUME /var/lib/mailman/data /var/lib/mailman/lists /var/lib/mailman/archives
CMD [ "/usr/local/bin/start-mailman.sh" ]
