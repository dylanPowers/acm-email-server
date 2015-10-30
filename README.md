# Mailman Server

Configuration Instructions

### 1. Create Config
Create a file named `mailman/mailman-config` with the following contents:
```sh
#!/bin/sh

export ADMIN_EMAIL=<admin-email>
export ADMIN_PASS=<admin-pass>
```

### 2. Generate SSL certs
```sh
(cd router && openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout mailman-ssl.key -out mailman-ssl.crt)
(cd router && chmod 400 mailman-ssl.key mailman-ssl.crt)
```

### 3. Build the Images
```sh
docker-compose build
```

### 4. Create Volumes
This creates the persistent volumes to use. Only run this once per instance.
```sh
./create-persistent-volumes.sh
```

### 5. Run It
```sh
docker-compose up -d
```
