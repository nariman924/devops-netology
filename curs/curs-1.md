## Задание

1. Создайте виртуальную машину Linux.
```commandline
nariman@nariman:~/work/devops-netology/vm-curs$ vagrant init
A `Vagrantfile` has been placed in this directory. You are now
...
```
```commandline
nariman@nariman:~/work/devops-netology/vm-curs$ cat Vagrantfile 
Vagrant.configure("2") do |config|
 	config.vm.box = "bento/ubuntu-20.04"
 	config.vm.provider "virtualbox" do |v|
      v.memory = 2024
      v.cpus = 2
    end
    config.vm.network "forwarded_port", guest: 80, host: 8080, id: "nginx"
    config.vm.network "forwarded_port", guest: 443, host: 4443, id: "nginx-ssl"
end

```
```commandline
nariman@nariman:~/work/devops-netology/vm-curs$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider
...
```
```commandline
nariman@nariman:~/work/devops-netology/vm-curs$ vagrant ssh
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
...
```

2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
```commandline
vagrant@vagrant:~$ sudo apt install ufw
Reading package lists... Done
...
```
```commandline
vagrant@vagrant:~$ sudo ufw allow 22
Rules updated
Rules updated (v6)
vagrant@vagrant:~$ sudo ufw allow 443
Rules updated
Rules updated (v6)

```
3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).
```commandline
vagrant@vagrant:~$ sudo apt-get update && sudo apt-get install vault
...
Vault TLS key and self-signed certificate have been generated in '/opt/vault/tls'.
```
4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).

Запускаем vault сервер в dev режиме
```commandline
vagrant@vagrant:~$ vault server -dev -dev-root-token-id root
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.17.5
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.9.2
             Version Sha: f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf

==> Vault server started! Log data will stream in below:
```

```commandline
vagrant@vagrant:~$ export VAULT_ADDR=http://127.0.0.1:8200
vagrant@vagrant:~$ export VAULT_TOKEN=root

```
```commandline
vagrant@vagrant:~$ vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
vagrant@vagrant:~$ vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/
vagrant@vagrant:~$ vault write -field=certificate pki/root/generate/internal \
>      common_name="example.com" \
>      ttl=87600h > CA_cert.crt
vagrant@vagrant:~$ vault write pki/config/urls \
>      issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
>      crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls
```
```commandline
vagrant@vagrant:~$ vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
vagrant@vagrant:~$ vault secrets tune -max-lease-ttl=43800h pki_int
Success! Tuned the secrets engine at: pki_int/
vagrant@vagrant:~$ vault write -format=json pki_int/intermediate/generate/internal \
>      common_name="example.com Intermediate Authority" \
>      | jq -r '.data.csr' > pki_intermediate.csr
vagrant@vagrant:~$ vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
>      format=pem_bundle ttl="43800h" \
>      | jq -r '.data.certificate' > intermediate.cert.pem
```
```commandline
vagrant@vagrant:~$ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
```
```commandline
vagrant@vagrant:~$ vault write pki_int/roles/example-dot-com \
>      allowed_domains="example.com" \
>      allow_subdomains=true \
>      max_ttl="720h"
Success! Data written to: pki_int/roles/example-dot-com
```

```commandline
vagrant@vagrant:~$ vault write pki_int/issue/example-dot-com common_name="test.example.com" ttl="720h"
Key                 Value
---                 -----
ca_chain            [-----BEGIN CERTIFICATE-----
MIIDpjCCAo6gAwIBAgIULXemcOYPL/7CrAsExhJqj9dO5Y4wDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAxMLZXhhbXBsZS5jb20wHhcNMjExMjI1MTExMzQ0WhcNMjYx
```

5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
```commandline
nariman@nariman:~$ sudo mkdir /usr/share/ca-certificates/extra
nariman@nariman:~$ sudo cp CA_cert.crt /usr/share/ca-certificates/extra/CA_cert.crt
nariman@nariman:~$ sudo dpkg-reconfigure ca-certificates
Обрабатываются триггеры для ca-certificates (20210119~16.04.1) …
Updating certificates in /etc/ssl/certs...
0 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...

done.
done.
nariman@nariman:~$ sudo update-ca-certificates
Updating certificates in /etc/ssl/certs...
0 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...

done.
done.


```

