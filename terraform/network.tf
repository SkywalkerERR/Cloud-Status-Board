data "yandex_vpc_network" "main" {
  name = "default"
}

data "yandex_vpc_subnet" "main" {
  name = "default-ru-central1-a" # проверь точное имя в yc vpc subnet list
}

resource "yandex_vpc_security_group" "main" {
  name       = "status-board-sg"
  network_id = data.yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all egress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}