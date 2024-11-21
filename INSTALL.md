# Installation Guide

This document provides detailed installation instructions for all required dependencies.

## System Requirements

- Operating System: Linux or macOS
- Memory: 2GB RAM minimum
- Disk Space: 1GB free space minimum
- Internet connection for downloading dependencies

## Required Software

### 1. Docker

#### macOS
1. Install Docker Desktop:
```bash
brew install --cask docker
```
Or download from [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)

#### Linux (Ubuntu/Debian)
```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up stable repository
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add your user to the docker group
sudo usermod -aG docker $USER
```

### 2. Terraform

#### macOS
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

#### Linux (Ubuntu/Debian)
```bash
# Add HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# Add HashiCorp repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Install Terraform
sudo apt-get update
sudo apt-get install terraform
```

### 3. OpenSSL

#### macOS
```bash
brew install openssl
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install openssl
```

### 4. curl

#### macOS
```bash
brew install curl
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install curl
```

## Verification

After installation, verify that everything is installed correctly:

```bash
# Check Docker
docker --version

# Check Terraform
terraform --version

# Check OpenSSL
openssl version

# Check curl
curl --version
```

## Post-Installation

1. For Docker on Linux, log out and log back in for the group membership to take effect.

2. For Docker on macOS, start Docker Desktop application.

3. Verify Docker is running:
```bash
docker run hello-world
```

## Troubleshooting

### Common Issues

1. Docker permission denied:
```bash
# Add current user to docker group
sudo usermod -aG docker $USER
# Log out and log back in
```

2. Terraform not found:
```bash
# Make sure HashiCorp repository is properly added
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```

3. Port conflicts:
```bash
# Check if ports 80/443 are in use
sudo lsof -i :80
sudo lsof -i :443
```

### Getting Help

If you encounter any issues during installation:

1. Check the official documentation:
   - [Docker Documentation](https://docs.docker.com/)
   - [Terraform Documentation](https://learn.hashicorp.com/terraform)

2. Report issues on the project's issue tracker

3. Review the README.md for project-specific troubleshooting