# Docker Nginx Load Balancer with SSL

This project sets up a multi-container environment using Terraform, with Nginx as a load balancer and SSL configuration. The setup includes two containers:
- An Nginx container configured with HTTPS that forwards requests to the app container
- An app container that responds with "Hello World"

## Prerequisites

Before running this project, you need to have the following installed:
- Docker
- Terraform
- OpenSSL
- curl (for testing)

For detailed installation instructions, see [INSTALL.md](INSTALL.md).

## Quick Start

1. Clone the repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Run the setup script:
```bash
chmod +x setup.sh
./setup.sh
```

3. Access the application:
   - https://myapp.local
   - https://localhost

Note: You might need to accept the self-signed certificate in your browser.

## Project Structure

```
project/
├── main.tf                 # Terraform configuration
├── setup.sh               # Setup script
├── nginx.conf             # Nginx configuration
├── app/
│   ├── Dockerfile        # App container configuration
│   └── app.py           # Simple Python web server
├── nginx/
│   ├── conf/            # Nginx configuration directory
│   └── ssl/            # SSL certificates directory
├── README.md            # This file
├── INSTALL.md          # Installation instructions
└── .gitignore         # Git ignore file
```

## Features

- Automated setup using Terraform
- SSL/HTTPS configuration
- DNS redirection through /etc/hosts
- Docker networking between containers
- Simple Python web application
- Nginx reverse proxy and load balancer

## Testing

The setup script includes various tests to ensure everything is working correctly. You can manually test the setup using:

```bash
# Test HTTP to HTTPS redirect
curl http://myapp.local

# Test HTTPS endpoints
curl -k https://myapp.local
curl -k https://localhost
```

## Troubleshooting

If you encounter any issues:

1. Check container status:
```bash
docker ps
```

2. View container logs:
```bash
docker logs nginx_lb
docker logs app_server
```

3. Verify DNS resolution:
```bash
ping myapp.local
```

4. Check SSL certificate:
```bash
openssl s_client -connect localhost:443
```

## Cleanup

To remove all resources:
```bash
terraform destroy -auto-approve
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.