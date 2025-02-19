# terraform {
#   required_version = ">= 0.14.0"


#   backend "s3" {
#     endpoints = {
#       s3 = "https://monitoring-bucket.nyc3.digitaloceanspaces.com"  # Complete URL with scheme
#     }
#     bucket     = "monitoring-bucket"
#     key        = "./terraform.tfstate"
#     region     = "us-east-1"
#     use_path_style = true
#     skip_credentials_validation = true
#     skip_metadata_api_check     = true
#     skip_region_validation      = true
#     # access_key = var.spaces_access_key  # Define as variable
#     # secret_key = var.spaces_secret_key  # Define as variable
#   }

#   required_providers {
#     digitalocean = {
#       source  = "digitalocean/digitalocean"
#       version = "~> 2.0"
#     }
#   }
# }


# provider "digitalocean" {
#   token = var.do_token
# }

# data "digitalocean_ssh_key" "monitoring" {
#   name = var.ssh_key_name
# }

# resource "digitalocean_droplet" "monitoring" {
#   image    = "ubuntu-20-04-x64"
#   name     = "monitoring-${var.environment}"
#   region   = var.region
#   size     = var.droplet_size
#   ssh_keys = [data.digitalocean_ssh_key.monitoring.id]

#   tags = ["monitoring", var.environment]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "digitalocean_firewall" "monitoring" {
#   name = "monitoring-firewall"

#   droplet_ids = [digitalocean_droplet.monitoring.id]

#   inbound_rule {
#     protocol         = "tcp"
#     port_range       = "22"
#     source_addresses = ["0.0.0.0/0", "::/0"]
#   }

#   inbound_rule {
#     protocol         = "tcp"
#     port_range       = "80"
#     source_addresses = ["0.0.0.0/0", "::/0"]
#   }

#   inbound_rule {
#     protocol         = "tcp"
#     port_range       = "443"
#     source_addresses = ["0.0.0.0/0", "::/0"]
#   }
# }

# # Optional: Add DNS records if domain is provided
# resource "digitalocean_domain" "monitoring" {
#   count      = var.monitoring_domain != "" ? 1 : 0
#   name       = var.monitoring_domain
#   ip_address = digitalocean_droplet.monitoring.ipv4_address
# }

# resource "digitalocean_record" "grafana" {
#   count  = var.monitoring_domain != "" ? 1 : 0
#   domain = digitalocean_domain.monitoring[0].name
#   type   = "A"
#   name   = "grafana"
#   value  = digitalocean_droplet.monitoring.ipv4_address
# }

# resource "digitalocean_record" "prometheus" {
#   count  = var.monitoring_domain != "" ? 1 : 0
#   domain = digitalocean_domain.monitoring[0].name
#   type   = "A"
#   name   = "prometheus"
#   value  = digitalocean_droplet.monitoring.ipv4_address
# }

# resource "digitalocean_record" "loki" {
#   count  = var.monitoring_domain != "" ? 1 : 0
#   domain = digitalocean_domain.monitoring[0].name
#   type   = "A"
#   name   = "loki"
#   value  = digitalocean_droplet.monitoring.ipv4_address
# }

# resource "digitalocean_record" "alertmanager" {
#   count  = var.monitoring_domain != "" ? 1 : 0
#   domain = digitalocean_domain.monitoring[0].name
#   type   = "A"
#   name   = "alertmanager"
#   value  = digitalocean_droplet.monitoring.ipv4_address
# }

# # Optional: Add DigitalOcean Monitoring
# resource "digitalocean_monitor_alert" "cpu_alert" {
#   alerts {
#     email = ["senininety97@gmail.com"]
#   }
#   window      = "5m"
#   type        = "v1/insights/droplet/cpu"
#   compare     = "GreaterThan"
#   value       = 90
#   enabled     = true
#   entities    = [digitalocean_droplet.monitoring.id]
#   description = "CPU usage alert for monitoring stack"
# }

# resource "null_resource" "ansible_provisioner" {
#   depends_on = [digitalocean_droplet.monitoring] # Updated dependency

#   provisioner "local-exec" {
#     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory/hosts.yml ansible/site.yml"
#   }
# }




#  terraform {
#   required_version = ">= 0.14.0"

