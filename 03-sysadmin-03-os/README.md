# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.
```
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=36864, ...}) = 0
chdir("/tmp")                           = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```
Ответ: `chdir("/tmp")`


2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

Ответ: `open("/usr/share/misc/magic.mgc", O_RDONLY) = 3`


4. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
```
nariman@nariman:~$ ps -a
  PID TTY          TIME CMD
 5364 pts/18   00:00:00 ping
 5770 pts/17   00:00:00 ps
nariman@nariman:~$ sudo lsof -p 5364
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
...
ping    5364 nariman    8w   REG    8,6     1741  268610 /home/nariman/ping.txt
nariman@nariman:~$ rm ping.txt
nariman@nariman:~$ sudo lsof -p 5364
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
...
ping    5364 nariman    8w   REG    8,6     4436  268610 /home/nariman/ping.txt (deleted)
nariman@nariman:~$ sudo cat /dev/null > /proc/5364/fd/8
bash: /proc/5364/fd/8: Отказано в доступе
nariman@nariman:~$ sudo truncate -s 0 /proc/5364/fd/8

```


4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
```
Ответ:
зомби-процессы освобождают свои ресурсы, но не освобождают запись в таблице процессов. Запись освободиться при вызове wait() родительским процессом.
```


5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
```
PID    COMM               FD ERR PATH
808    vminfo              4   0 /var/run/utmp
601    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
601    dbus-daemon        18   0 /usr/share/dbus-1/system-services
601    dbus-daemon        -1   2 /lib/dbus-1/system-services
601    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
607    irqbalance          6   0 /proc/interrupts
607    irqbalance          6   0 /proc/stat
...
```


6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
```
uname({sysname="Linux", nodename="nariman", ...}) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 17), ...}) = 0
uname({sysname="Linux", nodename="nariman", ...}) = 0
uname({sysname="Linux", nodename="nariman", ...}) = 0
write(1, "Linux nariman 4.15.0-142-generic"..., 117Linux nariman 4.15.0-142-generic #146~16.04.1-Ubuntu SMP Tue Apr 13 09:27:15 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
) = 117
```
Ответ `uname`

```
   Part of the utsname information is also accessible  via  /proc/sys/ker‐nel/{ostype, hostname, osrelease, version, domainname}
```

7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?
```
Оператор точка с запятой позволяет запускать несколько команд за один раз, и выполнение команды происходит последовательно.

Оператор AND (&&) будет выполнять вторую команду только в том случае, если при выполнении первой команды SUCCEEDS

set -e - прерывает сессию при любом ненулевом значении исполняемых команд в конвеере кроме последней.
в случае &&  вместе с set -e- вероятно не имеет смысла, так как при ошибке , выполнение команд прекратиться. 
```
8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
```
Ответ:
-e предписывает bash немедленно выйти, если какая-либо команда имеет ненулевой статус выхода 
-x Включает режим оболочки, в котором все выполненные команды выводятся на терминал 
-u Если установлено, ссылка на любую переменную, которую вы ранее не определили, за исключением $ * и $ @, является ошибкой и вызывает немедленный выход из программы
-o pipefail Если какая-либо команда в конвейере терпит неудачу, этот код возврата будет использоваться как код возврата всего конвейера. 
По умолчанию код возврата конвейера - это код последней команды, даже если она выполнена успешно.

set позводяет производить более тщательную отдадку и логирование сценария а так же возможность прервать выполнение при возникновении ошибки сценарии.
```
9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
```
nariman@nariman:~$ ps -o stat
STAT
Ss
R+


R - Процесс выполняется в данный момент
S - Процесс ожидает выполнение (спит)
D - Процесс в полной (непрерываемой) спячке, например, ожидает ввода/вывода
Z - zombie процесс у которого нет родителя.
T - Процесс остановлен.
W - процесс в свопе
< - процесс в приоритетном режиме.
N - процесс в режиме низкого приоритета
L - real-time процесс, имеются страницы заблокированные в памяти.
 
```
