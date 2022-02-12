
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

### _Ответ:_
- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
    - Автоматизация - ручная работа переносится на реюзабельный файл конфигурации
    - Масштабируемость - мы можем использовать одну и туже конфигурацию для сотен серверов
    - Гибкость - внесение измений рабочее окружения, требует намного меньших ресурсов
    - Надёжность - за счёт, сокращение человеческого фактора и идентичности окружения
- Какой из принципов IaaC является основополагающим?
    - Основопологающий принцип IaaC - заключается в том, что рабочее окружение не настраивается непосредственно на сервере,
  а описывается файлом конфигурации, декларативным(указываем что хотим получить) либо императивным(указываем что сделать) способой
## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

### _Ответ:_
- Чем Ansible выгодно отличается от других систем управление конфигурациями?
    - Ansible - свободно распространяем, большое комьюнити, много различных модулей
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
    - На мой взгляд push метод более надёжен - т.к даёт большее чувство контроля

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

### _Решение:_
1. Установка Virtualbox

```nariman@nariman:~$ sudo apt-get install virtualbox-6.1```
```commandline
nariman@nariman:~$ vboxmanage --version
6.1.30r148432
```
2. Установка Vagrant

```nariman@nariman:~$ sudo apt-get update && sudo apt-get install vagrant```
```commandline
nariman@nariman:~$ vagrant --version
Vagrant 2.2.19
```
3. Установка Ansible

```nariman@nariman:~$ sudo apt install ansible```
```commandline
nariman@nariman:~$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/nariman/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Nov 26 2021, 20:14:08) [GCC 9.3.0]
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

```commandline
nariman@nariman:~/PycharmProjects/devops-netology/05-virt-02-iaac/src/vagrant$ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: 
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology: 
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/nariman/PycharmProjects/devops-netology/05-virt-02-iaac/src/vagrant
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```


```commandline
nariman@nariman:~/PycharmProjects/devops-netology/05-virt-02-iaac/src/vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 System information disabled due to load higher than 1.0


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sun Jan 23 12:47:39 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ 

```