### Доработка
```commandline
nariman@nariman:~$ sudo cp Qwe.crt /usr/share/ca-certificates/Qwe.crt
nariman@nariman:~$ sudo dpkg-reconfigure ca-certificates
Обрабатываются триггеры для ca-certificates (20210119~16.04.1) …
Updating certificates in /etc/ssl/certs…
1 added, 1 removed; done.
Running hooks in /etc/ca-certificates/update.d…

Replacing debian:Qwe.pem
Removing debian:Qwe.pem
done.
done.
```


6. Установите nginx.
```commandline
vagrant@vagrant:~$ sudo apt install nginx
Reading package lists... Done
Building dependency tree       
Reading state information...
```
```commandline
vagrant@vagrant:~$ service nginx status
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2021-12-25 14:14:38 UTC; 10min ago
       Docs: man:nginx(8)

```
7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
  - можно использовать и другой html файл, сделанный вами;
```commandline
vagrant@vagrant:~$ sudo mkdir -p /var/www/test.example.com/html
vagrant@vagrant:~$ sudo chown -R $USER:$USER /var/www/test.example.com/html
vagrant@vagrant:~$ sudo chmod -R 755 /var/www
vagrant@vagrant:~$ sudo mkdir -p /var/www/test.example.com/html
vagrant@vagrant:~$ sudo chown -R $USER:$USER /var/www/test.example.com/html
vagrant@vagrant:~$ sudo chmod -R 755 /var/www
vagrant@vagrant:~$ nano /var/www/test.example.com/html/index.html
vagrant@vagrant:~$ sudo nano /etc/nginx/sites-available/test.example.com
vagrant@vagrant:~$ sudo ln -s /etc/nginx/sites-available/test.example.com /etc/nginx/sites-enabled/
vagrant@vagrant:~$ sudo rm /etc/nginx/sites-enabled/default 
vagrant@vagrant:~$ sudo service nginx restart
```
```commandline
vagrant@vagrant:~$ cat /var/www/test.example.com/html/index.html
<html>
   <head>
       <title>Hello Test.Example.com!</title>
   </head>
   <body>
       <h1>Hello Test.example.com!</h1>
   </body>
</html>
```

```commandline
vagrant@vagrant:~$ cat /etc/nginx/sites-available/test.example.com
server {
       listen 443 ssl;
       listen 80;
       listen [::]:80;

       server_name test.example.com;
       ssl on;
       ssl_certificate /var/www/test.example.com/ssl/test.example.com.crt.pem;
       ssl_certificate_key /var/www/test.example.com/ssl/test.example.com.crt.key;

       root /var/www/test.example.com/html;
       index index.html;

       location / {
               try_files $uri $uri/ =404;
       }
}

```
8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.

```commandline
nariman@nariman:~$ wget -O - https://test.example.com:4443
--2021-12-25 21:14:22--  https://test.example.com:4443/
Распознаётся test.example.com (test.example.com)... 127.0.0.1
Подключение к test.example.com (test.example.com)|127.0.0.1|:4443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа... 200 OK
Длина: 143 [text/html]
Сохранение в каталог: ««STDOUT»».

-                                                  0%[                                                                                                           ]       0  --.-KB/s               <html>
   <head>
       <title>Hello Test.Example.com!</title>
   </head>
   <body>
       <h1>Hello Test.example.com!</h1>
   </body>
</html>
-                                                100%[==========================================================================================================>]     143  --.-KB/s    in 0s      

/2021-12-25 21:14:22 (37,9 MB/s) - записан в stdout [143/143]

nariman@nariman:~$ curl https://test.example.com:4443
<html>
   <head>
       <title>Hello Test.Example.com!</title>
   </head>
   <body>
       <h1>Hello Test.example.com!</h1>
   </body>
</html>
nariman@nariman:~$ 

```
#### До доработки [curs-img.png](./curs-img.png)
#### После доработки:
![curs-img-2.png](./curs-img-2.png)

9. Создайте скрипт, который будет генерировать новый сертификат в vault:
  - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
  - перезапускаем nginx для применения нового сертификата.

Скрипт [gencert.sh](./gencert.sh)

10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.
```commandline
sudo crontab -u root -e
```

```commandline
0 0 1 * * bash /home/vagrant/gencert.sh
```
