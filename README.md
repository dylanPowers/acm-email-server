# Mailman Server

Configuration Instructions

### 1. Create Volumes
This creates the persistent volumes to use. Only run this once per instance.
```sh
docker create -v /var/lib/mailman/data \
              -v /var/lib/mailman/lists \
              -v /var/lib/mailman/archives \
              --name hackathon-email-data \
              ubuntu:14.04 /bin/true
```

### 2, Create Config
Create a file named `mailman-config` with the following contents:
```sh
#!/bin/sh

export ADMIN_EMAIL=<admin-email>
export ADMIN_PASS=<admin-pass>
```

### 3. Build the Image
```sh
docker build -t hackathon-email .
```

### 4. Run It
```sh
docker run -d -p 8080:80 -p 25:25 \
           --volumes-from hackathon-email-data \
           --name hackathon-email \
           hackathon-email
```
