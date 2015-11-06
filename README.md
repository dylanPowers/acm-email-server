# ACM Mailman Server

## Configuration Instructions

1. Create Config
  Create a file named `mailman/mailman-config` with the following contents:
  ```sh
  #!/bin/sh
  
  export ADMIN_EMAIL='<admin-email>'
  export ADMIN_PASS='<admin-pass>'
  ```

2. Generate SSL certs
  ```sh
  (cd proxy && openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout mailman-ssl.key -out mailman-ssl.crt)
  (cd proxy && chmod 400 mailman-ssl.key mailman-ssl.crt)
  ```
  
3. Create Volumes
  This creates the persistent volumes to use. Only run this once per instance.
  ```sh
  ./create-persistent-volumes.sh
  ```
  
4. Build the Images
  ```sh
  docker-compose build
  ```

5. Run It
  ```sh
  docker-compose up -d
  ```

## About
Consists of a proxy that initially receives all requests from the web and smtp.
This proxy runs nginx and postfix to proxy email and the mailman admin
pages between acm.eecs.wsu.edu and hackathon.eecs.wsu.edu. Because of mailman's
limitations, two installations of mailman had to be used for the separate
domains. The mailman containers run a stack of postfix, mailman, and lighttpd.
