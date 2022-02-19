## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.


### _Ответ:_

[https://hub.docker.com/r/nariman924/nariman-nginx](https://hub.docker.com/r/nariman924/nariman-nginx)

1. Создаём [Dockerfile](./Dockerfile)
2. Создаём на основе фала контейнер 
```commandline
nariman@nariman:~/PycharmProjects/devops-netology/05-virt-03$ docker run -it --rm -d -p 8765:80 --name nariman-nginx-4 nariman-nginx
1946d2904c06eb325b2f5e924db79d21024a94841389a05bf650c3b4cc76f179
```
3. Коммитим состояние образа
```commandline
nariman@nariman:~$ docker commit -m "Devops Netology" 1946d2904c06 nariman924/nariman-nginx
sha256:8e24a9a528dbc93f35597eef094a3176af8321255ff4f12b11467c37b8a49d97
```
4. Аторизуемся и пушим контейнер в хаб
```commandline
nariman@nariman:~$ docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: nariman924
Password: 
WARNING! Your password will be stored unencrypted in /home/nariman/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
nariman@nariman:~$ docker push nariman924/nariman-nginx
Using default tag: latest
The push refers to repository [docker.io/nariman924/nariman-nginx]
57818130a1e8: Pushed 
5223015cf9a2: Pushed 
762b147902c0: Mounted from library/nginx 
235e04e3592a: Mounted from library/nginx 
6173b6fa63db: Mounted from library/nginx 
9a94c4a55fe4: Mounted from library/nginx 
9a3a6af98e18: Mounted from library/nginx 
7d0ebbe3f5d2: Mounted from library/nginx 
latest: digest: sha256:6ce501495b988dd72bf6c66a9ce8034c0e865e942853de565b503dd1ae870c02 size: 1984
nariman@nariman:~$
```

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

### _Ответ:_

- В целом, практически, для всех кейсов(кроме мобильных приложений) не завязанных на высокой производительности и доступности - 
таких как dev, stage, test окружения можно использовать Docker Container - перебрасывая важные данные на host-машину

Высоконагруженное монолитное java веб-приложение;
 - физический сервер, т.к. монолитное, селдовательно в микросерверах не реализуемо без изменения кода,
   и так как высоконагруженное -  то необходим физический доступ к ресурсами, без использования гипервизора виртуалки.
 
Nodejs веб-приложение;
 - Обычно такие приложения используют микросервисную архитектуру, удобно использовать контейнеры, для масштабирования и балансировки
 
Мобильное приложение c версиями для Android и iOS;
 - Виртуальная машина - для эмуляции устройств

Шина данных на базе Apache Kafka;
 - Кластер виртуальных машин - для обеспечения быстродействия и надёжности.
  
Elastic stack для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
 - elasticsearch - На кластере ВМ - для лучшей производительности, logstash и kibana - в контейнерах, для экономии

Мониторинг-стек на базе prometheus и grafana;
 - Достаточно контейнер, мониторинг не требовательный к ресурсам, не требует высокой доступности и производительности

Mongodb, как основное хранилище данных для java-приложения;
 - оптимально использовать ВМ

Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
 - Достаточно контейнера, либо "слабая" ВМ


## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

### _Ответ_:

1. Создаём образы из dockerfile centos и debian
```commandline
nariman@nariman:~/PycharmProjects/devops-netology/05-virt-03/task_3/centos$ docker build -t nariman-cent .
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM centos:latest
latest: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
 ---> 5d0da3dc9764
Step 2/2 : VOLUME ../data /data
 ---> Running in 77d0596f3d68
Removing intermediate container 77d0596f3d68
 ---> e10d3e7f68ab
Successfully built e10d3e7f68ab
Successfully tagged nariman-cent:latest
```

```commandline
nariman@nariman:~/PycharmProjects/devops-netology/05-virt-03/task_3/debian$ docker build -t nariman-debian .
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM debian:latest
latest: Pulling from library/debian
0c6b8ff8c37e: Pull complete 
Digest: sha256:fb45fd4e25abe55a656ca69a7bef70e62099b8bb42a279a5e0ea4ae1ab410e0d
Status: Downloaded newer image for debian:latest
 ---> 04fbdaf87a6a
Step 2/2 : VOLUME ../data /data
 ---> Running in 63bace5c6556
Removing intermediate container 63bace5c6556
 ---> f68ff20cfc88
Successfully built f68ff20cfc88
Successfully tagged nariman-debian:latest
```

2. Создаём контейнеры и запускаем 
```commandline
nariman@nariman:~/PycharmProjects/devops-netology/05-virt-03/task_3/centos$ docker run -v /home/nariman/PycharmProjects/devops-netology/05-virt-03/task_3/data:/data -it --rm -d --name nariman-cent-1 nariman-cent
b0378fbdde4e55c995cf6883f67d6df54a9a8948c6a24f5cd60f3422f56c18ff
```
```commandline
nariman@nariman:~/PycharmProjects/devops-netology/05-virt-03/task_3/debian$ docker run -v /home/nariman/PycharmProjects/devops-netology/05-virt-03/task_3/data:/data -it --rm -d --name nariman-debian-1 nariman-debian
b58a0a2e1c022a8389aedec2a8e42f36d54e1b06ad3034b4971aa674a39f256e
```
3. Создаём файл в первом контейнере
```commandline
[root@5b0ab6721881 data]# touch file1.txt
```
4. Создаём файл локально
```commandline
nariman@nariman:~/PycharmProjects/devops-netology/05-virt-03/task_3/data$ touch file2.txt
```
5. Листинг со второго контейнера
```commandline
root@6eb3f7e4d960:/data# ls -la
total 8
drwxrwxr-x 2 1000 1000 4096 Feb 13 11:38 .
drwxr-xr-x 1 root root 4096 Feb 13 11:35 ..
-rw-r--r-- 1 root root    0 Feb 13 11:37 file1.txt
-rw-rw-r-- 1 1000 1000    0 Feb 13 11:38 file2.txt
```
