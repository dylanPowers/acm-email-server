# Mailman Server

Configuration Instructions

### 1. Create Config
Create a file named `mailman-config` with the following contents:
```sh
#!/bin/sh

export ADMIN_EMAIL=<admin-email>
export ADMIN_PASS=<admin-pass>
```

### 2. Build the Image
```sh
docker build -t hackathon-email .
```

### 3. Create Volumes
This creates the persistent volumes to use. Only run this once per instance.
```sh
docker create -v /var/lib/mailman/data \
              -v /var/lib/mailman/lists \
              -v /var/lib/mailman/archives \
              --name hackathon-email-data \
              hackathon-email /bin/true
```

### 4. Run It
```sh
docker run -d -p 8080:80 -p 25:25 \
           --volumes-from hackathon-email-data \
           --name hackathon-email \
           hackathon-email
```
