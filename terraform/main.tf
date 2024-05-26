terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yandexcloudtoken   #Яндекс клауд токен закинут в переменную variable.tf
  cloud_id  = var.yandexcloud_id     #Яндекс клауд id закинут в переменную variable.tf
  folder_id = "b1g298vjlq4l6jpc5dc4" #Яндекс клауд folder
  zone      = "ru-central1-a"        #"<зона_доступности_по_умолчанию>"
}

#Виртуальная машина №1 для nginx1
resource "yandex_compute_instance" "vm1-nginx1" {
  name = "vm1-nginx1"
  #zone = "ru-central1-a" #добавил я
 

  resources {
    core_fraction = 5 #это параметр прерываемости машины, например 5 - это 5 процентов.
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir"
    }
  }

  #надо править
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}

#надо править
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

#надо править
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

#надо править
output "internal_ip_address_vm1-nginx1" {
  value = yandex_compute_instance.vm1-nginx1.network_interface.0.ip_address
}

#надо править
output "external_ip_address_vm1-nginx1" {
  value = yandex_compute_instance.vm1-nginx1.network_interface.0.nat_ip_address
}

