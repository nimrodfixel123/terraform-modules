terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  networks_advanced {
    name = var.network_name
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
    host_path      = abspath("${path.root}/${var.nginx_conf_path}")
    container_path = "/etc/nginx/nginx.conf"
  }
  
  volumes {
    host_path      = abspath("${path.root}/${var.ssl_cert_path}")
    container_path = "/etc/nginx/ssl"
  }

  host {
    host = var.app_container_name
    ip   = var.app_container_ip
  }
}