#   backend "s3" {
#     endpoints = {
#       s3 = "https://nyc3.digitaloceanspaces.com"  # Use the correct endpoint for your region
#     }
#     bucket                      = "monitoring-bucket"  # Replace with your Spaces bucket name
#     key                         = "terraform.tfstate"  # Path to the state file in the bucket
#     region                      = "us-east-1"          # Required but ignored by DigitalOcean Spaces
#     skip_credentials_validation = true                 # Skip AWS credential validation
#     skip_metadata_api_check     = true                 # Skip AWS metadata API check
#     skip_region_validation      = true                 # Skip AWS region validation
#     force_path_style            = true                 # Required for DigitalOcean Spaces
#   }

terraform {
  required_version = ">= 0.14.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "monitoring" {
  name = var.ssh_key_name
}

resource "digitalocean_droplet" "monitoring" {
  image    = "ubuntu-20-04-x64"
  name     = "monitoring-${var.environment}"
  region   = var.region
  size     = var.droplet_size
  ssh_keys = [data.digitalocean_ssh_key.monitoring.id]

  tags = ["monitoring", var.environment]

  lifecycle {
    create_before_destroy = true
  }
}


resource "digitalocean_firewall" "monitoring" {
  name = "monitoring-firewall"

  droplet_ids = [digitalocean_droplet.monitoring.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Outbound rules: Allow all outbound traffic
  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

# Optional: Add DNS records if domain is provided
resource "digitalocean_domain" "monitoring" {
  count      = var.monitoring_domain != "" ? 1 : 0
  name       = var.monitoring_domain
  ip_address = digitalocean_droplet.monitoring.ipv4_address
}

resource "digitalocean_record" "grafana" {
  count  = var.monitoring_domain != "" ? 1 : 0
  domain = digitalocean_domain.monitoring[0].name
  type   = "A"
  name   = "grafana"
  value  = digitalocean_droplet.monitoring.ipv4_address
  ttl    = 1800 # Explicitly set TTL to 1800 seconds (30 minutes)
}

resource "digitalocean_record" "prometheus" {
  count  = var.monitoring_domain != "" ? 1 : 0
  domain = digitalocean_domain.monitoring[0].name
  type   = "A"
  name   = "prometheus"
  value  = digitalocean_droplet.monitoring.ipv4_address
  ttl    = 1800 # Explicitly set TTL to 1800 seconds (30 minutes)
}

resource "digitalocean_record" "loki" {
  count  = var.monitoring_domain != "" ? 1 : 0
  domain = digitalocean_domain.monitoring[0].name
  type   = "A"
  name   = "loki"
  value  = digitalocean_droplet.monitoring.ipv4_address
  ttl    = 1800 # Explicitly set TTL to 1800 seconds (30 minutes)
}

resource "digitalocean_record" "alertmanager" {
  count  = var.monitoring_domain != "" ? 1 : 0
  domain = digitalocean_domain.monitoring[0].name
  type   = "A"
  name   = "alertmanager"
  value  = digitalocean_droplet.monitoring.ipv4_address
  ttl    = 1800 # Explicitly set TTL to 1800 seconds (30 minutes)
}

# Optional: Add DigitalOcean Monitoring
resource "digitalocean_monitor_alert" "cpu_alert" {
  alerts {
    email = ["senininety97@gmail.com"]
  }
  window      = "5m"
  type        = "v1/insights/droplet/cpu"
  compare     = "GreaterThan"
  value       = 90
  enabled     = true
  entities    = [digitalocean_droplet.monitoring.id]
  description = "CPU usage alert for monitoring stack"
}

resource "null_resource" "ansible_provisioner" {
  depends_on = [digitalocean_droplet.monitoring]


  provisioner "local-exec" {
    command = "set ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook -i ../ansible/inventory/hosts.yml ../ansible/site.yml"
  }
}

resource "local_file" "ansible_inventory" {
  content  = <<-EOT
    ---
    all:
      hosts:
        monitoring:
          ansible_host: ${digitalocean_droplet.monitoring.ipv4_address}
          ansible_user: root
          ansible_ssh_private_key_file: "~/.ssh/id_rsa"
          monitoring_domain: ${var.monitoring_domain}
  EOT
  filename = "${path.root}/../ansible/inventory/hosts.yml"
}

