#!/usr/bin/env bash

cd "$(dirname "$0")"

cd mailman
docker build -t hackathon-email -f hackathon.dockerfile .
docker build -t acm-email -f acm.dockerfile .

docker create -v /var/lib/mailman/data \
              -v /var/lib/mailman/lists \
              -v /var/lib/mailman/archives \
              --name hackathon-email-data \
              hackathon-email /bin/true
docker create -v /var/lib/mailman/data \
              -v /var/lib/mailman/lists \
              -v /var/lib/mailman/archives \
              --name acm-email-data \
              acm-email /bin/true
