# terraform/variables.tf
variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc3"
}

variable "droplet_size" {
  description = "DigitalOcean droplet size"
  type        = string

}

variable "ssh_key_name" {
  description = "Name of SSH key in DigitalOcean"
  type        = string
}

variable "monitoring_domain" {
  description = "Domain name for monitoring stack"
  type        = string
  default     = "ponmile.com.ng"
}

variable "environment" {
  default = "prod"
}

variable "private_key_path" {
  description = "path to the private key"
  default     = "~/.ssh/id_rsa.pub"
}

output "instance_public_ip" {
  description = "Public IP of the monitoring instance"
  value       = digitalocean_droplet.monitoring.ipv4_address
}

output "instance_id" {
  description = "ID of the monitoring instance"
  value       = "monitoring.instance_id"
}

# Add to terraform/variables.tf
variable "ssh_private_key_path" {
  description = "Path to the SSH private key for Ansible"
  type        = string
  default     = "~/.ssh/id_rsa"
}
variable "ssh_private_key_file" {
  description = "Path to the SSH private key file"
  type        = string
  default     = "~/.ssh/id_rsa"
}

