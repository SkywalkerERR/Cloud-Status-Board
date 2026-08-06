output "vm_external_ip" {
  value = yandex_compute_instance.app.network_interface[0].nat_ip_address
}

output "vm_name" {
  value = yandex_compute_instance.app.name
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/yc_status_board ${var.ssh_username}@${yandex_compute_instance.app.network_interface[0].nat_ip_address}"
}