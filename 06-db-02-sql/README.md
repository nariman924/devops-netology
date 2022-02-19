# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

---
### Ответ:

```commandline
version: '3.3'

services:
  nariman-postgres:
    hostname: nariman-postgres
    container_name: nariman-postgres
    user: 1000:1000
    image: postgres:12.0
    restart: always
    ports:
      - "5432:5432"
    cap_add:
      - SYS_NICE
    security_opt:
      - seccomp:unconfined
    volumes:
      - ./data-volume:/var/lib/postgresql/data
      - ./dump:/dump
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: test_db
      POSTGRES_USER: root

```
---

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

---
### Ответ:
**Подключаемся к psql**
```commandline
psql -U root -d test_db
```
**Создаём пользователя**
```commandline
test_db=# CREATE ROLE "test-admin-user" SUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
CREATE ROLE
```
**Создаём таблицы**
```
CREATE TABLE orders 
(
    id integer, 
    name text, 
    price integer, 
    PRIMARY KEY (id) 
);
```
```
CREATE TABLE clients 
(
    id integer PRIMARY KEY,
    lastname text,
    country text,
    booking integer,
    FOREIGN KEY (booking) REFERENCES orders (Id)
);
```
**Создаём второго пользователя**
```
CREATE ROLE "test-simple-user" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
```
**Указываем права**
```
GRANT SELECT ON TABLE public.clients TO "test-simple-user";
GRANT INSERT ON TABLE public.clients TO "test-simple-user";
GRANT UPDATE ON TABLE public.clients TO "test-simple-user";
GRANT DELETE ON TABLE public.clients TO "test-simple-user";
GRANT SELECT ON TABLE public.orders TO "test-simple-user";
GRANT INSERT ON TABLE public.orders TO "test-simple-user";
GRANT UPDATE ON TABLE public.orders TO "test-simple-user";
GRANT DELETE ON TABLE public.orders TO "test-simple-user";
```
---
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

---
### Ответ:

```commandline
test_db=# INSERT into orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
test_db=# INSERT into clients VALUES (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=# SELECT count (*) from orders;
 count 
-------
     5
(1 row)

test_db=# SELECT count (*) from clients;
 count 
-------
     5
(1 row)

test_db=# 

```
---
## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.
---
### Ответ:

```commandline
test_db=# update  clients set booking = 3 where id = 1;
UPDATE 1
test_db=# update  clients set booking = 4 where id = 2;
UPDATE 1
test_db=# update  clients set booking = 5 where id = 3;
UPDATE 1

test_db=# SELECT lastname FROM clients WHERE booking IS NOT NULL;
       lastname       
----------------------
 Иванов Иван Иванович
 Петров Петр Петрович
 Иоганн Себастьян Бах
(3 rows)

```
---
## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
---
### Ответ:

```commandline

test_db=# EXPLAIN SELECT lastname FROM clients WHERE booking IS NOT NULL;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=32)
   Filter: (booking IS NOT NULL)
(2 rows)

```
Explain показывает стоимость(нагрузку на исполнение) запроса, и фильтрацию по полю Booking для выборки.

---
## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---
### Ответ:

**Создаём бекап данных утилитой pg_dump**
```commandline
pg_dump -U root -d test_db -f /dump/dump_test.sql
```
**Восстанавливаем бекап данных утилитой psql**
```commandline
docker exec -i nariman-postgres-2 psql -U postgres -d test_db -f /dump/dump_test.sql
```
---
