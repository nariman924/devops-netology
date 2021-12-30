### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ                                     |
| ------------- |-------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | Ошибка, типы не соответсвуют для операции |
| Как получить для переменной `c` значение 12?  | привести a к строке:       c=str(a)+b                                       |
| Как получить для переменной `c` значение 3?  | привести b к целому числу: c=a+int(b)                                      |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/PycharmProjects/devops-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tизменено:   ', '')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
nariman@nariman:~/PycharmProjects/devops-netology/04-script-02-py$ ./task2.py 
   04-script-02-py/readme.md
   04-script-02-py/task2.py
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

cmd = os.getcwd()

if len(sys.argv) >= 2:
    cmd = sys.argv[1]
bash_command = ["cd " + cmd, "git status 2>&1"]

print('\033[31m')
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result.find('fatal') != -1:
        print('\033[31m Каталог \033[1m ' + cmd + '\033[0m\033[31m не является GIT репозиторием\033[0m')
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tизменено: ', '')
        prepare_result = prepare_result.replace(' ', '')
        print(cmd + prepare_result)

print('\033[0m')
```

### Вывод скрипта при запуске при тестировании:
```

nariman@nariman:~/PycharmProjects/devops-netology/04-script-02-py$ ./task3.py 

/home/nariman/PycharmProjects/devops-netology/04-script-02-pyreadme.md
/home/nariman/PycharmProjects/devops-netology/04-script-02-pytask2.py
/home/nariman/PycharmProjects/devops-netology/04-script-02-pytask3.py

nariman@nariman:~/PycharmProjects/devops-netology/04-script-02-py$ ./task3.py ~/work/

 Каталог  /home/nariman/work/ не является GIT репозиторием


```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket as s
import time as t
import datetime as dt

# set variables
i = 1
wait = 2  # интервал проверок в секундах
srv = {'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
init = 0

print('*** start script ***')
print(srv)
print('********************')

while 1 == 1:
    for host in srv:
        ip = s.gethostbyname(host)
        if ip != srv[host]:
            if i == 1 and init != 1:
                print(
                    str(dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) + ' [ERROR] ' + str(host) + ' IP mistmatch: ' +
                    srv[host] + ' ' + ip)
            srv[host] = ip
    t.sleep(wait)

```

### Вывод скрипта при запуске при тестировании:
```
nariman@nariman:~/PycharmProjects/devops-netology/04-script-02-py$ ./task4.py 
*** start script ***
{'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
********************
2021-12-30 16:36:45 [ERROR] drive.google.com IP mistmatch: 0.0.0.0 216.58.207.238
2021-12-30 16:36:45 [ERROR] mail.google.com IP mistmatch: 0.0.0.0 64.233.165.17
2021-12-30 16:36:45 [ERROR] google.com IP mistmatch: 0.0.0.0 108.177.14.100
2021-12-30 16:38:37 [ERROR] mail.google.com IP mistmatch: 64.233.165.17 64.233.165.19
2021-12-30 16:38:39 [ERROR] mail.google.com IP mistmatch: 64.233.165.19 64.233.165.17

```