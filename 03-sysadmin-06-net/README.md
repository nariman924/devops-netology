# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?

```
HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: b7fb4547-3829-45b3-b56e-ec3df64ed012
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Sun, 28 Nov 2021 18:07:20 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-hel1410029-HEL
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1638122841.556873,VS0,VE110
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=0d12cbf1-695f-3455-cde2-1bd0ddf27012; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.


301 - Перманентный редирект
```

2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.

```
Request URL: https://stackoverflow.com/
Request Method: GET
Status Code: 200 
Remote Address: 151.101.129.69:443
Referrer Policy: no-referrer-when-downgrade

```
```
accept-ranges: bytes
cache-control: private
content-encoding: gzip
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
content-type: text/html; charset=utf-8
date: Sun, 28 Nov 2021 18:14:38 GMT
feature-policy: microphone 'none'; speaker 'none'
strict-transport-security: max-age=15552000
vary: Accept-Encoding,Fastly-SSL
via: 1.1 varnish
x-cache: MISS
x-cache-hits: 0
x-dns-prefetch-control: off
x-frame-options: SAMEORIGIN
x-request-guid: 802e3658-690a-4328-a9fb-ac53b1f08a73
x-served-by: cache-hel1410029-HEL
x-timer: S1638123279.735620,VS0,VE113
```


```
Http код 200 - успешно

```


 [3-6-1.png](../img/3-6-1.png)

3. Какой IP адрес у вас в интернете?
```
nariman@nariman:~$ curl ifconfig.co
178.159.123.24

```
4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`
```
whois 178.159.123.24 

organisation:   ORG-FSMV1-RIPE
org-name:       FOP Sinev Maksim Viktorovich
org-type:       OTHER
address:        Russia, 297356 Simferopolskiy area, s.Ukromne, Molodizhna st. 84


whois 178.159.123.24 | grep AS
origin:         AS48330
```
5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`
```
traceroute -An 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  192.168.0.1 [*]  0.849 ms  1.007 ms  1.211 ms
 2  46.172.221.1 [AS48330]  4.079 ms  3.985 ms  3.674 ms
 3  109.200.131.76 [AS6789]  4.418 ms  4.119 ms  4.363 ms
 4  * * *
 5  185.64.45.193 [AS201776]  13.427 ms  13.376 ms  13.049 ms
 6  195.208.208.250 [AS5480]  36.871 ms  34.574 ms  34.089 ms
 7  108.170.250.66 [AS15169]  27.062 ms 108.170.250.51 [AS15169]  34.561 ms 108.170.250.34 [AS15169]  35.095 ms
 8  142.251.49.24 [AS15169]  47.229 ms 142.251.71.194 [AS15169]  57.441 ms 209.85.255.136 [AS15169]  49.820 ms
 9  72.14.238.168 [AS15169]  58.164 ms 216.239.43.20 [AS15169]  55.740 ms 72.14.238.168 [AS15169]  58.386 ms
10  172.253.79.169 [AS15169]  50.434 ms 209.85.246.111 [AS15169]  51.265 ms 216.239.46.243 [AS15169]  59.131 ms
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  8.8.8.8 [AS15169]  51.574 ms  59.674 ms  46.971 ms


AS: AS6789 AS48330 AS15169
```
6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?

 [3-6-2.png](../img/3-6-2.png)
```
На участе AS???
```
7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`

```dig +trace @8.8.8.8 dns.google```
```
dns.google.		10800	IN	NS	ns3.zdns.google.
dns.google.		10800	IN	NS	ns1.zdns.google.
dns.google.		10800	IN	NS	ns4.zdns.google.
dns.google.		10800	IN	NS	ns2.zdns.google.
dns.google.		3600	IN	DS	56044 8 2 1B0A7E90AA6B1AC65AA5B573EFC44ABF6CB2559444251B997103D2E4 0C351B08
dns.google.		3600	IN	RRSIG	DS 8 2 3600 20211218041030 20211126041030 8830 google. y06iadlZq+YDX22qoVF/fIvOxIZQq7UsCcBKpJSAlrd8T9VSh67pMFRF q7pAae+aKrUKtLwtWMQT8abUECNpfFkpMztXWK46s11zpg+ldibsh/uk zt4bDHttv4T6mE0PQWqoY2OePi0wvI9ta4rd9amEh5kRPtp4/2c21Vs8 aSo=
;; Received 506 bytes from 216.239.32.105#53(ns-tld1.charlestonroadregistry.com) in 85 ms

dns.google.		900	IN	A	8.8.4.4
dns.google.		900	IN	A	8.8.8.8

```
8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`

```dig -x 8.8.8.8```

```
;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.		IN	PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.	47973	IN	PTR	dns.google.

```
