
# Inngest Setup Instructions
This guide will help you manually install Inngest and Redis, generate the necessary keys, and run the Inngest service.

## Prerequisites

Ensure you have the following installed on your system:

Node.js (version 18 or higher)
Redis
npm (comes with Node.js)

### Step 1: Install Inngest CLI

To install the inngest-cli globally, run the following command:

```bash
npm install -g inngest-cli
```
This command installs the inngest command-line tool, allowing you to start and manage Inngest services.

### Step 2: Install and Start Redis

ollow the official Redis installation guide to install Redis.

Start the Redis server:

```bash
redis-server
```
Verify that Redis is running by checking the status or using the redis-cli ping command:

```bash
redis-cli ping
# Output: PONG
```


### Step 3: Generate Event and Signing Keys
Before starting the Inngest service, you need to generate the event key and signing key:

Generate an Event Key:

```bash
openssl rand -hex 16
```
Copy and store the generated event key securely.

Generate a Signing Key:
```bash
openssl rand -hex 32
```
Copy and store the generated signing key securely.

### Step 4: Start Inngest
Run the inngest command with the generated keys and the Redis URI:

```bash
inngest start --event-key <YOUR_EVENT_KEY> --signing-key <YOUR_SIGNING_KEY> --redis-uri redis://localhost:6379
```
Replace:

<YOUR_EVENT_KEY> with the event key you generated.
<YOUR_SIGNING_KEY> with the signing key you generated.
Adjust redis://localhost:6379 if your Redis configuration uses a different URI.

### Step 5: Configure Nginx
Add the following configuration to your nginx.conf. Be sure to replace your_domain_name with your own domain name .

```nginx
events {}

http {
    server {
        listen 80;
        server_name your_domain_name;

        location /.well-known/acme-challenge/ {
            root /var/www/html;
        }

        location / {
            proxy_pass http://inngest:8288;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            auth_basic "Restricted Access";
            auth_basic_user_file /etc/nginx/.htpasswd;
        }
    }

    server {
        listen 443 ssl;
        server_name your_domain_name;

        ssl_certificate /etc/letsencrypt/live/your_domain_name/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/your_domain_name/privkey.pem;

        location / {
            proxy_pass http://inngest:8288;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            auth_basic "Restricted Access";
            auth_basic_user_file /etc/nginx/.htpasswd;
        }
    }
}
```
### Step 6: Get SSL Certificates Using Certbot
Before starting Nginx, you will need to obtain the SSL certificates for your domain. Run Certbot in standalone mode to generate the certificates:

```bash
certbot certonly --standalone -d your_domain_name
```
This will generate the necessary SSL certificates at /etc/letsencrypt/live/your_domain_name/.

Once the certificates are in place, you can start Nginx using the configuration in Step 5.

