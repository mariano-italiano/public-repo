# RHCSA - Lekcja 1

Zamieszczam materiały i komendy (polecenia) które były użyte podczas zajęć.

## Use input-output redirection (>, >>, |, 2>, etc.)

```
ls -la > wyjscie.std
ls -la >> wyjscie.dopisanie
ls -la >& wyjscie.w.tle
ls -la 2> wyjscie.z.bledem
```
## Use grep and regular expressions to analyze text

Przykładowy plik tekstowy wejściowy **file.txt**:

> 123 Foo foo foo 
foo /bin/bash Ubuntu foobar 456

**SED**
```
sed -i 's/foo/linux/g' file.txt		              <- zamiana słowa foo na linux w całym pliku (globalnie)
sed -i 's/\bfoo\b/linux/g' file.txt	              <- zamiana wszystkich słów zawierających foo na linux w całym pliku (globalnie)
sed -i 's/foo/linux/gI' file.txt	              <- zamiana słowa foo na linux w całym pliku (globalnie) z ignorowaniem wielkości liter
sed -i 's|/bin/bash|/usr/bin/zsh|g' file.txt	      <- zamiana /bin/bash na /usr/bin/zsh w całym pliku (globalnie)
sed -i 's/\b[0-9]\{3\}\b/number/g' file.txt	      <- zamiana wszystkich 3-cyfrowych stringów na słowo number w całym pliku (globalnie)
sed -i 's/\b[0-9]\{3\}\b/{&}/g' file.txt	      <- dodanie do wszystkich 3-cyfrowych stringów { na początku i } na końcu w całym pliku (globalnie)
```
**GREP**
```
cat plik | grep -i test		<- wyszukanie w pliku plik lini które zawierają słowo test (z ignorowaniem wielkości liter)
cat plik | grep -v "#" 		<- pominięcie wszystkich lini zawierających #
grep root /etc/passwd		<- wyszukanie w pliku /etc/passwd lini które zawierają słowo root
grep ^root /etc/passwd		<- wyszukanie w pliku /etc/passwd lini które zaczynają się od słowa root
grep :/home/.*: /etc/passwd	<- wyszukanie w pliku /etc/passwd lini które zawierają linie :/home/<dowolne znaki>:
```
**FIND**
```
find / -name "plik1" -exec rm {} \;
find . -type f -name "*.json" -exec cp {} /tmp/MusicFiles \;
```
## Access remote systems using SSH

```
ssh user@ip-addr
```

## Create and edit text files

**VI**
```
:21 			            <- przejscie do lini 21
:$  			            <- przejscie na koniec dokumentu (ostatnia linia)
:w  			            <- zapis
:x  			            <- zapis i wyjscie
:wq 			            <- zapis i wyjscie
:2,5 w nowyPlik			    <- zapisanie lini 2-5 do nowego pliku 
```

## Create, delete, copy, and move files and directories

```
mkdir folder                        <- stworzenie katalogu
mkdir -p /opt/test/folder           <- stworzenie katalogu i wszystkich podkatalogów
rmdir folder                        <- usunięcie pustego katalogu
rm -Rf folder                       <- usunięcie niepustych katalogów z zawartością rekursywnie
rm plik                             <- usunięcie pliku
cp /folder/plik1 /folder/plik2      <- skopiowanie pliku1
cp -R /folder /tmp/folder           <- skopiowanie rekursywnie całego folderu do nowej lokalizacji	
mv plik plik2                       <- zmiana nazwy pliku na plik2
mv /tmp/plik1 /home/plik2           <- przeniesienie pliku1 do nowej lokalizacji
```

## Create hard and soft links
**Dowiązanie miękkie**
Dowiązanie miękkie - skrót, po usunięciu plik dowiązanie cały czas istnieje ale nie wskazuje na nic (bo plik usunęliśmy). Liczba i-nodów (i-węzłów) = 1.
```
ln -s plik link     <- dowiązanie miękkie 
ls -li              <- wylistowanie plików z liczbą węzłów
```
**Dowiązanie twarde**
Dowiązanie twarde - duplikat, wszystkie zmiany dokonane na dowiazaniu lub na pliku oryginalnym są widoczne wszedzie, po usunięciu pliku link zostaje i nie usuwa się, nadal jest dostepny i do użycia, prawa nadawane na plik lub dowiązanie są powielane na duplikacie. Liczba i-nodów (i-węzłów) = 2.
```
ln plik link      <- dowiązanie twarde
ls -li            <- wylistowanie plików z liczbą węzłów
```

- - -
- - - -
# Additional topics

## Use version control tools

**Konfiguracja GIT**
```
yum install git
git config --global user.name "First Name"
git config --global user.email "email@gmail.com"
git config --list
git clone ssh://git@github.com:xyz/master.git
```

## Run commands on many systems simultaneously
**Parallel SSH - PSSH**
```
yum install pssh
vi computers
pssh -i -h computers "date;ls -la"
```
Before execution of pssh it is required to generate ssh keys to login without password.
```
ssh-keygen
ssh-copy-id user@server-ip
ssh user@server-ip
```
