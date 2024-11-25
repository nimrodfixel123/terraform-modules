terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

module "network" {
  source = "./modules/network"
}

module "app" {
  source       = "./modules/app"
  network_name = module.network.network_name
  container_name = var.app_container_name
  external_port = var.app_external_port
}

module "nginx" {
  source            = "./modules/nginx"
  network_name      = module.network.network_name
  ssl_cert_path     = "nginx/ssl"
  nginx_conf_path   = "nginx/nginx.conf"
  app_container_name = module.app.container_name
  app_container_ip   = module.app.container_ip
  container_name    = var.nginx_container_name
}