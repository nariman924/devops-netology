Задание 1
`"В DOS ipconfig" - это вы загнули :)`

Точнее сказать в командной строке ОС семейсва Windows ipconfig - поволяет получить список сетевых интерфейсов. 
Дополнительно netsh interface show interface

Задание 3

`Приведите пример конфигурационного файла.`

```
nariman@nariman:~$ cat /etc/network/interfaces

auto eth0.100
iface eth0.100 inet static
   address 192.168.100.3
   netmask 255.255.255.0
   vlan_raw_device eth0
 
auto eth0.200
iface eth0.200 inet static
   address 192.168.200.3
   netmask 255.255.255.0
   vlan_raw_device eth0
```

Задание 6
`Немного поясните свой ответ.`

Согласно лекции для стыка данного списка сетей можно использовать диапазон 100.64.0.0 - 100.127.255.255 маска 255.192.0.0 т.н Carrier-Grade NAT



