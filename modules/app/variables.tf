variable "container_name" {
  description = "Name of the app container"
  type        = string
  default     = "app_server"
}

variable "network_name" {
  description = "Name of the docker network"
  type        = string
}

variable "external_port" {
  description = "External port for the app"
  type        = number
  default     = 8080
}