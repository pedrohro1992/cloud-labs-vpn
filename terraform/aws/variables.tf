variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
  default     = "pivpn"
}

variable "server_protocol" {
  description = "Protocol for the server"
  type        = string
  default     = "tcp"
}

variable "ssh_server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 22
}

variable "pivpn_protocol" {
  description = "The protocol for communicate with the PiVPN"
  type        = string
  default     = "UDP"
}


variable "pivpn_port" {
  description = "The port witch the vpn appliance will listen on"
  type        = number
  default     = 51820
}

variable "public_cidr_blocks" {
  description = "CIDR block to enable public access on the Load Balance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

