data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "boot" {
  name     = "status-board-boot"
  type     = "network-hdd"
  zone     = var.zone
  size     = 20
  image_id = data.yandex_compute_image.ubuntu.id
}

resource "yandex_compute_instance" "app" {
  name        = "status-board-vm"
  platform_id = "standard-v3"
  zone        = var.zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot.id
  }

  network_interface {
    subnet_id          = data.yandex_vpc_subnet.main.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.main.id]
  }

  metadata = {
    enable-oslogin = "false"
    ssh-keys       = "${var.ssh_username}:${trimspace(file(var.ssh_public_key_path))}"
    }
}