FROM ubuntu:14.04


## run
## docker run -d -p 8080:8080 -p 25:25 hackathon-mail
##


ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        mailman \
        lighttpd \
        postfix \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD etc_aliases /etc/aliases
ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
ADD start-mailman.sh /usr/local/bin/start-mailman.sh

ADD mailman-config /
RUN . /mailman-config && /usr/lib/mailman/bin/newlist mailman $ADMIN_EMAIL $ADMIN_PASS

EXPOSE 25 8080

CMD [ "/usr/local/bin/start-mailman.sh" ]
