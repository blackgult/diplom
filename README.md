
#  Дипломная работа по профессии «Системный администратор» - Михайлов Дмитрий

==========

## Требования к дипломной работе по [ссылке](https://github.com/netology-code/sys-diplom)

==========

#  РЕШЕНИЕ

## Инфраструктура
Для развёртки инфраструктуры используется [terraform - код доступен по ссылке](https://github.com/blackgult/diplom/tree/main/terraform) и [ansible - код доступен по ссылке](https://github.com/blackgult/diplom/tree/main/ansible).  

Для ansible использованы fqdn имена виртуальных машин - [файл ansible host](https://github.com/blackgult/diplom/blob/main/ansible/hosts)

### Сайт
Создайте две ВМ в разных зонах, установите на них сервер nginx, если его там нет. ОС и содержимое ВМ должно быть идентичным, это будут наши веб-сервера.

Используйте набор статичных файлов для сайта. Можно переиспользовать сайт из домашнего задания.

Виртуальные машины не должны обладать внешним Ip-адресом, те находится во внутренней сети. Доступ к ВМ по ssh через бастион-сервер. Доступ к web-порту ВМ через балансировщик yandex cloud.

Созданные мной машины:

![1](https://github.com/blackgult/diplom/blob/main/pic/1.PNG)

Настройка балансировщика:

Создайте [Target Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/target-group), включите в неё две созданных ВМ.

![2](https://github.com/blackgult/diplom/blob/main/pic/2.PNG)

Создайте [Backend Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/backend-group), настройте backends на target group, ранее созданную. Настройте healthcheck на корень (/) и порт 80, протокол HTTP. - настройки бэкэнд группы написаны в файле main.tf терраформа

![backend](https://github.com/blackgult/diplom/blob/main/pic/backend.PNG)

Создайте [HTTP router](https://cloud.yandex.com/docs/application-load-balancer/concepts/http-router). Путь укажите — /, backend group — созданную ранее.

![3](https://github.com/blackgult/diplom/blob/main/pic/3.PNG)

Создайте [Application load balancer](https://cloud.yandex.com/en/docs/application-load-balancer/) для распределения трафика на веб-сервера, созданные ранее. Укажите HTTP router, созданный ранее, задайте listener тип auto, порт 80.

![4](https://github.com/blackgult/diplom/blob/main/pic/4.PNG)

Протестируйте сайт
`curl -v <публичный IP балансера>:80` 

![5](https://github.com/blackgult/diplom/blob/main/pic/5.PNG)

![6](https://github.com/blackgult/diplom/blob/main/pic/6.PNG)

Сайт доступен по ссылке (http://158.160.176.135:80)

![14](https://github.com/blackgult/diplom/blob/main/pic/14.PNG)

![13](https://github.com/blackgult/diplom/blob/main/pic/13.PNG)


### Мониторинг
Создайте ВМ, разверните на ней Zabbix. На каждую ВМ установите Zabbix Agent, настройте агенты на отправление метрик в Zabbix. 

Настройте дешборды с отображением метрик, минимальный набор — по принципу USE (Utilization, Saturation, Errors) для CPU, RAM, диски, сеть, http запросов к веб-серверам. Добавьте необходимые tresholds на соответствующие графики.

Заббикс доступен по ссылке (http://178.154.240.6:8080)

Имя: Admin

Пароль: zabbix

Отслеживаемые хосты:
![7](https://github.com/blackgult/diplom/blob/main/pic/7.PNG)

Настроенные дашборды
![8](https://github.com/blackgult/diplom/blob/main/pic/8.PNG)

### Логи
Cоздайте ВМ, разверните на ней Elasticsearch. Установите filebeat в ВМ к веб-серверам, настройте на отправку access.log, error.log nginx в Elasticsearch.

Создайте ВМ, разверните на ней Kibana, сконфигурируйте соединение с Elasticsearch.

Kibana доступна по ссылке (http://178.154.240.72:5601/app/discover#/?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-15m,to:now))&_a=(columns:!(),filters:!(),index:'filebeat-*',interval:auto,query:(language:kuery,query:''),sort:!(!('@timestamp',desc))))

Скриншот кибаны:
![9](https://github.com/blackgult/diplom/blob/main/pic/9.PNG)

### Сеть
Разверните один VPC. Сервера web, Elasticsearch поместите в приватные подсети. Сервера Zabbix, Kibana, application load balancer определите в публичную подсеть.

Настройте [Security Groups](https://cloud.yandex.com/docs/vpc/concepts/security-groups) соответствующих сервисов на входящий трафик только к нужным портам.

![10](https://github.com/blackgult/diplom/blob/main/pic/10.PNG)

Настройте ВМ с публичным адресом, в которой будет открыт только один порт — ssh.  Эта вм будет реализовывать концепцию  [bastion host]( https://cloud.yandex.ru/docs/tutorials/routing/bastion) . Синоним "bastion host" - "Jump host". Подключение  ansible к серверам web и Elasticsearch через данный bastion host можно сделать с помощью  [ProxyCommand](https://docs.ansible.com/ansible/latest/network/user_guide/network_debug_troubleshooting.html#network-delegate-to-vs-proxycommand) . Допускается установка и запуск ansible непосредственно на bastion host.(Этот вариант легче в настройке)

![11](https://github.com/blackgult/diplom/blob/main/pic/11.PNG)

Исходящий доступ в интернет для ВМ внутреннего контура через [NAT-шлюз](https://yandex.cloud/ru/docs/vpc/operations/create-nat-gateway).

### Резервное копирование
Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.

Настройки снапшотов находятся в конце файла main.tf

Скриншот:

![12](https://github.com/blackgult/diplom/blob/main/pic/12.PNG)


### Дополнительные скриншоты

anspingpong

![anspingpong](https://github.com/blackgult/diplom/blob/main/pic/anspingpong.PNG)

sshconnect - я ходил на машины используя команду ssh -A -J dmitrym@158.160.45.144 dmitrym@vm1-nginx1 (и далее аналогично на каждую машину)

![sshconnect](https://github.com/blackgult/diplom/blob/main/pic/sshconnect.PNG)

vm1statusfilebeat

![vm1statusfilebeat](https://github.com/blackgult/diplom/blob/main/pic/vm1statusfilebeat.PNG)

vm1statusnginx

![vm1statusnginx](https://github.com/blackgult/diplom/blob/main/pic/vm1statusnginx.PNG)

vm2statusfilebeat

![vm2statusfilebeat](https://github.com/blackgult/diplom/blob/main/pic/vm2statusfilebeat.PNG)

vm2statusnginx

![vm2statusnginx](https://github.com/blackgult/diplom/blob/main/pic/vm2statusnginx.PNG)

vm4elastic

![vm4elastic](https://github.com/blackgult/diplom/blob/main/pic/vm4elastic.PNG)

#  ПРАВКИ

_Но вот это надо зашифровать через ansible-vault - password_db: dmitrym_

Шифрование пароля я сделал таким образом:

Сначала ввёл команду ansible-vault encrypt_string

Потом ввёл пароль New Vault password: (не dmitrym, другой пароль))))))

Потом ввёл пароль ещё раз Confirm New Vault password: 

Потом ввёл строку dmitrym, потому что dmitrym мне надо зашифровать. Обязательно для завершения ввода необходимо нажимать ctrl-d. 

Результат на скриншоте:

![ispravlenie1](https://github.com/blackgult/diplom/blob/main/pic/ispravlenie1.PNG)


Потом я этот секрет добавил в свой файл playbook.yml

![ispravlenie2](https://github.com/blackgult/diplom/blob/main/pic/ispravlenie2.PNG)


Для того чтобы плебук сделал плэй успешно необходимо ввести команду ansible-playbook playbook.yml --ask-vault-pass нажать клавишу enter и ввести пароль от секрета

![ispravlenie3](https://github.com/blackgult/diplom/blob/main/pic/ispravlenie3.PNG)


### Исправленный файл playbook.yml доступен по ссылке - https://github.com/blackgult/diplom/blob/main/ansible/playbook.yml
