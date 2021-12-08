## Доработка
### Задание 1

Предлагаю уточнить как именно в службу будут передаваться дополнительные опции. Примеры можно посмотреть вот здесь:
www.freedesktop.org...ExecStart=
unix.stackexchange.com...unit-files
stackoverflow.com...-unit-file
Замечу, что речь идёт не о переменных окружения, а об опциях (параметрах) запуска службы.

```commandline
vagrant@vagrant:~/node_exporter$ cat node_exporter.conf 
RESTART=always
```

```commandline
vagrant@vagrant:~/node_exporter$ cat /etc/systemd/system/node-exporter.service
[Unit]
Description=Node exporter

[Service]
EnvironmentFile=/home/vagrant/node_exporter/node_exporter.conf
ExecStart=/usr/local/bin/node_exporter
Restart=${RESTART}

[Install]
WantedBy=multi-user.target

```

## Задание 7
Что обнаружили в выводе dmesg?
```
[   28.314068] *** VALIDATE vboxsf ***
[   28.314074] vboxsf: Successfully loaded version 6.1.24 r145751
[   28.314119] vboxsf: Successfully loaded version 6.1.24 r145751 on 5.4.0-80-generic SMP mod_unload modversions  (LINUX_VERSION_CODE=0x5047c)
[ 3470.255074] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-4.scope
```

cgroup - прекратил размножение процессов


