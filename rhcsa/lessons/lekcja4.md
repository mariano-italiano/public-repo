# RHCSA - Lekcja 4

Zamieszczam materiały i komendy (polecenia) które były użyte podczas zajęć.

[List, create, delete partitions on MBR and GPT disks](#List-create-delete-partitions-on-MBR-and-GPT-disks)<br />
[Create and remove physical volumes](#Create-and-remove-physical-volumes])<br />
[Assign physical volumes to volume groups](#Assign-physical-volumes-to-volume-groups)<br />
[Create and delete logical volumes](#Create-and-delete-logical-volumes)<br />
[Configure systems to mount file systems at boot by universally unique ID UUID or label](#Configure-systems-to-mount-file-systems-at-boot-by-universally-unique-ID-UUID-or-label)<br />
[Add new partitions and logical volumes and swap to a system non-destructively](#Add-new-partitions-and-logical-volumes-and-swap-to-a-system-non-destructively)<br />

## List create delete partitions on MBR and GPT disks

Listowanie rozmiaru / użycia i dostępnego miejsca / % / punktu montowania:
```
df -h
```

Wyświetlenie UUID dla partycji i dysków:
```
blkid
```

Wyświetlenie partycji i dysków w formie drzewa:
```
lsblk
```

Wymuszenie systemu do sprawdzenia partycji i zmian na nich:
```
partprobe
```
**fdisk** – narzędzie do aprtycjonowania MBR(Master Boot Record)
4 primary partitions (2TB max)

Tworzenie partycji:
```
fdisk /dev/sdb 
n - nowa partycja 
p lub # e (primary or extended)
w - zapisanie zmian
```
Usuwanie partycji:
```
fdisk /dev/sdb
d - usunięcie partycji
w - zapisanie zmian
```
Zmiany typu partycji:
```
fdisk /dev/sdb
t - zmiana typu
L - wylistowanie wszystkich typów
w - zapisanie zmian
```
Wylistowanie wszystkich partycji:
```
fdisk -l
```

**gdisk** – narzędzie do aprtycjonowania GPT
urządzenia UEFI – backwards compatible – 128 primary partition – 8 zebibytes per partition

Tworzenie partycji:
```
gdisk /dev/sdb
n - nowa partycja 
p lub # e (primary or extended)
w - zapisanie zmian
```
Usuwanie partycji:
```
gdisk /dev/sdb
d - usunięcie partycji
w - zapisanie zmian
```
Jeżeli partycje nie pokazują się w systemie po ich stworzeniu lub nie znikają po ich usunięciu wykonaj komendę: 
```
partprobe
lub
for i in `seq 0 32`; do echo "- - -" > /sys/class/scsi_host/host$i/scan; done
```
Wylistowanie wszystkich partycji:
```
gdisk -l /dev/sdb
```

## Create and remove physical volumes

Wylistowanie LVMs: 
```
pvdisplay
pvs
```

Wylistowanie wszystkich dysków: 
```
fdisk -l 
```
  
Tworzenie nowej partycji: 
```
fdisk /dev/sdb 
o (stworzenie nowej partycji) 
p (wyświetlenie tablicy partycji) 
w (zapis) 
```
 
Tworzenie nowej partycji z typem LVM: 
```
fdisk /dev/sdb 

n (nowa partycja) 
p (podstawowa) 
1 (numer) 

ustawianie rozmiaru (enter defaultowo dla zajętosci 100% wolnej przestrzeni) 
t (typ partycji) 
8e (LVM) 
```
 
Tworzenie fizycznego wolumenu LVM: 
```
pvcreate /dev/sdb1 
```

Usuwanie fizycznego wolumenu LVM: 
```
pvremove /dev/sdb1 
```

## Assign physical volumes to volume groups

Tworzenie grupy wolumenowej LVM: 
```
vgcreate vg1 /dev/sdb1 
```

Dodawanie fizycznego wolumenu (/dev/sdb2) do istniejącej groupy wulumenowej (vg1): 
```
vgextend vg1 /dev/sdb2 
```

Usuwanie fizycznego wolumenu (/dev/sdb2) z istniejącej groupy wulumenowej (vg1):
```
vgreduce vg1 /dev/sdb2 
```

Usunięcie całej grupy wolumenowej (vg1): 
```
vgremove vg1 
```

Wylistowanie wszystkich grup wolumenowych: 
```
vgs 
```

## Create and delete logical volumes

View the volume group: 
```
vgs 
lub
vgdisplay 
```

To create the logical volume and set the size use: 
```
lvcreate -L 4G -n lv1 vg1 
gdzie: 
-L  <- rozmiar
-n  <- nazwa 
vg1 <- grupa wolumenowa 
```

Wylistowanie logicznych wolumenów: 
```
lvs 
lub 
lvdisplay 
```

To extend the logical volume: 
```
lvextend -L +1G /dev/vg1/lv1 
gdzie: 
+1G  <- podanie wartości o ile zwiększyć logiczny wolumen 
```

Zmniejszanie logicznego wolumenu (może to prowadzić do utraty danych): 
```
lvresize -L -1G /dev/vg1/lv1 
```

Usuwanie logicznego wolumenu: 

Jeżeli jest zamontowany to najpierw odmontować:
```
umount /mnt/point 
gdzie: 
/mnt/point jest miejscem gdzie zamontowany jest logiczny wolumen
```

Usuwanie logicznego wolumenu: 
```
lvremove /dev/vg1/lv1 
```

## Configure systems to mount file systems at boot by universally unique ID UUID or label

Utworzenie filesystemu ext4 na logicznym wolumenie /dev/vg1/lv1: 
```
mkfs.ext4 /dev/vg1/lv1 
```

### Montowanie za pomocą UUID: 

UUID to skrót od **Universal Unique ID**. Jest to 128-bitowa wartość która w unikalny sposób identyfikuje dysk lub partycję dysku.

Aby wylistować UUIDy dla dysków: 
```
blkid 
```

Aby zdefiniować dysk/partycję którą chcemy zamontować automatycznie podczas startu systemu musimy dopisać ją do pliku konfiguracyjnego /etc/fstab: 
```
blkid | grep <nazwaLVMa> >> /etc/fstab 
```

Następnie edytujemy plik /etc/fstab i zmieniamy nowo dodaną linijkę uzupełniając poprawnie wszystkie wymagane parametry: 
```
UUID=".." /mnt ext4 defaults 1 2
```
 
Aby zamontować disk/partycję: 
```
mount /mnt 
```

### Montowanie za pomocą labela
Dysk lub partycja oprócz UUIDa ma także label. Aby przypisać label do dysku lub partycji wykonaj: 
```
e2label /dev/vg1/lv1 LogicalVol1 
```
Aby wylistować label zwiazany z danym dyskiem/partycją: 
```
e2label /dev/vg1/lv1 
```

Aby zamontować partycję (/dev/vg1/lv1), wyedytuj plik /etc/fstab i dodaj poniższą linijkę do pliku: 
```
LABEL=LogicalVol1 /mnt ext4 defaults 0 2 
```

Aby zamontować disk/partycję: 
```
mount /mnt 
```

## Add new partitions and logical volumes and swap to a system non-destructively

Wylistowanie fizycznych partycji LVM:
```
pvs
```

Wylistowanie grupy wolumenowej:
```
vgs
```

Tworzenie nowego logicznego wolumenu (pod swapa):
```
lvcreate -n swap1 -L 2G vg1
```
Tworzenie nowego logicznego wolumenu (pod swapa) z wykorzystaniem całej dostępnej przestrzeni:
```
lvcreate -n swap1 -l 100%FREE vg1
```
Tworzenie partycji swapowej:
```
mkswap /dev/vg1/swap1
```

Montowanie swapa (nie permanentnie):
```
swapon /dev/vg1/swap1
```

Wylistowanie zamontowanych swapów:
```
swapon -s
```

Odmontowanie swapa:
```
swapoff /dev/vg1/swap1
```

Aby zamontować swap permanentnie trzeba wyedytować plik /etc/fstab i skopiować (yy, p) linie swapa aktualnie zamontowanego i potem poprawić punkt montowania:
```
/dev/vg1/swap1         swap          swap        defaults          0     0
```

Aby zamontować wszystkie partycje swapowe z pliku /etc/fstab:
```
swapon -a
```
Tworzenie swapa z pliku:
```
dd if=/dev/zero of=swapfile bs=1024 count=1048576
chmod 600 swapfile
mkswap swapfile
swapon swapfile
free -h
```
