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
**FOR**
```
for i in user1 user2 user3; do id $i; done 
for i in `seq 17 24`; do bzip2 authlog-2021-01-$i; done
for i in `seq 10 20`; do ip a a 10.10.$i.10/24 dev ens33; done
for i in `seq 1 10`; do lvcreate vg_group -n lv_partition$i -L 128m; done
for i in `seq 2 10`; do echo -e "lv_$i -fstype=ext4 :/dev/vg_group/lv_$i" >>/etc/auto.konfig; done
for RPM in `rpm -qa | sort | uniq` ; do rpm -qi $RPM ; done | egrep -i "^Name|^Summary" > RPM-summary.txt
```
**WHILE**
```
X=0 ; while [ true ] ; do echo $X ; X=$((X+1)) ; done | head
X=0 ; while [ $X -le 5 ] ; do echo $((X++)) ; done
X=0 ; until [ $X -eq 5 ] ; do echo $((++X)) ; done
```

# Manage users and groups
## Create, delete, and modify local user accounts
**Uid, Gid****

Każdy użytkownik w systemie posiada unikalny identyfikator UID, a grupa identyfikator grupy GID, które są konieczne do autoryzacji użytkownika czy grupy w systemie i przydziale praw dostępu. Konta użytkowników są zdefiniowane w plikach: /etc/passwd, /etc/shadow, natomiast grup w pliku /etc/group. Każdy użytkownik należy do pewnej grupy podstawowej, np. users. Oczywiście może należeć do innych grup ( grupy suplementarne) jeśli administrator da mu takie prawo.

Super użytkownikiem czyli administratorem systemu jest ROOT. Jest to krytyczne konto w systemie, dlatego należy chronić do niego dostęp, nie udostępniać hasła czy też nie wykorzystywać prostych haseł, łatwych do odkrycia przez np. ataki słownikowe.

Polecenia dla części praktycznej: 
```
id
finger
su
su – user
su – root
```

**Katalog domowy**

W czasie logowania użytkownika program /bin/login zmienia bieżący katalog na katalog domowy użytkownika, zmienia UID i GID, ostatecznie uruchamia shell zgłoszony (czyli powłokę systemową np. program /bin/bash).
Katalogi domowe użytkowników w systemie Linux znajdują się najczęściej w katalogu /home i posiadają nazwę taką jak login. Oczywiście katalog domowy może znajdować się w innym miejscu drzewa katalogowego, np. dla konta FTP obsługującego serwis WWW może to być podkatalog w /var/www.
Szczegółowe informacje o użytkowniku znajdujemy w pliku **/etc/passwd**, lub za pomocą poleceń **id, finger**.

Każdy użytkownik logujący się w systemie Linux jest identyfikowany w oparciu o konto użytkownika. Konto takie kontroluje dostęp do systemu, definiując nazwę użytkownika i hasło, które uwierzytelnia go podczas procesu logowania. Do kontroli przywilejów zalogowanego użytkownika wykorzystywane są identyfikator użytkownika – UID i identyfikator grupy – GID, odpowiadające danemu kontu. Wartości te, zdefiniowane podczas tworzenia konta użytkownika, kontrolują bezpieczeństwo systemu plików i identyfikują, który użytkownik kontroluje dany proces.

**Format pliku /etc/passwd**

root:x:0:0:root:/root:/bin/bash	# administrator systemu, użytkownik o UID=0, GID=0
daemon:x:1:1:daemon:/usr/sbin:/bin/sh
bin:x:2:2:bin:/bin:/bin/sh
sys:x:3:3:sys:/dev:/bin/sh
sync:x:4:100:sync:/bin:/bin/sync
games:x:5:100:games:/usr/games:/bin/sh
man:x:6:100:man:/var/cache/man:/bin/sh
lp:x:7:7:lp:/var/spool/lpd:/bin/sh
mail:x:8:8:mail:/var/spool/mail:/bin/sh
postgres:x:31:32:postgres:/var/lib/postgres:/bin/sh
www-data:x:33:33:www-data:/var/www:/bin/sh
backup:x:34:34:backup:/var/backups:/bin/sh
msql:x:36:36:Mini SQL Database Manager:/var/lib/msql:/bin/sh
nobody:x:65534:65534:nobody:/home:/bin/sh
user1:x:1000:100:Uzytkownik user1,,,:/home/user1:/bin/bash	# przykład zwykłego użytkownika
user2:x:1001:100:Uzytkownik user2,,,:/home/user2:/usr/bin/passwd

czyli:

**użytkownik:hasło:UID:GID:tekst_info:katalog_domowy:shell** , gdzie:


użytkownik - jest nazwą konta,
hasło – jest zaszyfrowanym hasłem użytkownika, w powyższym przykładzie nie ma wpisanego hasła, gdyż znajduje się ono w pliku haseł ukrytych shadow password (plik /etc/shadow),
UID – jest numerem ID użytkownika dla danego konta,
GID – jest numerem ID grupy dla grupy podstawowej danego użytkownika,
tekst_info – jest dowolną informacją tekstową o użytkowniku, np. imię i nazwisko,
katalog_domowy – jest katalogiem domowym użytkownika,
shell – jest powłoką logowania dla użytkownika, np. bash, sh, csh itp. Dostępne powłoki należy zdefiniować w pliku /etc/shells.

Plik haseł ukrytych /etc/shadow może być czytany tylko przez administratora. Nie przyznaje się praw dostępu dla grup, ani innych użytkowników. Został on zaprojektowany, aby normalni użytkownicy nie mogli czytać zaszyfrowanych haseł i wystawiać je na atak słownikowy. Oprócz poprawy bezpieczeństwa haseł, plik /etc/shadow dostarcza administratorom systemu kilku innych cech związanych z zarządzaniem hasłami.

