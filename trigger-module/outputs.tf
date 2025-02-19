output "droplet_ip" {
  description = "The public IPv4 address of the monitoring Droplet."
  value       = digitalocean_droplet.monitoring.ipv4_address
}

output "droplet_id" {
  description = "The ID of the monitoring Droplet."
  value       = digitalocean_droplet.monitoring.id
}

output "firewall_id" {
  description = "The ID of the firewall attached to the Droplet."
  value       = digitalocean_firewall.monitoring.id
}

output "dns_records" {
  description = "Details of DNS records for monitoring."
  value = {
    grafana      = digitalocean_record.grafana.*.fqdn
    prometheus   = digitalocean_record.prometheus.*.fqdn
    loki         = digitalocean_record.loki.*.fqdn
    alertmanager = digitalocean_record.alertmanager.*.fqdn
  }

}

output "monitor_alert_id" {
  description = "The ID of the CPU usage monitoring alert."
  value       = digitalocean_monitor_alert.cpu_alert.id
}

output "ansible_provision_status" {
  description = "Status of the Ansible provisioning script."
  value       = null_resource.ansible_provisioner.id
}
