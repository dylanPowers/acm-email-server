FROM ubuntu:14.04


## run
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
RUN postconf -e 'relay_domains = hackathon.eecs.wsu.edu' && \ 
    postconf -e 'transport_maps = hash:/etc/postfix/transport' && \
    postconf -e 'mailman_destination_recipient_limit = 1' && \
    postmap -v /etc/postfix/transport

ADD mailman-config /
RUN . /mailman-config && /usr/lib/mailman/bin/newlist mailman $ADMIN_EMAIL $ADMIN_PASS

EXPOSE 25 8080

CMD [ "/usr/local/bin/start-mailman.sh" ]
