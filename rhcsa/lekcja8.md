# RHCSA - Lekcja 8

Zamieszczam materiały i komendy (polecenia) które były użyte podczas zajęć.

[Configure firewall settings using firewall-cmd](#Configure-firewall-settings-using-firewall-cmd)</br>
[Create and use file access control lists](https://github.com/mariano-italiano/public-repo/blob/master/rhcsa/lekcja5.md#Diagnose-and-correct-file-permission-problems)</br>
[Configure key-based authentication for SSH](#Configure-key-based-authentication-for-SSH)</br>
[Set enforcing and permissive modes for SELinux](#Set-enforcing-and-permissive-modes-for-SELinux)</br>
[List and identify SELinux file and process context](#List-and-identify-SELinux-file-and-process-context)</br>
[Restore default file contexts](#Restore-default-file-contexts)</br>
[Use boolean settings to modify system SELinux settings](#Use-boolean-settings-to-modify-system-SELinux-settings)</br>
[Diagnose and address routine SELinux policy violations](#Diagnose-and-address-routine-SELinux-policy-violations)</br>


## Configure firewall settings using firewall-cmd

Lokalny firewall jest zarządzany przez polecenie firewall-cmd.

Podstawą jest zrozumienie pojęcie zone'y które zostało zaprezentowane w poprzedniej lekcji. 

Na egzaminie jednak może trafiź się włączenie IP forwardingu, który w zasadzie pozwala serverowi wyroutować odpowiednio pakiety. 

Aby włączyć IP forwarding należy wyedytwać plik sysctl:
```
vi /etc/sysctl.conf
```
Dodaj linijke:
```
net.ipv4.ip_forward=1
```
Następnie przeładowanie sysctl i wczytanie nowych zmian i konfiguracji:
```
sysctl -p
```

Konfiguracja firewalla za pomocą GUI:
```
firewall-config
```

Pakiet nie jest zainstalownay by default więć należy go doinstalować manualnie:
```
dnf install firewall-config
```

Aby wylistować status firewalla:
```
firewall-cmd --state
```

Aby wylistować wszystkie zony:
```
firewall-cmd --get-zones
```

Aby zobaczyć co jest skonfigurowane w konkretnej zonie:
```
firewall-cmd --zone servers --list-all
```

Aby zobaczyć jakie zony są przypisane do jakich interfejsów:
```
firewall-cmd --get-active-zones
```

Aby zobaczyć aktualny konfig dla zony:
```
firewall-cmd --zone servers --list-all
```


## Configure key-based authentication for SSH

SSH wspiera autentykację po kluczach, która używa certifikatów aby pozwolić zalogować się użytkonikom na system. W wielu przypadkach jest to bardziej bezpieczne niż standardowa konfiguracja z userem i hasłem lokalnym.

Aby skonfigurować authentykację po kluczach musisz mieć dwa typy kluczy:
- Publiczny – klucz który przechowujesz w ~/.ssh/authorized_keys
- Prywatny – klucz który musi być trzymany w bezpiecznym miejscu, gdyż tym kluczem logujemy się do systemu

Generowanie klucza:
```
ssh-keygen
```

Komenda ta wygeneruje folder ukryty .ssh z kluczem publicznym i prywatnym. Niestety nie wygeneruje to pliku authorized_keys, trzeba to zrobić manualnie:
```
cd .ssh
```

Jeśli nie ma go aktualnie w katalogu .ssh musimy go stworzyć:
```
touch authorized_keys
```

Następnie musimy nadać odpowiednie uprawnienia:
```
chmod 600 authorized_keys
```

Jeżeli chcemy aby inny serwer mógł się zalogować należy skopiować treść pliku id_rsa.pub (klucz publiczny) do pliku authorized_keys. 

## Set enforcing and permissive modes for SELinux

SELinux definiuje kontrolę dostępu do aplikacji, procesów i plików w systemie. Używa polityk bezpieczeństwa, które są zbiorem reguł, które mówią SELinuxowi do czego można lub nie można uzyskać dostępu, aby wymusić dostęp dozwolony przez politykę.

Kiedy aplikacja lub proces, znany jako 'subject', wysyła żądanie dostępu do obiektu, takiego jak plik, SELinux sprawdza za pomocą wektorowej pamięci podręcznej (AVC), gdzie uprawnienia podmiotów i obiektów są cachowane.

Jeśli SELinux nie jest w stanie podjąć decyzji o dostępie na podstawie uprawnień z pamięci podręcznej, wysyła żądanie do serwera bezpieczeństwa. Serwer bezpieczeństwa sprawdza kontekst aplikacji lub procesu lub pliku. Kontekst bezpieczeństwa jest przypisany z bazy danych polityki SELinuxa. Pozwolenie jest wóczas udzielane lub odmawiane. 


Jeśli dostęp jest odmówiony, wówczas mamy komunikat "avc: denied" w logach /var/log/messages.


Aby sprawdzić aktualny status SELINUXa:
```
getenforce
```

Aby dostać pełny status SELINUXa:
```
sestatus
```

Aby zmienić politykę z  enforce na permissive musimy wyedytować plik:
```
vi /etc/selinux/config
```

Edytujemy linię:
```
SELINUX=enforcing
```

i zmieniamy na:
```
SELINUX=permissive
```


## List and identify SELinux file and process context

SELinux ma ogromną liczbę zdefiniowanych kontekstów, na przykład dla procesu ssh ale również innych.

Aby zobaczyć kontekst wszystkich plików/folderów w konkretnym folderze:
```
ls -Z
```

Aby zobaczyć kontekst wszystkich procesów uruchomionych na systemie:
```
ps -Zaux
```

Note to view the current processes for just this shell run:
```
ps -Z
```

Aby sprawdzić kontekst swojego użytkownika:
```
id -Z
```

## Restore default file contexts

Aby zobaczyć kontekst wszystkich plików/folderów w konkretnym folderze:
```
ls -Z
```

Aby zmienić konkretny kontekst na pliku:
```
chcon unconfined_u:object_r:tmp_t:s0 file.txt
```

Gdzie:
- _u is the user context
- _r is the role context
- _t is the type context
- s is the level

Jeżeli plik ma problem z kontekstem możemy wykonać przywrócenie kontekstu do stanu jaki SELINUX uważa za poprawny:
```
restorecon file.txt
```

Użycie restorecon -R pozwala na rekursywne wykonanie:
```
restorecon -R file.txt
```

## Use boolean settings to modify system SELinux settings

Booleans w SELINUXie pozwalają na włączenie lub wyłączenie pewnych zasad w polityce.

Aby wylistować wszystkie dostępne booleans:
```
getsebool -a
```

Filtrowanie wg konkretnej wartości:
```
getsebool -a | grep virtualbox
```

Jeżeli dostępny jest setroubleshoot-server można go również użyć aby sparwdzić jakie są odstępstwa od polityki:
```
semanage boolean -l
```

Instalacja pakietu jeżeli nie zainstalowany:
```
dnf install setroubleshoot-server
```

Ustawienie wartości boolean permanentnie:
```
setsebool -P use_virtualbox on
```


## Diagnose and address routine SELinux policy violations

Aby wyświetlić wszystkie naruszenia aktualnej polityki SELinuxa:
```
sealert -a /var/log/audit/audit.log
```

Aby przeszukać logi zawierające wpisy dotyczące SELinuxa:
```
ausearch -m AVC,USER_AVC,SELINUX_ERR
```

Można również przeszukać logi journala:
```
journalctl -t setroubleshoot
```

Jest również narzędzie które pozwala sparwdzić co jest lub zostało zablokowane:
```
audit2why -a
```

est również narzędzie które daje podpowiedzi odnośnie rozwiązań problemów z SELinuxaem:
```
audit2allow -w -a
```

**Przykład:** 
Jeżeli nie ma żadnych odstępstw można zasymulować sytuację która wygeneruje AVC denial. Polega ona na usunięciu dostępu użytkownikom, aby nie mogli wykonywać plików w ich katalogach, a następnie spróbowaniu wykonania. 

Aby usunąć dostęp dla określonego użytkownika, wykonaj następujące czynności (user1):
```
echo "user1:user_u:s0-s0:c0.c1023" `append to` /etc/selinux/targeted/seusers
```

Powyższa komenda nada użytkownikowi user1 user_u kontekst.

Aby skonfigurować selinux boolean aby blokował wykonanie plików w konkretnym folderze:
```
setsebool -P user_exec_content off
```

Sprawdzenie: spróbuj zalogować się jako user1, powinno to wygenerować AVC denial i odmowę dostępu. 
