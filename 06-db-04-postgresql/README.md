# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

---
### Ответ:
**Создаём контейнер с помощью docker-compose.yml :**
```commandline
version: '3.3'

services:
  nariman-postgres-13:
    hostname: nariman-postgres-13
    container_name: nariman-postgres-13
    user: 1000:1000
    image: postgres:13.0
    restart: always
    ports:
      - "5433:5432"
    cap_add:
      - SYS_NICE
    security_opt:
      - seccomp:unconfined
    volumes:
      - ./data-volume:/var/lib/postgresql/data
      - ./dump:/dump
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: test_database
      POSTGRES_USER: root
```

```commandline
name!@nariman-postgres-13:/$ psql -U root -d test_database
```
**- список БД**
```commandline
test_database=# \l
                               List of databases
     Name      | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
---------------+-------+----------+------------+------------+-------------------
 postgres      | root  | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0     | root  | UTF8     | en_US.utf8 | en_US.utf8 | =c/root          +
               |       |          |            |            | root=CTc/root
 template1     | root  | UTF8     | en_US.utf8 | en_US.utf8 | =c/root          +
               |       |          |            |            | root=CTc/root
 test_database | root  | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)
```
**- подключения к БД**
```commandline
test_database=# \connect postgres
You are now connected to database "postgres" as user "root".
```
**- вывода списка таблиц postgres-# \dt в таблицах пусто , использовал оп параметр S - для системных объектов**
```
postgres-# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner   
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
...
```
**- вывода описания содержимого таблиц**
```
postgres-# \d[S+] NAME
postgres-# \dS+ pg_index
                                      Table "pg_catalog.pg_index"
     Column     |     Type     | Collation | Nullable | Default | Storage  | Stats target | Description 
----------------+--------------+-----------+----------+---------+----------+--------------+-------------
 indexrelid     | oid          |           | not null |         | plain    |              | 
 indrelid       | oid          |           | not null |         | plain    |              | 
 indnatts       | smallint     |           | not null |         | plain    |              | 
 indnkeyatts    | smallint     |           | not null |         | plain    |              | 
 indisunique    | boolean      |           | not null |         | plain    |              | 
 indisprimary   | boolean      |           | not null |         | plain    |              | 
 indisexclusion | boolean      |           | not null |         | plain    |              | 
 indimmediate   | boolean      |           | not null |         | plain    |              | 
 indisclustered | boolean      |           | not null |         | plain    |              | 
 indisvalid     | boolean      |           | not null |         | plain    |              | 
 indcheckxmin   | boolean      |           | not null |         | plain    |              | 
 indisready     | boolean      |           | not null |         | plain    |              | 
 indislive      | boolean      |           | not null |         | plain    |              | 
.....
```
**- выхода из psql**
```
postgres-# \q
root@8d48e9af5c27:/# 
```
---

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

---
### Ответ:
```commandline
name!@nariman-postgres-13:/$ psql -U postgres -d test_database -f /test_data/test_dump.sql 
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE

```
**Анализ**
```commandline
test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

```commandline
test_database=# SELECT MAX(avg_width) FROM pg_stats WHERE tablename='orders';
 max 
-----
  16
(1 row)

```
---

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

---
### Ответ:

```commandline
test_database=# alter table orders rename to orders_bkp;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_less499 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_more499 partition of orders for values from (499) to (999999999);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_bkp;
INSERT 0 8
test_database=# 
```

**При изначальном проектировании таблиц можно было сделать ее секционированной, тогда не пришлось бы переименовывать исходную таблицу и переносить данные в новую.**

---

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---
### Ответ:
```commandline
 name!@nariman-postgres-13:/$ pg_dump -U postgres -d test_database >/test_data/test_database_dump.sql
```

Для уникальности можно добавить индекс или первичный ключ.
```CREATE UNIQUE INDEX ON orders ((lower(title)));```
---
