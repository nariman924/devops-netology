# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.
```commandline
Разрежённый файл (англ. sparse file) — файл, в котором последовательности нулевых байтов[1] заменены на информацию об этих последовательностях (список дыр).

Дыра (англ. hole) — последовательность нулевых байт внутри файла, не записанная на диск. Информация о дырах (смещение от начала файла в байтах и количество байт) хранится в метаданных ФС.
```
1. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
```commandline
Так как hardlink это ссылка на тот же самый файл и имеет тот же inode то права будут одни и теже.
При изменении прав одного объекта изменятся права и второго
```
1. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

```
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk 
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part 
└─sda5                 8:5    0 63.5G  0 part 
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk 
sdc                    8:32   0  2.5G  0 disk 

```

3. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

```commandline
Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x2166424b.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): 

Using default response p.
Partition number (1-4, default 1): 
First sector (2048-5242879, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): e
Partition number (2-4, default 2): 
First sector (4196352-5242879, default 4196352): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879): 

Created a new partition 2 of type 'Extended' and of size 511 MiB.

Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x2166424b

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M  5 Extended

```

4. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

```
root@vagrant:~# sfdisk -d /dev/sdb|sfdisk --force /dev/sdc
```
```commandline
Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x546a6fa6.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Extended' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x546a6fa6

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M  5 Extended

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

5. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

```commandline
root@vagrant:~# mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sd{b1,c1}
```
```commandline
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.

```

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
```commandline
mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sd{b2,c2}
```

```commandline
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: partition table exists on /dev/sdc2
mdadm: partition table exists on /dev/sdc2 but will be lost or
       meaningless after creating array
mdadm: size set to 522240K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

```

9. Создайте 2 независимых PV на получившихся md-устройствах.
```commandline
root@vagrant:~# pvcreate /dev/md1 /dev/md0
```
10. Создайте общую volume-group на этих двух PV.
```commandline
root@vagrant:~# vgcreate vg1 /dev/md1 /dev/md0
```
```commandline
root@vagrant:~# vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  vg1         2   1   0 wz--n-   2.49g 2.39g
  vgvagrant   1   2   0 wz--n- <63.50g    0 
```
12. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
```commandline
root@vagrant:~# lvcreate -L 100M vg1 /dev/md0
```

```commandline
root@vagrant:~# lvs
  LV     VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvol0  vg1       -wi-a----- 100.00m                                                    
  root   vgvagrant -wi-ao---- <62.54g                                                    
  swap_1 vgvagrant -wi-ao---- 980.00m  
```

14. Создайте `mkfs.ext4` ФС на получившемся LV.
```commandline
root@vagrant:~# mkfs.ext4 /dev/vg1/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

```
15. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
```commandline
root@vagrant:~# mkdir /tmp/new
root@vagrant:~# mount /dev/vg1/lvol0 /tmp/new
```
16. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
```commandline
root@vagrant:~# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-12-04 12:17:13--  https://mirror.yandex.ru/ubuntu/ls-lR.gz

```
17. Прикрепите вывод `lsblk`.
```commandline
root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
└─sdb2                 8:18   0  511M  0 part  
  └─md0                9:0    0  510M  0 raid1 
    └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
└─sdc2                 8:34   0  511M  0 part  
  └─md0                9:0    0  510M  0 raid1 
    └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new

```

19. Протестируйте целостность файла:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
```commandline
root@vagrant:~# gzip -t /tmp/new/test.gz && echo $?
0
```


20. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
```commandline
root@vagrant:~# pvmove /dev/md0 /dev/md1
  /dev/md0: Moved: 12.00%
  /dev/md0: Moved: 100.00%

```

22. Сделайте `--fail` на устройство в вашем RAID1 md.
```commandline
root@vagrant:~# mdadm /dev/md1 --fail /dev/sdb1
```

23. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
```commandline
root@vagrant:~# dmesg | grep md1
[ 2512.196624] md/raid1:md1: not clean -- starting background reconstruction
[ 2512.196625] md/raid1:md1: active with 2 out of 2 mirrors
[ 2512.196635] md1: detected capacity change from 0 to 2144337920
[ 2512.196874] md: resync of RAID array md1
[ 2522.461339] md: md1: resync done.
[ 3688.386119] md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
[ 3691.044324] md: data-check of RAID array md1
[ 3701.721339] md: md1: data-check done.
[ 4668.566666] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.

```

25. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
```commandline
root@vagrant:~# gzip -t /tmp/new/test.gz && echo $?
0
```
26. Погасите тестовый хост, `vagrant destroy`.
```commandline
vagrant destroy
```