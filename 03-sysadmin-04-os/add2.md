## Доработка
### Задание 1

Задание 1
Нам нужно передать параметры именно для исполняемого файла (службы). Посмотрите приведенные выше примеры.


```commandline
vagrant@vagrant:~/node_exporter$ cat node_exporter.conf 
RESTART=always
LOGLVL=error
```

```commandline
vagrant@vagrant:~/node_exporter$ cat /etc/systemd/system/node-exporter.service
[Unit]
Description=Node exporter

[Service]
EnvironmentFile=/home/vagrant/node_exporter/node_exporter.conf
ExecStart=/usr/local/bin/node_exporter --log.level=${LOGLVL}
Restart=${RESTART}

[Install]
WantedBy=multi-user.target

```
```commandline
vagrant@vagrant:~$ sudo systemctl daemon-reload && sudo systemctl restart node-exporter.service && sudo systemctl status node-exporter.service
● node-exporter.service - Node exporter
     Loaded: loaded (/etc/systemd/system/node-exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2021-12-08 15:09:48 UTC; 16ms ago
   Main PID: 1279 (node_exporter)
      Tasks: 4 (limit: 2250)
     Memory: 1.5M
     CGroup: /system.slice/node-exporter.service
             └─1279 /usr/local/bin/node_exporter --log.level=error
```



