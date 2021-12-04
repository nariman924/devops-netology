# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

```
vagrant@vagrant:~$ wget https://github.com/prometheus/node_exporter/releases/download/v1.3.0/node_exporter-1.3.0.linux-amd64.tar.gz
vagrant@vagrant:~$ tar xvfz node_exporter-1.3.0.linux-amd64.tar.gz 

vagrant@vagrant:~$ sudo -i touch  /etc/systemd/system/node_exporter.service
```

```commandline
[Unit]
Description=Node Exporter
 
[Service]
EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/home/vagrant/node_exporter-1.3.0.linux-amd64/node_exporter
 
[Install]
WantedBy=multi-user.target
```

```
vagrant@vagrant:~$ sudo systemctl daemon-reload
vagrant@vagrant:~$ sudo systemctl enable node_exporter
```
```
vagrant@vagrant:~$ exit
logout
Connection to 127.0.0.1 closed.
nariman@nariman:~/work/devops-netology/vagrant$ vagrant suspend
nariman@nariman:~/work/devops-netology/vagrant$ vagrant up
nariman@nariman:~/work/devops-netology/vagrant$ vagrant ssh

```

```
vagrant@vagrant:~$ sudo systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: activating (start) since Sat 2021-12-04 09:31:21 UTC; 1min 14s ago
Cntrl PID: 1593 (node_exporter)
      Tasks: 5 (limit: 2250)
     Memory: 2.3M
     CGroup: /system.slice/node_exporter.service
             └─1593 /home/vagrant/node_exporter-1.3.0.linux-amd64/node_exporter
```


2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
```
vagrant@vagrant:~$ curl http://localhost:9100/metrics | grep -E 'cpu|memory|disk|network'


CPU:
    node_cpu_seconds_total{cpu="0",mode="idle"} 2238.49
    node_cpu_seconds_total{cpu="0",mode="system"} 16.72
    node_cpu_seconds_total{cpu="0",mode="user"} 6.86
    process_cpu_seconds_total
    
Memory:
    node_memory_MemAvailable_bytes 
    node_memory_MemFree_bytes
    
Disk:
    node_disk_io_time_seconds_total{device="sda"} 
    node_disk_read_bytes_total{device="sda"} 
    node_disk_read_time_seconds_total{device="sda"} 
    node_disk_write_time_seconds_total{device="sda"}
    
Network:
    node_network_receive_errs_total{device="eth0"} 
    node_network_receive_bytes_total{device="eth0"} 
    node_network_transmit_bytes_total{device="eth0"}
    node_network_transmit_errs_total{device="eth0"}

```
3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
```
cpu
Total CPU utilization (all cores). 100% here means there is no CPU idle time at all. You can get per core usage at the CPUs section and per application usage at the Applications Monitoring section.
load
Current system load, i.e. the number of processes using CPU or waiting for system resources (usually CPU and disk). The 3 metrics refer to 1, 5 and 15 minute averages
disk
Total Disk I/O, for all physical disks. You can get detailed information about each disk at the Disks section and per application Disk usage at the Applications Monitoring section. Physical are all the disks that are listed in /sys/block, but do not exist in /sys/devices/virtual/block
ram
System Random Access Memory (i.e. physical memory) usage.
swap
System swap memory usage. Swap space is used when the amount of physical memory (RAM) is full. When the system needs more memory resources and the RAM is full, inactive pages in memory are moved to the swap space (usually a disk, a disk partition or a file).
network
Total bandwidth of all physical network interfaces. This does not include lo, VPNs, network bridges, IFB devices, bond interfaces, etc. Only the bandwidth of physical network interfaces is aggregated.
```

 [3-4.png](../img/3-4.png)


4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
```
vagrant@vagrant:~$ dmesg |grep virtual
[    0.002028] CPU MTRRs all blank - virtualized system.
[    0.055225] Booting paravirtualized kernel on KVM
[    3.613580] systemd[1]: Detected virtualization oracle.

```
5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
```
vagrant@vagrant:~$ /sbin/sysctl -n fs.nr_open
1048576

Это максимальное число открытых дескрипторов для ядра (системы), для пользователя задать больше этого числа нельзя

vagrant@vagrant:~$ ulimit -n
1024

Это значение не даст достигнуть 1048576
```
6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
```
root@vagrant:~# ps -e |grep sleep
   1830 pts/2    00:00:00 sleep
root@vagrant:~# nsenter --target 1830 --pid --mount
root@vagrant:/# ps
    PID TTY          TIME CMD
      2 pts/0    00:00:00 bash
     11 pts/0    00:00:00 ps
```
7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
```
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
vagrant@vagrant:~$ -bash: fork: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable

Это определяет функцию с именем : , которая вызывает себя дважды (Код: : | : ). Это происходит в фоновом режиме ( & ). После ; определение функции выполнено, и функция : запускается.
Таким образом, каждый экземпляр : начинает два новых : и так далее... Как двоичное дерево процессов
```