**Format pliku /etc/shadow**
 

list:*:11501:0:99999:7:::
 
- konto systemowe, nie można się zalogować, brak powłoki (*)

irc:*:11501:0:99999:7:::
gnats:*:11501:0:99999:7:::
nobody:*:11501:0:99999:7:::
sshd:!:11863:0:99999:7:::
 

- konto zablokowane, posiada poprawną powłokę logowania (!)
 
netsaint:!:11939:0:99999:7:::
test:$1$B/cfDxoK$yJUyNWS9iRwnGpqlLqf8c/:11998:0:99999:7:::

czyli:

**nazwa_użytkownika:hasło:zmienione:min:max:ostrzeżenie:nieaktywne:zamknięte:zarezerwowane** , gdzie:

nazwa_użytkownika – jest nazwą konta (login),
hasło – jest zaszyfrowanym hasłem,
last change (zmienione) – jest datą, kiedy hasło było ostatni raz zmieniane, data jest zapisana jako liczba dni od 1 stycznia 1970 roku od daty zmiany,
min password age – jest minimalna liczbą dni, kiedy użytkownik musi stosować nowe hasło, zanim będzie mógł je zmienić, 0 - brak limitu
max password age – jest maksymalną liczbą dni, kiedy użytkownik może stosować hasło, zanim będzie musiał je zmienić,
warn period (ostrzeżenie) – definiuje na ile dni przed upływem ważności hasła użytkownika zostanie ostrzeżony, 0 – brak limitu
inactive period (nieaktywne) – definiuje, ile dni musi minąć po wygaśnięciu ważności hasła, zanim konto zostanie zablokowane. Gdy konto zostaje zablokowane, użytkownik nie może zalogować się i zmienić hasła,
zamknięte – jest datą kiedy konto zostanie zamknięte,
zarezerwowane – pole zarezerwowane.

**Tworzenie i usuwanie uzytkowników**
```
adduser
useradd -g users -G ftp -d /home/test -s /bin/bash -c "Imie i Nazwisko" test
userdel –r test
```
Blokowanie i odblokowanie konta użytkownika:
```
passwd –l test 
passwd –u test
```
Zmiana parametrów konta:
```
usermod –g users –G ftp,grupa1,grupa2  test
```
Zmiana  powłoki:
```
chsh
```
Zmiana informacji o koncie:
```
chfn
```
Tworzenie i usuwanie nowej grupy: 
```
groupadd grupa 
groupdel grupa
```
Zmiana parametrów grupy:
```
groupmod –g nowy_gid –n nowa_nazwa grupa
```



## Change passwords and adjust password aging for local user accounts

Zmiana hasła odbywa się poprzez polecenie:
```
passwd <user>
```






Wymuszenie zmiany hasła za 10 dni:
```
chage -M 10 <username>
```
Ustawienie daty na koncie kiedy ma być expired:
```
chage -E "2011-01-31" <username>
```
Wymuszenie aby konto było zablokowane po 10 dniach nieaktywności:
```
chage -I 10 <username>
```
Wyłaczenie agingu dla konta - never expires:
```
chage -m 0 -M 99999 -I -1 -E -1 <username>
```
Wylistowanie informacji o koncie:
```
chage -l
```
Wymuszenie zmiany hasła (teraz):
```
chage –d 0 <username>
```

## Create, delete, and modify local groups and group memberships

W celu utworzenia grupy, dodajemy w pliku **/etc/group** wpis postaci:

**nazwa_grupy:hasło:gid:użytkownicy** , gdzie:

nazwa_grupy – jest nazwą nowo tworzonej grupy,
hasło – nie jest używane, pozostawione puste,
gid – jest identyfikatorem grupy,
użytkownicy – jest listą użytkowników należących do danej grupy.


root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:waldi
tty:x:5:
disk:x:6:
lp:x:7:lp
users:x:100:waldi,kacper
nogroup:x:65534:
ftp:x:1001:waldi,kacper
samba:x:1002:root,waldi,krzys,slawek

## Configure superuser access

Dodanie usera do grupy wheel
```
usermod -aG wheel username
```
Testing sudo:
```
sudo whoami
```
Do edycji pliku sudoers służy polecenie:
```
visudo
```
Domyślna konfiguracja znajdująca się w pliku /etc/sudoers.
Liniki odnoszące się do uprawnień użytkowników:
```
user ALL=(ALL:ALL) ALL
```
Nazwa user odnosi się do użytkownika, którego reguły będą dotyczyć. 
Pierwsze ALL odnosi się do hosta, którego reguła dotyczy
Następne ALL (pierwsze w nawiasie) odnosi się do możliwości wykonywania poleceń przez użytkownika i kolejne do grupy.
Ostatnie all odnosi się do poleceń – w tym przypadku użytkownik może wszystko wykonywać bez użycia polecenia sudo. 

Ostatnie dwie linijki są podobne do uprawnień użytkownika, odnoszą się jednak do grup użytkowników i są poprzedzone %.:
```
%admin ALL=(ALL) ALL
```
Aby zalogować sie na roota wykonujemu:
```
sudo su
```
Aby odłożyć zaś wymuszenie wpisania hasła możemy posłużyć się poleceniem:
```
sudo -v
```
By sprawdzić, jakie mamy uprawnienia w chwili obecnej, możemy wydać polecenie:
```
sudo -l
```
