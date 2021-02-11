# RHCSA - Lekcja 5

Zamieszczam materiały i komendy (polecenia) które były użyte podczas zajęć.

[Create, mount, unmount, and use vfat, ext4, and xfs file systems](#Create,-mount,-unmount,-and-use-vfat,-ext4,-and-xfs-file-systems)</br>
[Mount and unmount network file systems using NFS](#Mount-and-unmount-network-file-systems-using-NFS)</br>
[Extend existing logical volumes](#Extend-existing-logical-volumes)</br>
[Create and configure set-GID directories for collaboration](#Create-and-configure-set-GID-directories-for-collaboration)</br>
[Configure disk compression](#Configure-disk-compression)</br>
[Manage layered storage](#Manage-layered-storage)</br>
[Diagnose and correct file permission problems](#Diagnose-and-correct-file-permission-problems)</br>
[Using AutoFS with NFS](#Using-AutoFS-with-NFS)</br>

## Create, mount, unmount, and use vfat, ext4, and xfs file systems

Tworzenie vfat filesystemu:
```
mkfs.vfat /dev/vg1/lv1
```

Montowanie vfat filesystemu:
```
mount /dev/vg1/lv1 /mnt
```

Montowanie permanentnie, edycja pliku /etc/fstab i dodanie lini:
```
/dev/vg1/lv1 /mnt vfat defaults 1 2
```

Sprawdzenie konsystencji odmontowanego filesystemu vfat:
```
fsck.vfat /dev/vg1/lv1
```

### Filesystem Ext4 

Tworzenie ext4 filesystemu:
```
mkfs.ext4 /dev/vg1/lv1
```

Montowanie ext4 filesystemu:
```
mount /dev/vg1/lv1 /mnt
```

Montowanie permanentnie, edycja pliku /etc/fstab i dodanie lini:
```
/dev/vg1/lv1 /mnt ext4 defaults 1 2
```

Sprawdzenie konsystencji odmontowanego filesystemu ext4:
```
fsck /dev/vg1/lv1
```

Wylistowanie szczegółów na temat filesystemu:
```
dumpe2fs /dev/vg1/lv1
```

### Filesystem Xfs 

Tworzenie filesystemu xfs:
```
mkfs.xfs /dev/vg1/lv1
```

Montowanie xfs filesystemu:
```
mount /dev/vg1/lv1 /mnt
```

Montowanie permanentnie, edycja pliku /etc/fstab i dodanie lini:
```
/dev/vg1/lv1 /mnt xfs defaults 1 2
```

Reperowanie odmontowanego filesystemu xfs:
```
xfs_repair /dev/vg1/lv1
```

Wylistowanie szczegółów na temat filesystemu:
```
xfs_info /dev/vg1/lv1
```

## Mount and unmount network file systems using NFS

### Nie wymagane na egzaminie
Instalowanie serwera NFS:
```
yum groupinstall -y file-server
```

Dodanie ruli na FW:
```
firewall-cmd --permanent --add-service=nfs
firewall-cmd --reload
```

Wystartowanie NFSa przy starcie systemu:
```
systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server
```

Torzenie folderu do exportu:
```
mkdir /home/nfs-share
chmod 777 /home/nfs-share
```

Update kontekstów SELINUXa:
```
yum install -y setroubleshoot-server
```

Włączenie SELINUX booleans:
```
setsebool -P nfs_export_all_rw on
setsebool -P nfs_export_all_ro on
setsebool -P use_nfs_home_dirs on
```

Edycja pliku /etc/exports i stworzenie nowej lini montujacej zasób NFS:
```
/home/nfs-share 10.0.2.6(rw,no_root_squash)
```

Restart serwera NFS:
```
systemctl restart nfs-server
```

Sprawdzenie czy zasób działa:
```
showmount -e localhost
NFS Client Setup (10.0.2.6)
```


### To jest wymagane na egzaminie

Instalacja NFS-Utils (jeśli brakuje):
```
yum install -y nfs-utils
```

Tymczasowe montowanie zasobu NFS:
```
mount -t nfs 10.0.2.5:/home/nfs-shared /mnt
```

Sprawdzenie czy zasób działa:
```
ls /mnt
vi /mnt/somefile
```

Odmontowywanie zasobu:
```
umount /mnt
```

Montowanie zasobu permanentnie, edycja pliku /etc/fstab i dodanie linii:
```
10.0.2.5:/home/nfs-share /mnt nfs4 defaults 1 2
```

Testowanie montowania zasób przez konfigurację z fstaba:
```
mount -a
```


## Extend existing logical volumes

Sprawdzanie aktualnego LVMa:
```
lvs
lvdisplay
```

Sprawdzenie logcznych wolumenów:
```
vgs
vgdisplay
```

Rozszerzenie logicznego wolumenu:
```
lvextend -L +2G /dev/vg1/lv1
```

Sprawdzenie czy rozmiar się powiększył:
```
lvdisplay
```

Sprawdzenie systemu plików na logicznym wolumenie:
```
df -Th
```

Resize filesystemu (per typ):

EXT3/4:
```
resize2fs /dev/vg1/lv1
```

XFS (używanie punktu montującego):
```
xfs_growfs /mnt
```

Sprawdzenie czy resize się powiódł:
```
df -h
```


## Create and configure set-GID directories for collaboration

Dodanie nowej grupy:
```
groupadd accounts
```

Sprawdzenie czy grupa została stworzona:
```
cat /etc/group | grep accounts
```

Stworzenie nowego folderu pod share
```
mkdir -p /home/shared/accounts
```

Aktualizacja ownershipu w taki sposób ze żaden user jest właścicielem katalogu ale grupa jest:
```
chown nobody:accounts /home/shared/accounts
```

Ustawienie SGID:
```
chmod g+s /home/shared/accounts
```

Nadanie others "brak praw":
```
chmod 770 /home/shared accounts
```

Sprawdzenie uprawnień:
```
ls -lhtra /home/shared/
drwxr-s--- 1 nobody accounts 4.0K Jan 14 09:42 accounts 
```

Stowrzenie dwóch kont użytkowników w celach testowych:
```
useradd -G accounts accountant1
useradd -G accounts accountant2
```

SU na jedno z utworzonych kont i sprawdzenie czy uprawnienia działają poprawnie (stworzenie pliku):
```
su - accountant1
cd /home/shared/accounts
touch accountsfile1
exit
```

SU na drugie z utworzonych kont i potwierdzenie że edycja przykładowego pliku jest możliwa (vi/nano):
```
su - accountant2
```
Testowanie z innym userem aby zobaczyć czy tylko uprawnienia dla grupy działają:
```
useradd user1
su - user1
```

Wykonanie poniższej komendy powinno być zabronione ("permission denied"):
```
cd /home/shared/accounts
```


## Configure disk compression

Dzięki Virtual Data Optimizer (VDO) można tradeować zasoby procesora / pamięci RAM na miejsce na dysku.
Pozwala to na kompresję plików bez konieczności używania gzip, rar lub innych narzędzi do kompresji.
Jeśli chodzi o przypadki użycia, VDO może być na przykład używane w lokalnych systemach plików, iSCSI lub Ceph.

Instalacja aplikacji:
```
yum install vdo kmod-kvdo
```

Tworzenie wolumenu VDO:
```
vdo create --name=vdo1 --device=/dev/sdb \ --vdoLogicalSize=30G --writePolicy=auto
```

VDO wspiera tylko 3 tryby zapisu:
- ‘sync’ mode, gdzie zapis do urządzenia VDO następuje, gdy dysk jest zapisany danymi na stałe - permanentnie
- ‘async’ mode, gdzie zapis występuje przed permanentnym zapis na dysk
- ‘auto’ mode, defaultowy, który wybiera async lub sync w zależności od możliwości dysku

Tworzenie filesystemu:
```
mkfs.xfs /dev/mapper/vdo1
```

Montowanie nowego dysku:
```
mount /dev/mapper/vdo1 /mnt
```

## Manage layered storage

Stratis jest rozwiązaniem do zarządzania lokalnym storagem wbudowany w RHEL8. Stratis wspiera nstępujące funkcje:
- Thin provisioning (alokowanie miejsca ale nie reserwowanie/zajmowanie go)
- Pool-based storage (wiele urządzeń blokowych prezentowanyh jako jeden zasób/poola)
- Filesystem snapshots (snapshoty na filesystemie)

Aby zainstalować Stratis wykonaj:
```
dnf install stratisd stratis-cli
```

Sprawdzenie statusu daemonu:
```
systemctl status stratisd
```

Wystartowanie usługi:
```
systemctl start stratisd
```

Włączenie usługi przy bootowaniu:
```
systemctl enable stratisd
```

**Tworzenie pooli**

Sprawdzenie aktualnych urządzeń blokowych (np. /dev/sdb i /dev/sdc):
```
lsblk
```

Potwierdzenie że urządzenia blokowe nie mają na sobie żadnego filesystemu aktualnie utworzonego:
```
blkid -p /dev/sdb
blkid -p /dev/sdc
```

Jeżeli filsystem jest aktualnie utworzony, musimy wyczyścić go za pomocą komendy:
```
wipefs -a /dev/sdb
wipefs -a /dev/sdc
```

Tworzenie pooli:
```
stratis pool create strat1 /dev/sdb /dev/sdc
```

Sprzawdzenie czy poola się utworzyła:
```
stratis pool list
```

Tworzenie filesystemu na nowo utworzonej pooli:
```
stratis fs create stratis fs1
```

Sprzawdzenie czy filesystem stowrzył się poprawnie:
```
stratis fs list strat1
```

Wylistowanie urządzeń blokowych po utworzeniu pooli:
```
lsblk
```

Montowanie filesystemu:
```
mount /stratis/strat1/fs1 /mnt
```

Aby zamontować zasób a wposób automatyczny przy bootownaiu (permanentnie) możemy użyć do tego pliku fstab.

Dodanie nowego urządzenia blokowego do istniejącej pooli:
```
stratis pool add-data strat1 /dev/sdd
```

Sprawdzenie pooli po rozszerzeniu:
```
stratis pool list
```

Tworzenie snapshotu na filesystemie:
```
stratis fs snapshot strat1 fs1 snapshot1
```

Sprawdzenie czy snapshot się stworzył:
```
stratis filesystem list strat1
```

Przywrócenie z snapshotu:
```
umount /stratis/strat1/fs1
```

Tworzenie snapshotu na filesystemie:
```
stratis filesystem snapshot strat1 fs1 snapshot2
```

Montowanie snapshotu:
```
mount /stratis/strat1/snapshot1
```

Usunięcie snapshotu:
```
umount /stratis/strat1/snapshot1
stratis filesystem destroy strat1 snapshot1
stratis filesystem destroy strat1 snapshot2
```

Wylistowanie filesystemu aby sprawdzić czy usnięto:
```
stratis filesystem list strat1
```

Usunięcie pooli:
```
umount /stratis/strat1/fs1
stratis filesystem destroy strat1 fs1
```

Potwierdzenie że poola została usunięta:
```
stratis pool list
lsblk
```


## Diagnose and correct file permission problems

ACL (Access Control Lists) pozwalają na stosowanie zaawansowanych uprawnień do plików zgodnie ze standardem POSIX ACL. 
Standardowe systemy plików w Linux jak ext3/4, montowane z opcją **acl**, pozawlają na stosowanie uprawnień rozszerzonych. 

Sprawdzenie czy ACLki są włączone na filesystemie (zwrócą uprawnienia jeśli włączone):
```
getfacl file
```

Aktualizacja aktualnych uprawnień ACL dla usera:
```
setfacl -m u:user:rwx file
```

Aktualizacja aktualnych uprawnień ACL dla grupy:
```
setfacl -m g:group:r file
```

Przegląd aktualnych uprawnień:
```
ls -l
```

Zmiana ownera lub grupy dla pliku/katalogu:
```
chown user:group file
```

Zmiana uprawnień dla pliku/katalogu:
```
chmod xxx file
```

gdzie xxx jest np. 750 (rwx,rx,-)

## Using AutoFS with NFS

***Aby AutoFS zadziałał musimy mieć poniższe rzeczy:***
1. NFS Serwer zainstalowany i uruchomiony

Instalacja NFS serwera (nie wymagane na egzaminie):
```
yum groupinstall -y file-server
```

Dodanie ruli na firewallu.
```
firewall-cmd --permanent --add-service=nfs
firewall-cmd --reload
```

Konfiguracja serwisu aby uruchamiała się przy starcie systemu:
```
systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server
```

Tworzenie katalogów dla exportu:
```
mkdir /home/nfs-share
chmod 777 /home/nfs-share
```

Aktualizacja kontekstów SELinuxa:
```
yum install -y setroubleshoot-server
```

Włączenie SELinux booleans:
```
setsebool -P nfs_export_all_rw on
setsebool -P nfs_export_all_ro on
setsebool -P use_nfs_home_dirs on
```

Restart serwera NFS:
```
systemctl restart nfs-server
```

2. NFS Serwer shareujący folder home

Aby shareować folder home, dodaj linijkę do pliku /etc/exports (IP jest to adres klienta - nie serwera):
```
/home/nfs-share 10.0.2.6(rw,no_root_squash)
/home 10.0.2.6(rw,no_root_squash)
```

Restart serwera NFS:
```
systemctl restart nfs-server
```

Sprawdzenie czy share działa i jest zamontowany:
```
showmount -e localhost
```


Restart serwera NFS:
```
systemctl restart nfs-server
```

3. AutoFS zainstalowany i skonfigurowany na maszynie klienckiej

**Note:** Pierwszym krokiem jest sprawdzenie czy `IDs` dla uzytkowników pomiędzy Serverem NFS a Klientem są takie same, jeśli są inne/różne należy zmienić je tak, aby były takie same, inaczej automount nie będzie działać.

Aby sprawdzić ID użytkownika:
```
id
```

Jeśli oba IDs nie są takie same wykonaj poniższą komendę na maszynie Klienta (zamiana ID dla user1):
```
usermod -u <id> user1
```

Następnie musimy poprawić pliki tego użytkownika i zamienić stare ID z nowym:
```
for i in find / -user 1001; do chown id $i; done
```

Jeżeli to samo dotyczy grup (groupid) możesz zrobić to samo, zmiana id grupy:
```
groupmod -g <id> user1
```


Następnie musimy poprawić pliki tej grupy i zamienić je na nową grupę za pomocą polecenia `chgrp`:
```
for i in `find / -user 1001`; do chgrp <id> $i; done
```

Instalacja na maszynie Klienta autofs:
```
dnf install autofs
```

Konfiguracja autofs, stworzenie pliku autofs.home:
```
vi /etc/auto.master.d/home.autofs
```

Następnie należy dodać linię:

```
/home /etc/autofs.home
```

Tworzymy nowy plik /etc/autofs.home with the actual configuration:
```
*   -rw     10.0.2.5:/home/&
```

Restart usługi autofs:
```
systemctl restart autofs
systemctl enable autofs
```

Testowanie: zaloguj się jako user1 na maszynie Klienta i sprawdź, powinno być home directory zamontowane przez autofs z Serwera NFS.

