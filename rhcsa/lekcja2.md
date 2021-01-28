# RHCSA - Lekcja 2

Zamieszczam materiały i komendy (polecenia) które były użyte podczas zajęć.

## Additional Important Commands

```
export http_proxy="ip:port
echo $http_proxy"
history 
.bash_history (HISTSIZE variable by default it is 500 lines)
.bashrc
alias ls='ls --color=auto'
alias myCommand='cd /usr/bin; ls; cd; clear'
head -n3 /etc/passwd
tail -n3 /etc/passwd
```
**Extract specific fields: 1 and 3 in this case**
```
cut -d: -f1,3 /etc/passwd 
```
**Extract range of fields: 2 through 4 in this example**
```
cut -d: -f2-4 /etc/passwd 
```
## Archive, compress, unpack, and uncompress files using tar, star, gzip, and bzip2
### Komenda TAR
**Tworzenie**
```
tar cvf plik.tar katalog/
tar cvfz plik.tar.gz katalog/
tar cvzf archiwum.tar.gz plik1 plik2 plik3
tar czjf plik.tar.bz2 katalog/
```
**Rozpakowanie**
```
tar xvf plik.tar
tar xzvf plik.tar.gz
tar xjvf plik.tar.bz2
tar cJf plik.tar.xz /var/log/httpd/* --same-permissions --same-owner


-bzip2			    		        -j	Compresses an archive through bzip2
-xz						-J	Compresses an archive through xz
-same-permissions and -same-owner		-p	Preserves permissions and ownership information, respectively.
```
**Testowanie**
```
tar tjvf plik.tar.bz2
tar tzvf plik.tar.gz
```
###  Komendy GZIP i BZIP
```
gzip plik
gunzip plik

bzip2 --commpress plik
bzip -z plik

bzip2 --decompress plik.bz2
bzip2 -d plik.bz2
bunzip2  plik.bz2
```

## Locate, read, and use system documentation including man, info, and files in /usr/share/doc

```
man <polecenie>
<polecenie> --help  
lub
<polecenie> -h
```

## List, set, and change standard ugo/rwx permissions

Uprawnienia to kombinacja trzech uprawnień: 
- r- czytanie (4)
- w- zapis (2)
- x- wykonanie (1)

odpowiednio dla właściciela, grupy i reszty użytkowników, np.:

**-rw-r--r--**	1 root	users	0 paź 24 18:04 plik

Plik posiada prawa **644**, czyli:
- czytania i zapisu (rw- : 4+2=6 zapis dziesiętny) dla właściciela, w tym przypadku dla użytkownika „root”
- prawo czytania dla grupy (r-- : 4 zapis dziesiętny), w tym przypadku dla grupy „users”
- prawo czytania dla reszty (r-- : 4 zapis dziesiętny)

Polecenie służące do modyfikacji i listowania uprawnień:
```
ls -la				<- listowanie
chmod 755			<- zmiana uprawnień
chown owner:grupa	        <- zmiana ownera
umask				<- wyświetla domyślną nadawania uprawnień
```
**SetUID** – pozwala na określenie pod jakim identyfikatorem użytkownika jest wykonywany program, np.
``
chmod 4755 plik
 ``
 
**SetGID** – pozwala na określenie pod jakim identyfikatorem grupy jest wykonywany program, w przypadku użycia z katalogiem wszystkie podkatalogi i pliki w nim tworzone posiadają grupę katalogu nadrzędnego, np.:
```
chmod 2755 plik
chmod 2644 plik
 ```

**Bit Sticky** – pozwala programowi na pozostanie w pamięci po zakończeniu działania. Jest pozostałością z przeszłości, ponieważ nie ma potrzeby aby programy pozostawały w pamięci po zakończeniu. Najczęściej stosuje się go do katalogu. Gdy jest użyty z katalogiem to użytkownicy mogą kasować tylko te pliki, dla których mają wprost uprawnienia do zapisu, nawet jeśli mają prawo zapisu do katalogu, np. katalog /tmp,np.:
```
chmod 1755 plik
```
- - -
- - - -
# Scripts and automation
## BASH

[Skrypty przygotowane do przejrzenia](https://github.com/mariano-italiano/public-repo/tree/master/rhcsa/scripts)

## SHELL
```
for i in user1 user2 user3; do id $i; done 
for i in `seq 17 24`; do bzip2 authlog-2021-01-$i; done
for i in `seq 10 20`; do ip a a 10.10.$i.10/24 dev ens33; done
for i in `seq 1 10`; do lvcreate vg_group -n lv_partition$i -L 128m; done
for i in `seq 2 10`; do echo -e "lv_$i -fstype=ext4 :/dev/vg_group/lv_$i" >>/etc/auto.konfig; done
```
