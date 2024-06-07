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
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = false #фолс чтобы не натил
    security_group_ids = [yandex_vpc_security_group.group-ssh-traffic.id, yandex_vpc_security_group.group-vm1-vm2.id]
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
    subnet_id          = yandex_vpc_subnet.subnet-2.id
    nat                = false #фолс чтобы не натил
    security_group_ids = [yandex_vpc_security_group.group-ssh-traffic.id, yandex_vpc_security_group.group-vm1-vm2.id]
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}

#Виртуальная машина №3 для zabbix
resource "yandex_compute_instance" "vm3-zabbix-server" {
  name     = "vm3-zabbix-server"
  hostname = "vm3-zabbix-server"
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
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.group-ssh-traffic.id, yandex_vpc_security_group.group-zabbix.id]
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
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = false #фолс чтобы не натила
    security_group_ids = [yandex_vpc_security_group.group-ssh-traffic.id, yandex_vpc_security_group.group-elasticsearch.id]
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
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.group-ssh-traffic.id, yandex_vpc_security_group.group-kibana.id]
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
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.group-vm6-bastion.id]
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

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet-2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

#НАСТРОЙКИ БАЛАНСИРОВЩИКА

# target group https://yandex.cloud/ru/docs/application-load-balancer/operations/target-group-create

resource "yandex_alb_target_group" "target-group" {
  name = "target-group"
  target {
    subnet_id  = yandex_vpc_subnet.subnet-1.id
    ip_address = yandex_compute_instance.vm1-nginx1.network_interface.0.ip_address
  }
  target {
    subnet_id  = yandex_vpc_subnet.subnet-2.id
    ip_address = yandex_compute_instance.vm2-nginx2.network_interface.0.ip_address
  }
}


# backend group

resource "yandex_alb_backend_group" "backend-group" {
  name = "backend-group"

  http_backend {
    name             = "http-backend"
    weight           = 1
    port             = 80
    target_group_ids = ["${yandex_alb_target_group.target-group.id}"]
    healthcheck {
      timeout  = "10s"
      interval = "2s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

#HTTP router

resource "yandex_alb_http_router" "http-router" {
  name = "http-router"
}

resource "yandex_alb_virtual_host" "dmitrym-virtual-host" {
  name           = "dmitrym-virtual-host"
  http_router_id = yandex_alb_http_router.http-router.id
  route {
    name = "dmitrym-route"

    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
        timeout          = "60s" #или меньший интервал? з
      }
    }
  }
}

#loadbalancer

resource "yandex_alb_load_balancer" "network-load-balancer" {
  name = "load-balancer"

  network_id         = yandex_vpc_network.network-1.id
  security_group_ids = [yandex_vpc_security_group.group-public-network-alb.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet-1.id
    }

    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet-2.id
    }
  }

  listener {
    name = "dmitrym-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id
      }
    }
  }
}

# Security Groups
# For bastion

resource "yandex_vpc_security_group" "group-vm6-bastion" {
  name       = "Security group-vm6-bastion"
  network_id = yandex_vpc_network.network-1.id
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Only incoming ssh traffic
resource "yandex_vpc_security_group" "group-ssh-traffic" {
  name       = "Security group-ssh-traffic"
  network_id = yandex_vpc_network.network-1.id
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }

  ingress {
    protocol       = "ICMP"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }
}

# For webservers vm1-nginx1 and vm2-nginx2 - group-vm1-vm2
resource "yandex_vpc_security_group" "group-vm1-vm2" {
  name       = "Security group vm1-vm2"
  network_id = yandex_vpc_network.network-1.id

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 8080
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 4040
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}


#Security group zabbix 
resource "yandex_vpc_security_group" "group-zabbix" {
  name       = "Security group zabbix"
  network_id = yandex_vpc_network.network-1.id
  ingress {
    protocol       = "ANY"
    port           = 10050
    v4_cidr_blocks = ["192.168.100.0/24", "192.168.101.0/24"]
  }

  ingress {
    protocol       = "ANY"
    port           = 10051
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }
}


# Security group elasticsearch
resource "yandex_vpc_security_group" "group-elasticsearch" {
  name       = "Security group elasticsearch"
  network_id = yandex_vpc_network.network-1.id

  ingress {
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }

  egress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }
}

# Security group kibana
resource "yandex_vpc_security_group" "group-kibana" {
  name       = "Security group kibana"
  network_id = yandex_vpc_network.network-1.id

  ingress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["192.168.30.22/32"]
  }
}

# Security group load balancer
resource "yandex_vpc_security_group" "group-public-network-alb" {
  name       = "Security group load balancer"
  network_id = yandex_vpc_network.network-1.id

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
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
output "internal_ip_address_vm3-zabbix-server" {
  value = yandex_compute_instance.vm3-zabbix-server.network_interface.0.ip_address
}

output "external_ip_address_vm3-zabbix-server" {
  value = yandex_compute_instance.vm3-zabbix-server.network_interface.0.nat_ip_address
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

#СНАПШОТЫ ДИСКОВ
# resource "yandex_compute_snapshot_schedule" "default" {
#   name           = "snapshot"

#   schedule_policy {
#   expression = "0 0 ? * *"
#   }

#   snapshot_count = 7

#   snapshot_spec {
#     description = "snapshot-description"
#     labels = {
#       snapshot-label = "my-snapshot-label-value"
#     }
#   }

#   labels = {
#     my-label = "my-label-value"
#   }

#   disk_ids = [yandex_compute_instance.vm1-nginx1.boot_disk.0.disk_id,
#               yandex_compute_instance.vm2-nginx2.boot_disk.0.disk_id,
#               yandex_compute_instance.vm3-zabbix-server.boot_disk.0.disk_id,
#               yandex_compute_instance.vm4-elasticsearch.boot_disk.0.disk_id,
#               yandex_compute_instance.vm5-kibana.boot_disk.0.disk_id,
#               yandex_compute_instance.vm6-bastion.boot_disk.0.disk_id]
# }
