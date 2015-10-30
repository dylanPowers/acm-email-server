FROM ubuntu:14.04


ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      postfix

RUN apt-get install -y --no-install-recommends nginx
COPY nginx-mailman /etc/nginx/sites-available/mailman-proxy
RUN ln -s /etc/nginx/sites-available/mailman-proxy /etc/nginx/sites-enabled/

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY transport /etc/postfix/
RUN postconf -e 'relay_domains = acm.eecs.wsu.edu hackathon.eecs.wsu.edu' && \
    postconf -e 'transport_maps = hash:/etc/postfix/transport' && \
    postmap -v /etc/postfix/transport

COPY mailman-ssl.key /ssl.key
COPY mailman-ssl.crt /ssl.crt
RUN chmod 400 ssl.key ssl.crt

COPY main.sh /main.sh

EXPOSE 8080 25
CMD [ "/main.sh" ]
