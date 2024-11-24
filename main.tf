terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "app_network"
  driver = "bridge"
  internal = false
}

# App Container
resource "docker_container" "app" {
  name  = "app_server"
  image = docker_image.app.image_id
  
  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 8080
    external = 8080
  }

  env = [
    "PYTHONUNBUFFERED=1"
  ]
}

# Nginx Container
resource "docker_container" "nginx" {
  name  = "nginx_lb"
  image = docker_image.nginx.image_id
  
  depends_on = [docker_container.app]

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 443
    external = 443
  }
  
  ports {
    internal = 80
    external = 80
  }

  volumes {
    host_path      = "${abspath(path.module)}/nginx.conf"
    container_path = "/etc/nginx/nginx.conf"
  }
  
  volumes {
    host_path      = "${abspath(path.module)}/nginx/ssl"
    container_path = "/etc/nginx/ssl"
  }

  host {
    host = "app_server"
    ip   = docker_container.app.network_data[0].ip_address
  }
}

# Nginx Image
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

# App Image
resource "docker_image" "app" {
  name         = "app:latest"
  keep_locally = true
  depends_on   = [null_resource.build_app_image]
}

# Build the app image
resource "null_resource" "build_app_image" {
  provisioner "local-exec" {
    command = "docker build -t app:latest ./app"
  }
}

# Output the container IPs
output "nginx_container_ip" {
  value = docker_container.nginx.network_data[0].ip_address
}

output "app_container_ip" {
  value = docker_container.app.network_data[0].ip_address
}