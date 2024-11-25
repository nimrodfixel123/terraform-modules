variable "app_external_port" {
  description = "External port for the app container"
  type        = number
  default     = 8080
}

variable "network_name" {
  description = "Name of the docker network"
  type        = string
  default     = "app_network"
}

variable "app_container_name" {
  description = "Name of the app container"
  type        = string
  default     = "app_server"
}

variable "nginx_container_name" {
  description = "Name of the nginx container"
  type        = string
  default     = "nginx_lb"
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "myapp.local"
}

variable "ssl_cert_path" {
  description = "Path to SSL certificates directory"
  type        = string
  default     = "nginx/ssl"
}