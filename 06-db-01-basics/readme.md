# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде
- Склады и автомобильные дороги для логистической компании
- Генеалогические деревья
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутентификации
- Отношения клиент-покупка для интернет-магазина

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

### _Ответ:_

- Электронные чеки в json виде: Документно-ориентированная

- Склады и автомобильные дороги для логистической компании: Сетевая - иерархическая с множеством узлов, Графовые СУБД

- Генеалогические деревья: Иерархическая - классические деревья с одним родителем

- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутентификации: Ключ-значение, скорость доступа, простота

- Отношения клиент-покупка для интернет-магазина - На стадии стартапа или MVP - использовать NoSQl, когда проект "утресётся" перевести на реляционную БД

## Задача 2

Вы создали распределенное высоко нагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)
- При сетевых сбоях, система может разделиться на 2 раздельных кластера
- Система может не прислать корректный ответ или сбросить соединение

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

### _Ответ:_
- Данные записываются на все узлы с задержкой до часа (асинхронная запись): CA, EL-PC
- При сетевых сбоях, система может разделиться на 2 раздельных кластера: AP, PA-EL
- Система может не прислать корректный ответ или сбросить соединение: CP, PA-EC

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

### _Ответ:_
Принципы BASE и ACID сочетаться не могут. По ACID - данные согласованные, а по BASE - могут быть неверные, следовательно они противоречат друг другу.

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?

### _Ответ:_
Основываясь на лекции - это Redis

Минусы Redis:

Требуются достаточные ресурсы RAM(оперативной памяти)
Отсутствие поддержки языка SQL, а следовательно агрегатных функций, группировок, сортировок и т.д.
при отказе сервера все данные с последней синхронизации с диском будут утеряны, следовательно, для сохранения целостности необходимо дублирование данных - кластеризация