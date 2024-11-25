variable "container_name" {
  description = "Name of the nginx container"
  type        = string
  default     = "nginx_lb"
}

variable "network_name" {
  description = "Name of the docker network"
  type        = string
}

variable "ssl_cert_path" {
  description = "Path to SSL certificates"
  type        = string
}

variable "nginx_conf_path" {
  description = "Path to nginx configuration file"
  type        = string
}

variable "app_container_name" {
  description = "Name of the app container"
  type        = string
}

variable "app_container_ip" {
  description = "IP of the app container"
  type        = string
}