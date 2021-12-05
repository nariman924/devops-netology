# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

```commandline
nariman@nariman:~$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp0s31f6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 2c:4d:54:d7:9a:54 brd ff:ff:ff:ff:ff:ff
3: br-7e71df33a9da: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:22:4c:a6:43 brd ff:ff:ff:ff:ff:ff
4: br-ac57830f12e2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:95:0a:71:e2 brd ff:ff:ff:ff:ff:ff
5: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:86:b3:24:7d brd ff:ff:ff:ff:ff:ff
6: br-1e8ae9573d9f: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:46:9a:a8:ec brd ff:ff:ff:ff:ff:ff
7: br-52109bfcfb31: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:70:db:af:7a brd ff:ff:ff:ff:ff:ff

```

```commandline
nariman@nariman:~$ ifconfig
br-1e8ae9573d9f Link encap:Ethernet  HWaddr 02:42:46:9a:a8:ec  
          inet addr:172.21.0.1  Bcast:0.0.0.0  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

br-52109bfcfb31 Link encap:Ethernet  HWaddr 02:42:70:db:af:7a  
          inet addr:172.18.0.1  Bcast:0.0.0.0  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

br-7e71df33a9da Link encap:Ethernet  HWaddr 02:42:22:4c:a6:43  
          inet addr:172.19.0.1  Bcast:0.0.0.0  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

br-ac57830f12e2 Link encap:Ethernet  HWaddr 02:42:95:0a:71:e2  
          inet addr:172.20.0.1  Bcast:0.0.0.0  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

docker0   Link encap:Ethernet  HWaddr 02:42:86:b3:24:7d  
          inet addr:172.17.0.1  Bcast:0.0.0.0  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

enp0s31f6 Link encap:Ethernet  HWaddr 2c:4d:54:d7:9a:54  
          inet addr:192.168.0.164  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::c4fa:9e7e:b759:7774/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:15723 errors:0 dropped:0 overruns:0 frame:0
          TX packets:10926 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:15712718 (15.7 MB)  TX bytes:2552281 (2.5 MB)
          Interrupt:16 Память:f7100000-f7120000 

lo        Link encap:Локальная петля (Loopback)  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:4180 errors:0 dropped:0 overruns:0 frame:0
          TX packets:4180 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:406376 (406.3 KB)  TX bytes:406376 (406.3 KB)


В DOS ipconfig
```
2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
```commandline
Протокол LLDP - протокол для обмена информацией между соседними устройствами, позволяет определить к какому порту коммутатора подключён сервер.

nariman@nariman:~$ sudo apt install lldpd
nariman@nariman:~$ sudo systemctl enable lldpd && sudo systemctl start lldpd
nariman@nariman:~$ lldpctl
-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------

```
3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
```commandline
VLAN - виртуальное разделение комутаторов
В Linux пакет - vlan

Настроить vlan можно редактиованием  файла /etc/network/interfaces
так же есть команда vconfig
```
4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
```commandline
Агрегирование каналов (англ. link aggregation) — технологии объединения нескольких параллельных каналов передачи данных в сетях Ethernet в один логический, позволяющие увеличить пропускную способность и повысить надёжность.
В различных конкретных реализациях агрегирования используются альтернативные наименования: транкинг портов (англ. port trunking), связывание каналов (link bundling), склейка адаптеров (NIC bonding), сопряжение адаптеров (NIC teaming).

Link Aggregation Control Protocol (LACP) — протокол, предназначенный для объединения нескольких физических каналов в один логический в сетях Ethernet. 
Агрегированные каналы LACP используются как для повышения пропускной способности, так и повышения отказоустойчивости.

В Linux поддержка LACP осуществляется с помощью модуля bonding, как и всякая другая агрегация на канальном уровне.
LACP в Linux через bonding
В Linux поддержка LACP осуществляется с помощью модуля bonding, как и всякая другая агрегация на канальном уровне.

Teaming - новый механизм создания агрегированных линков в Linux, более архитектурно правильны. С
остоит из ядерной части, которая реализует базовые механизмы обработки трафика, и части пространства пользователя, которая отвечает за сигнализацию и управление ядерной частью.

Конфигурационный файл (/etc/network/team0.conf):

{
  "device": "team0",
  "runner": { 
    "name":"lacp",
    "active":true, 
    "fast_rate":true, 
    "tx_hash":["eth", "ipv4", "ipv6"]
  }, 
  "link_watch": {"name": "ethtool"}, 
  "ports": {
    "eth0": {},
    "eth2": {}
  }
}



```
5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
```commandline

В сети с маской /29 - 8 адресов , 32 - подсети
В сети с маской /24 - 256 адресов , 256 - подсети

в сети /24 поместится 256/32 - 8 подсетей с маской /29


маска 255.255.255.248
Подсети 
10.10.10.0 - 10.10.10.8
...
10.10.10.248 - 10.10.10.256

```
6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
```commandline
Согласно лекции 255.192.0.0	/10
```
7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

```commandline
nariman@nariman:~$ arp -a
? (192.168.0.1) в c8:3a:35:9a:52:20 [ether] на enp0s31f6
nariman@nariman:~$ ip neigh
192.168.0.1 dev enp0s31f6 lladdr c8:3a:35:9a:52:20 REACHABLE


удалить IP

arp -d 192.168.0.1
```