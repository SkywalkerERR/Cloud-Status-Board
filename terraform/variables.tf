variable "yc_sa_key_path" {
  description = "Path to Yandex Cloud service account JSON key"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key for VM access"
  type        = string
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}