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
  name     = "vm1-nginx1"
  hostname = "vm1-nginx1"
  zone     = "ru-central1-a"

  resources {
    core_fraction = 5 #это параметр прерываемости машины, например 5 - это 5 процентов.
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir"
      size     = 10
      type     = "network-hdd"
    }
  }

  #Эта машина в приватной сети
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = false #фолс чтобы не натил
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}

#Виртуальная машина №2 для nginx2
resource "yandex_compute_instance" "vm2-nginx2" {
  name     = "vm2-nginx2"
  hostname = "vm2-nginx2"
  zone     = "ru-central1-b"

  resources {
    core_fraction = 5 #это параметр прерываемости машины, например 5 - это 5 процентов.
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir"
      size     = 10
      type     = "network-hdd"
    }
  }

  #Эта машина в приватной сети
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = false #фолс чтобы не натил
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}

#Виртуальная машина №3 для zabbix
resource "yandex_compute_instance" "vm3-zabbix" {
  name     = "vm3-zabbix"
  hostname = "vm3-zabbix"
  #zone = "ru-central1-a" #добавил я

  resources {
    core_fraction = 5 #это параметр прерываемости машины, например 5 - это 5 процентов.
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir"
      size     = 10
      type     = "network-hdd"
    }
  }

  #эта машина должна быть и в приватной и в публичной сети
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}

#Виртуальная машина №4 для elasticsearch
resource "yandex_compute_instance" "vm4-elasticsearch" {
  name     = "vm4-elasticsearch"
  hostname = "vm4-elasticsearch"
  #zone = "ru-central1-a" #добавил я

  resources {
    core_fraction = 5 #это параметр прерываемости машины, например 5 - это 5 процентов.
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir"
      size     = 10
      type     = "network-hdd"
    }
  }

  #Эта машина в приватной сети
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = false #фолс чтобы не натила
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}


#Виртуальная машина №5 для kibana
resource "yandex_compute_instance" "vm5-kibana" {
  name     = "vm5-kibana"
  hostname = "vm5-kibana"
  #zone = "ru-central1-a" #добавил я

  resources {
    core_fraction = 5 #это параметр прерываемости машины, например 5 - это 5 процентов.
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir"
      size     = 10
      type     = "network-hdd"
    }
  }

  #эта машина должна быть и в приватной и в публичной сети
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}


#Виртуальная машина №6 для bastion
resource "yandex_compute_instance" "vm6-bastion" {
  name     = "vm6-bastion"
  hostname = "vm6-bastion"
  #zone = "ru-central1-a" #добавил я

  resources {
    core_fraction = 5 #это параметр прерываемости машины, например 5 - это 5 процентов.
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir"
      size     = 10
      type     = "network-hdd"
    }
  }

  #эта машина должна быть и в приватной и в публичной сети
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}

#Виртуальная машина №7 для loadbalancer ЭТО Я УДАЛЮ, НАСТРОЮ ЧЕРЕЗ ЯНДЕКС КЛАУД.
resource "yandex_compute_instance" "vm7-loadbalancer" {
  name     = "vm7-loadbalancer"
  hostname = "vm7-loadbalancer"
  #zone = "ru-central1-a" #добавил я

  resources {
    core_fraction = 5 #это параметр прерываемости машины, например 5 - это 5 процентов.
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir"
      size     = 10
      type     = "network-hdd"
    }
  }

  #эта машина должна быть и в приватной и в публичной сети
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}


#СЕТИ
resource "yandex_vpc_network" "network-1" {
  name = "network-1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

#АУТПУТЫ

output "internal_ip_address_vm1-nginx1" {
  value = yandex_compute_instance.vm1-nginx1.network_interface.0.ip_address
}

output "external_ip_address_vm1-nginx1" {
  value = yandex_compute_instance.vm1-nginx1.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm2-nginx2" {
  value = yandex_compute_instance.vm2-nginx2.network_interface.0.ip_address
}

output "external_ip_address_vm2-nginx2" {
  value = yandex_compute_instance.vm2-nginx2.network_interface.0.nat_ip_address
}
output "internal_ip_address_vm3-zabbix" {
  value = yandex_compute_instance.vm3-zabbix.network_interface.0.ip_address
}

output "external_ip_address_vm3-zabbix" {
  value = yandex_compute_instance.vm3-zabbix.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm4-elasticsearch" {
  value = yandex_compute_instance.vm4-elasticsearch.network_interface.0.ip_address
}

output "external_ip_address_vm4-elasticsearch" {
  value = yandex_compute_instance.vm4-elasticsearch.network_interface.0.nat_ip_address
}
output "internal_ip_address_vm5-kibana" {
  value = yandex_compute_instance.vm5-kibana.network_interface.0.ip_address
}

output "external_ip_address_vm5-kibana" {
  value = yandex_compute_instance.vm5-kibana.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm6-bastion" {
  value = yandex_compute_instance.vm6-bastion.network_interface.0.ip_address
}

output "external_ip_address_vm6-bastion" {
  value = yandex_compute_instance.vm6-bastion.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm7-loadbalancer" {
  value = yandex_compute_instance.vm7-loadbalancer.network_interface.0.ip_address
}

output "external_ip_address_vm7-loadbalancer" {
  value = yandex_compute_instance.vm7-loadbalancer.network_interface.0.nat_ip_address
}
