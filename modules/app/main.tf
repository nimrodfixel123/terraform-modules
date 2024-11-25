terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "null_resource" "build_app_image" {
  triggers = {
    dockerfile = filemd5("${path.module}/Dockerfile")
    app_py = filemd5("${path.module}/app.py")
  }

  provisioner "local-exec" {
    command = "docker build -t app:latest ${path.module}"
  }
}

resource "docker_image" "app" {
  name         = "app:latest"
  keep_locally = true
  depends_on   = [null_resource.build_app_image]
}

resource "docker_container" "app" {
  name  = var.container_name
  image = docker_image.app.image_id
  
  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 8080
    external = var.external_port
  }

  env = [
    "PYTHONUNBUFFERED=1"
  ]
}