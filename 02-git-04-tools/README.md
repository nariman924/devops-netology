1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
### Решение
```
git rev-parse aefea
aefead2207ef7e2aa5dc81a34aedf0cad4c32545
```

2. Какому тегу соответствует коммит 85024d3?
### Решение
```
git show 85024d3
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)

Ответ: v0.12.23
```
3. Сколько родителей у коммита b8d720? Напишите их хеши.
### Решение
```
git show b8d720^
commit 56cd7859e05c36c06b56d013b55a252d0bb7e158

Ответ: 1 прямой предок
```
4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
### Решение
```
nariman@nariman:~/work/terraform$ git rev-parse v0.12.23
0bad56c4fcca45a0ba08a88234c6d731b2d8647c
nariman@nariman:~/work/terraform$ git rev-parse v0.12.24
8915fa993b646d51c9703162b71271d064f7aca6
nariman@nariman:~/work/terraform$ git log --pretty=format:"%H %s" 0bad56c4fcca45a0ba08a88234c6d731b2d8647c..8915fa993b646d51c9703162b71271d064f7aca6

Ответ:
33ff1c03bb960b332be3af2e333462dde88b279e v0.12.24
b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location
06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows
4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md
225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release

```
5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).
### Решение
```
git log -S "func providerSource(" --pretty=format:"%h %an %ad %s"
8c928e835 Martin Atkins Thu Apr 2 18:04:39 2020 -0700 main: Consult local directories as potential mirrors of providers
```
6. Найдите все коммиты в которых была изменена функция globalPluginDirs.
### Решение
```
git log --pretty=oneline -S "globalPluginDirs"
35a058fb3ddfae9cfee0b3893822c9a95b920f4c main: configure credentials from the CLI config file
c0b17610965450a89598da491ce9b6b5cbd6393f prevent log output during init
8364383c359a6b738a436d1b7745ccdce178df47 Push plugin discovery down into command package

```
7. Кто автор функции synchronizedWriters?
### Решение
```
git log -S "func synchronizedWriters(" --pretty=format:"%h %an %ad %s"
bdfea50cc James Bardin Mon Nov 30 18:02:04 2020 -0500 remove unused
5ac311e2a Martin Atkins Wed May 3 16:25:41 2017 -0700 main: synchronize writes to VT100-faker on Windows

Ответ Martin Atkins
```