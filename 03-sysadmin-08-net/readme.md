
# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```

```commandline
nariman@nariman:~$ telnet route-views.routeviews.org
Trying 128.223.51.103...
Connected to route-views.routeviews.org.
**********************************************************************

                    RouteViews BGP Route Viewer
                    route-views.routeviews.org

 route views data is archived on http://archive.routeviews.org

 This hardware is part of a grant by the NSF.
 Please contact help@routeviews.org if you have questions, or
 if you wish to contribute your view.

 This router has views of full routing tables from several ASes.
 The list of peers is located at http://www.routeviews.org/peers
 in route-views.oregon-ix.net.txt

 NOTE: The hardware was upgraded in August 2014.  If you are seeing
 the error message, "no default Kerberos realm", you may want to
 in Mac OS X add "default unset autologin" to your ~/.telnetrc

 To login, use the username "rviews".

 **********************************************************************


User Access Verification

Username: rviews
route-views>show ip route 178.159.123.12
Routing entry for 178.159.112.0/20
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 2d15h ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 2d15h ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 6939
      MPLS label: none
route-views>show bgp 178.159.123.12
BGP routing table entry for 178.159.112.0/20, version 1393340457
Paths: (24 available, best #22, table default)
  Not advertised to any peer
  Refresh Epoch 3
  3303 6939 6789 48330
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 3303:1006 3303:1021 3303:1030 3303:3067 6939:7040 6939:8752 6939:9002
      path 7FE053045448 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 3257 12389 201776 6789 48330
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE1199EB6E0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 12389 201776 6789 48330
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external
      Community: 2516:1050 7660:9003
      path 7FE14BDA4400 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3267 20485 48084 48084 6789 48330
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE0B6F61580 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 3356 12389 201776 6789 48330
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:903 3356:2065 65500:1 65500:102 65500:103 65500:201 65500:555
      path 7FE037A59AD0 RPKI State not found
 --More--
```

2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
```commandline
nariman@nariman:~$ sudo modprobe -v dummy numdummies=2
insmod /lib/modules/4.15.0-142-generic/kernel/drivers/net/dummy.ko numdummies=2
nariman@nariman:~$ ifconfig -a | grep dummy
dummy0    Link encap:Ethernet  HWaddr 92:2c:e9:5f:99:db  
dummy1    Link encap:Ethernet  HWaddr f6:21:28:df:07:7c
```
```commandline
nariman@nariman:~$ sudo ip addr add 192.168.1.150/24 dev dummy0
nariman@nariman:~$ sudo ip addr add 192.168.1.155/24 dev dummy1
```

```commandline
dummy0    Link encap:Ethernet  HWaddr 92:2c:e9:5f:99:db  
          inet addr:192.168.1.150  Bcast:0.0.0.0  Mask:255.255.255.0
          BROADCAST NOARP  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

dummy1    Link encap:Ethernet  HWaddr f6:21:28:df:07:7c  
          inet addr:192.168.1.155  Bcast:0.0.0.0  Mask:255.255.255.0
          BROADCAST NOARP  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

```

3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

```commandline
nariman@nariman:~$ sudo lsof -nP -iTCP -sTCP:LISTEN
COMMAND     PID     USER   FD   TYPE  DEVICE SIZE/OFF NODE NAME
gearmand   1678  gearman   10u  IPv4   27276      0t0  TCP 127.0.0.1:4730 (LISTEN)
memcached  1928 memcache   26u  IPv4   27247      0t0  TCP 127.0.0.1:11211 (LISTEN)
mongod     1937  mongodb    6u  IPv4   28377      0t0  TCP 127.0.0.1:27017 (LISTEN)
redis-ser  2083    redis    4u  IPv4   27266      0t0  TCP 127.0.0.1:6379 (LISTEN)
mysqld     2093    mysql   17u  IPv4   30444      0t0  TCP 127.0.0.1:3306 (LISTEN)
nginx      2154     root    6u  IPv4   33797      0t0  TCP *:80 (LISTEN)
postgres   2347 postgres    6u  IPv4   28366      0t0  TCP 127.0.0.1:5432 (LISTEN)
dnsmasq    2590   nobody    5u  IPv4   28466      0t0  TCP 127.0.1.1:53 (LISTEN)
java       3648  nariman   19u  IPv4 1579067      0t0  TCP 127.0.0.1:21091 (LISTEN)
java       3648  nariman   20u  IPv4 1579068      0t0  TCP *:35511 (LISTEN)
beam.smp  18782 rabbitmq   17u  IPv4 1975657      0t0  TCP *:36925 (LISTEN)
epmd      18829 rabbitmq    3u  IPv4 1976999      0t0  TCP *:4369 (LISTEN)
cupsd     19794     root   10u  IPv6   94983      0t0  TCP [::1]:631 (LISTEN)
cupsd     19794     root   11u  IPv4   94984      0t0  TCP 127.0.0.1:631 (LISTEN)
```

```commandline
Например nginx использует порт 80 который обычно используют при работе с протоколом HTTP
redis, mysql, postgres по умолчанию не доступны из вне и используют 127.0.0.1 для взаимодействия с другими приложениями, 
однако чтоб избежать конфликта для разграничения используют различные порты.


```

5. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

```commandline
nariman@nariman:~$ netstat -pnlu

Proto Recv-Q Send-Q Local Address Foreign Address State       PID/Program name
udp        0      0 127.0.1.1:53            0.0.0.0:*                           -               
udp        0      0 0.0.0.0:68              0.0.0.0:*                           -               
udp        0      0 0.0.0.0:49256           0.0.0.0:*                           -               
udp        0      0 0.0.0.0:631             0.0.0.0:*                           -               
udp        0      0 0.0.0.0:34090           0.0.0.0:*                           -               
udp        0      0 224.0.0.251:5353        0.0.0.0:*                           21612/chrome --type
udp        0      0 224.0.0.251:5353        0.0.0.0:*                           20758/chrome --enab
udp        0      0 0.0.0.0:5353            0.0.0.0:*                           -               
udp6       0      0 :::33386                :::*                                -               
udp6       0      0 :::43233                :::*                                7077/Preload.js --c
udp6       0      0 :::5353                 :::*                                -         
```

В данный момент браузер chrome использует udp порты. 

6. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 
