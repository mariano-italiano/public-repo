# RHCSA - Lekcja 6

Zamieszczam materiały i komendy (polecenia) które były użyte podczas zajęć.

[Schedule tasks using at and cron](#Schedule-tasks-using-at-and-cron)</br>
[Start and stop services and configure services to start automatically at boot](https://github.com/mariano-italiano/public-repo/blob/master/rhcsa/lekcja3.md#Start-stop-and-check-the-status-of-network-services)</br>
[Configure systems to boot into a specific target automatically](https://github.com/mariano-italiano/public-repo/blob/master/rhcsa/lekcja3.md#Boot-systems-into-different-targets-manually)</br>
[Configure time service clients](#Configure-time-service-clients)</br>
[Install and update software packages from Red Hat Network a remote repository or from the local file system](#Install-and-update-software-packages-from-Red-Hat-Network-a-remote-repository-or-from-the-local-file-system)</br>
[Work with package module streams](#Work-with-package-module-streams)</br>
[Modify the system bootloader](#Modify-the-system-bootloader)</br>

## Schedule tasks using at and cron

Planowanie zadań można wykonywać pry użyciu dwóch narzędzi:
- **at** 
- **cron**


### at – planowanie jednorazowych zadań, takie jak np. ponowne uruchomienie serwera


Instalacja:
```
dnf install at
```

Sprawdzenie usługi czy działa:
```
systemctl status atd
```

Wystartowanie usługi:
```
systemctl start atd
```

Planowanie zadania tak aby było wykonane za minute: 
```
at now + 1 minute
```

Następnie wyświetlony zostanie prompt aby wpisać "co" chcemy zaplanować, np.:
```
at> echo "Test" > test.txt
```

Aby zakończyć wprowadzanie komendy należy wcisnąć CTRL+D.

Aby zaplanować wykonanie skryptu o konkretnej godzinie:
```
at 3pm + 3 days -f script.sh
```

Aby wylistować wszystkie zaplanowane zadania a at:
```
atq
```
Każdy element ma przypisany numer zadania, można usunąć zaplanowany task za pomocą:
```
atrm <id>
```

### cron – planowanie powtarzających się zadań, takich jak cykliczne uruchamianie skryptu lub backup

Edycja crontaba:
```
crontab -e
```
Otworzy się nam wówczas edytor vi gdzie należy wpisać zaplanowane zadanie wg kolejności: 
```
mm hh dm mth dw komenda
```
Gdzie:
mm - minuta
hh - godzina 
dm - dzień miesiąca
mth - miesiąc 
dw - dzień tygodnia 
komenda - zaplanowane działanie, np. wykonanie skryptu

Przydatna strona do sprawdzenie czasu wykonania: crontab.guru 

Wylistowanie zadań z crontaba:
```
crontab -l
```

Edycja crontaba innego usera:
```
crontab -u user1 -e
```
Wylistowanie zadań crontaba innego usera:
```
crontab -u user1 -u
```


Configure systems to boot into a specific target automatically


## Configure time service clients

Wylistowanie aktualnej daty i godziny:
```
date
```

Wypisanie daty w konkretnym formacie, np.:
```
date +%d%m%y-%H%M%S
```

Powyższy przykład może być użtyt do np. tworzenia nazwy pliku zawierającego czasowy znacznik:
```
touch logfile-`date +%d%m%y-%H%M%S`.log
```

Aby sprawdzić aktualny czas hardware'owy:
```
hwclock
```

Synchronizacja czasu systemowego z hardware'owym:
```
hwclock -s
```

Synchronizacja czasu hardware'owego z systemowym:
```
hwclock -w
```

Główna komenda do zarzadzania czasem i strefami czasowanymi na Linuxie to **timedatectl**:
```
timedatectl
```

Manualne ustawienie czasu i daty:
```
timedatectl set-time 2020-18-03
timedatectl set-time 10:26:00
```

Ustawienie strefy czasowej:
```
timedatectl set-timezone Australia/Melbourne
```

Wylistowanie wszystkich stref czasowych:
```
timedatectl list-timezones
```

Użycie Network Time Protocol (NTP) przez timedatectl:
```
timedatectl set-ntp yes
```

Demon NTP (ntpd) nie jest już wspierany przez RHEL8 i trzeba użyć **chrony**. Aby zainstalować:
```
dnf install chronyd
```

Wystartowanie usługi i właczenie przy bootowaniu:
```
systemctl start chronyd
systemctl enable chronyd
```

Aby ustawić listę serwerów NTP należy wyedytować plik chrony.conf i dodać linijki zaczynające się 'server <IP adres>' i zrestartować usługę chronyd:
```
vi /etc/chrony.conf
systemctl restart chronyd
```

Aby wylistować listę serwerów używanych przez chronyd:
```
chronyc sources
```

## Install and update software packages from Red Hat Network a remote repository or from the local file system 

DNF jest nowym narzędziem które w dystrybucji 8 zastąpiło YUMa, aczkolwiek komendy yum nadal działają.

Aby wyzukać pakiet:
```
dnf search nano
dnf list na*
```

Aby wylistować włączone i wyłączone repozytoria:
```
dnf repolist all
dnf repoinfo
```

Wyświetlenie szczegółowych informacji na temat konkretnego pakietu:
```
dnf info nano
```
 
Instalowanie pakietu: 
```
dnf install nano
```

Usuwanie pakietu:
```
dnf remove nano
```

Sprawdzenie który pakiet dostarcza konkretny plik:
```
dnf provides "*/bin/nano"
```

Instalowanie lokalnego pakietu:
```
dnf localinstall rpm
```

Wylistowanie wszystkich dostępnych grup pakietów: 
```
dnf groups list
```

Instalowanie grupy pakietów:
```
dnf group install "System Tools" 
```

Usuwanie grupy pakietów:
```
dnf group remove "System Tools" 
```

Wylistowanie wszystkich aktywności dnf'a:
```
dnf history list 
```

Cofanie konkretnej operacji z historii (wstecz):
```
dnf history undo 4
```

Powtózenie konkretnej operacji z historii (w przód):
```
dnf history redo 4 
```

Aby dodać nowe repozytorium w systemie z miminalną konfiguracją potrzeba stworzyć nowy plik w katalogu /etc/yum.repos.d/ z rozszerzeniem `.repo`:
```
[repository]
name=repository_name
baseurl=repository_url
```
Należy zamienić repository_url z URL'em do katalogu, gdzie znajduje się repodata: 
* W przypadku repozytoriów HTTP: http://path/to/repo​ 
* W przypadku repozytoriów FTP: ftp://path/to/repo 
* W przypadku repozytoriów lokalnych: file:///path/to/local/repo 

DNS pozwala na dodawanie repozytoriów, yum-config-manager który jest dostarczany jako część dnf-utils. Aby zaisntalować:
```
dnf install dnf-utils
```

Aby dodać istniejące repozytorium na systemie:
```
yum-config-manager --add-repo repository_url
```

Aby wyłączyć repozytorium:
```
yum-config-manager --disablerepo repository
```

Aby włączyć repozytorium:
```
yum-config-manager --enablerepo repository
```

### Tworzenie swojego lokalnego repozytorium 
1. Aby stworzyć lokalne repozytorium wymagany jest pakiet createrepo, instalacja:
```
dnf install createrepo
```

2. Skopiowanie wszystkich pakietów które mają się znajdować w repozytorium do jednego katalogu, np. /root/local_repo.

3. Przejdź do katalogu gdzie są wszystkie pakiety i uruchom: 
```
createrepo --database /root/local_repo
```

Dodanie lokalnego repozytorium do dnf'a:
```
yum-config-manager --add-repo file:///root/local_repo/
```

## Work with package module streams

Moduły pozwalają na instalację specyficznych versji aplikacji, dobrym przykładem możebe tu być aplikacja PHP. PHP jest dostępny w module stream z różnymi różnorodnymi wersjami i edycjami. Moduły pozwalają wybrać i zainstalować konkretną werję którą chcemy lub która jest wymagana. 

Aby wylistować aktualnie dostępny moduły:
```
dnf module list 
```

Wylistowanie informacji na temat specyficznego modułu:
```
dnf module info –profile php
```

Instalacja modułu:
```
dnf module install php
```

Usuwanie modułu: 
```
dnf module remove php
```

Resetowanie modułu po usunięciu (wymagane w przypadku instalacji innej wersji niż ta co była zaisntalowana): 
```
dnf module reset php 
```

Instalowanie specyficznej wersji i edycji modułu:
```
dnf module install php:7.3/minimal
```

## Modify the system bootloader

**Note:** Jako część egzaminu możesz być poproszony o tylko niewielkie modyfikacje konfiguracji gruba.

Aby wylistować opcje do modyfikacji środowiska grub: 
```
grub2-editenv list
```
Dobrym przykładem jest np. ustawienie obecnej wersji kernela jako defaultowej dla bootowania:
```
grub2-set-default 0
```

Przeglądanie i edycja konfiguracji grub:
```
vi /etc/default/grub
```

Prosta zmienna w grubie, którą można dodać to parametr `GRUB_TIMEOUT_STYLE=countdown`

Można dodać linijkę z powyższym parametrem. To spowoduje że ekran GRUB  będzie pokazywał tylko prosty licznik w dół a nie całościowy bootscreen.

Aplikacja konfiguracji:
```
grub2-mkconfig -o /boot/grub2/grub.cfg
```
