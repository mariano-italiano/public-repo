# RHCSA - Lekcja 3

Zamieszczam materiały i komendy (polecenia) które były użyte podczas zajęć.

[Boot, reboot, and shut down a system normally](#Boot,-reboot,-and-shut-down-a-system-normally)<br />
[Boot systems into different targets manually](#Boot-systems-into-different-targets-manually)<br />
[Interrupt the boot process in order to gain access to a system](#Interrupt-the-boot-process-in-order-to-gain-access-to-a-system)<br />
[Identify CPU/memory intensive processes and kill processes](#Identify-CPU/memory-intensive-processes-and-kill-processes)<br />
[Adjust process scheduling](#Adjust-process-scheduling)<br />
[Manage tuning profiles](#Manage-tuning-profiles)<br />
[Locate and interpret system log files and journals](#Locate-and-interpret-system-log-files-and-journals)<br />
[Preserve system journals](#Preserve-system-journals)<br />
[Start, stop, and check the status of network services](#Start-stop-and-check-the-status-of-network-services)<br />
[Securely transfer files between systems](#Securely-transfer-files-between-systems)<br />

## Boot, reboot, and shut down a system normally
**Rebootowanie systemu**
```
shutdown -r now     <- reboot teraz
shutdown +1         <- z opóźnieniem 1 minuty
reboot
systemctl reboot
init 6
telinit 6
```
**Wyłączenie systemu**
```
shutdown -h now        < shutdown teraz
halt
systemctl halt
init 0
telinit 0
```
Comparison of Power Management Commands with systemctl**

| Old Command       	| New Command            	| Description                         	|
|-------------------	|------------------------	|-------------------------------------	|
| halt              	| systemctl halt         	| Halts the system.                   	|
| poweroff          	| systemctl poweroff     	| Powers off the system.              	|
| reboot            	| systemctl reboot       	| Restarts the system.                	|
| pm-suspend        	| systemctl suspend      	| Suspends the system.                	|
| pm-hibernate      	| systemctl hibernate    	| Hibernates the system.              	|
| pm-suspend-hybrid 	| systemctl hybrid-sleep 	| Hibernates and suspends the system. 	|

## Boot systems into different targets manually

Wylistowanie targetów na systemie:
```
ls -l /lib/systemd/system/runlevel*.target
```
Można też uzyskać te same informacje poprzez poniższe komendy:
```
systemctl list-units --type target
or
systemctl list-units --type target --all
```
Graficzny interfejs:
`graphical.target`

Niegraficzny multi user interfejs:
`multi-user.target`

|Runlevel	|Target Unit	|Target Unit Description|
|---|---|---|
|0	|runlevel0.target or poweroff.target	|Changing your system to runlevel 0 will shutdown the system and power off your server/desktop|
|1	|runlevel1.target or rescue.target	    |Also known as single mode the rescue runlevel is use for system troubleshooting and various system administration tasks|
|2	|runlevel2.target or multi-user.target	|User defined runlevel. By default, identical to runlevel 3|
|3	|runlevel3.target or multi-user.target	|This is a multi-user and non-graphical runlevel. Multiple users can log in via local consoles/terminals or remote network access|
|4	|runlevel4.target or multi-user.target	|User defined runlevel. By default, identical to runlevel 3|
|5	|runlevel5.target or graphical.target	|Multi-user graphical runlevel. Multiple users can log in via local consoles/terminals or remote network access.
|6	|runlevel6.target or reboot.target	    |Changing your system to this runlevel will reboot your system|

Sprawdzenie defaultowego runlevelu:
```
systemctl get-default
```
Zmiana defaultowego runlevelu:
```
systemctl set-default multi-user.target
```

Manualnie zmiana runlevelu (tu i teraz):
```
systemctl isolate multi-user
```

**Note:**
Jeżeli login prompt nie jest widoczny, możliwa jest zmiana na inną konsolę TTY poprzez użycie kombinacji klawiszy CTRT+ALT+F1.


Zmiana runlevelu do single-user
```
systemctl rescue
systemctl isolate rescue.target
```

Przy zmianie do rescue mode informacja jest wysyłana do wszystkich zalogowanych userów na konsole. 
Aby temu zapobiec można wywołać komendę z parametrem `--no-wall`:

```
systemctl --no-wall rescue
```
**Emergency Mode**

Emergency mode dostarcza minimalne środowisko któe wystarcza na naprawę systemu nawet w sytuacji kiedy nie można dostać się do rescue mode. 
W emergency mode, system montuje tylko system plików roota tylko dla odczytu, network interfejsy nie są aktywne i tylko podstawowe serwisy są wystartowane
Eemergency mode wymaga hasła roota.

Zmiana runlevelu do emergency mode:

```
systemctl emergency
systemctl isolate emergency.target
```

## Interrupt the boot process in order to gain access to a system

Aby odzyskać lub zresetować hasło root należy dostać się do boot loadera oraz wyedytować konfigurację GRUB2.

**Resetowanie hasła roota**

1. Bootowanie systemu i zaczekania aż pojawi się menu GRUB2.
2. W menu boot loadera, podświetlić jakąkolwiek linijkę kodu i wcisnąć<kbd>e</kbd> aby wyedytować ją.
3. Znajdź linijkę zaycznającą się od **linux** i na końcu lini dopisać:
```
rd.break
rd.break enforcing=0
```
4. Zbootować sysytem używająć edytowanej linijki GRUB2 **Ctr+X**.
5. Przemontować partycję rootową w tryb rw:
```
mount –o remount,rw /sysroot
```
6. Uruchomić shella ze zmienionym katalogiem głównym:
```
chroot /sysroot/
```
7. Reset the root password:
```
passwd root
```
8. Wykonać autoetykietowanie SELinuxa:
```
touch .autorelabel
```
9. Wyjście i reboot systemu
```
exit
exit
```
## Identify CPU/memory intensive processes and kill processes

**Aktywności systemowe**

TOP:
```
top
* PID: Shows task’s unique process id.
* PR: Stands for priority of the task.
* SHR: Represents the amount of shared memory used by a task.
* VIRT: Total virtual memory used by the task.
* USER: User name of owner of task.
* %CPU: Represents the CPU usage.
* TIME+: CPU Time, the same as ‘TIME’, but reflecting more granularity through hundredths of a second.
* SHR: Represents the Shared Memory size (kb) used by a task.
* NI: Represents a Nice Value of task. A Negative nice value implies higher priority, and positive Nice value means lower priority.
* %MEM: Shows the Memory usage of task.
```
PS
```
ps -edf                        <- wyświetlenie detali procesów
ps -U root                     <- procesy uzytokwnika root
ps -U root -u root u           <- procesy realne i efektywne dla roota
```
PS + GREP = PGREP
```
pgrep httpd               <- filtrowanie procesów httpd
pgrep -u username -l      <- procesy roota
pgrep -v -u root -l       <- procesy które nie należą do roota
```

**Priorytety dla procesów**

Uruchomienie procesu z małym priorytetm:
```
nice -n 10 ./script.sh
```
Zmiana priorytetu na inny:
```
renice +5 <PID>
renice +5 `pgrep script.sh`
```

**Usuwanie procesów**
Typy sygnału KILL:
- SIGHUP 1 Hangup
- SIGKILL 9 Kill Signal
- SIGTERM 15 Terminate
**Note**: Domyślnie wysyłany jest sygnał 15 jeżeli nie został wyscpecyfikowany inny – SIGTERM.
```
kill -l           <- wylistowanie wszystkich typów
pidof auditd
or
ps -ef | grep auditd
kill <PID>        <- usunięcie procesu poprzez ID
kill -9 <PID>
pkill auditd      <- usunięcie procesu poprzez nazwę
```

**Performance**
```
iostat		<- aktywności IO
netstat	-i	<- aktywności karty sieciowej
netstat	-i	<- aktywności socketów
vmstat 5	<- aktywności odnośnie wirtualnej pamięci (co 5s)
sar -A		<- pełna analiza aktywności serwera
```

## Adjust process scheduling

### Zrozumienie Linux Scheduling Priorities
Ze strony man:
> The scheduler is the kernel part that decides which executable process will be executed by the CPU next. The Linux scheduler offers three different scheduling policies, one for normal processes and two for real-time applications.
> 
> 1. SCHED_OTHER – the default universal time-sharing scheduler policy used by most processes.
> 2. SCHED_FIFO or SCHED_RR – intended for special time-critical applications that need precise control over the way in which executable processes are selected for execution
> 3. SCHED_BATCH – intended for “batch” style execution of processes
> 
> Scheduling Algorithm:
> * SCHED_FIFO uses First In-First Out scheduling algorithm
> * SCHED_RR uses Round Robin scheduling algorithm
> * SCHED_OTHER uses Default Linux time-sharing scheduling algorithm
> * SCHED_BATCH use Scheduling batch processes algorithm
> 
> chrt:
> chrt command is part of util-linux package – low-level system utilities that are necessary for a Linux system to function. It is installed by default under Debian / Ubuntu / CentOS / RHEL / Fedora and almost all other Linux distributions.

Aby sprawdzić atrybuty real-time dla istniejącego już zadania / PIDu:
```
chrt -p pid
chrt -p 112
chrt -p 1
```
Każdy użytkownik może uzyskać informacje na temat schedulingu. Nie są wymagane specialne uprawnienia.

Jak używać komendy chrt aby ustawić atrybuty real time dla procesów w Linuxie?
Aby ustawić nowy priorytet używamy poniższych komend:
```
chrt -p prio pid
chrt -p 1025
chrt -p 55 1025
chrt -p 1025
```

Przed ustawianiem nowej scheduling policy, trzeba znaleźć minimalny i maksymalny poprawne priorytety dla każdego algorytmu schedulowania:
```
chrt -m
```

Aby ustawić scheduling policy na SCHED_BATCH:
```
chrt -b -p 0 {pid}
chrt -b -p 0 1024
```
Aby ustawić scheduling policy na SCHED_FIFO:
```
chrt -f -p [1..99] {pid}
```
Aby ustawić politykę na SCHED_FIFO z priorytetem 50:
```
chrt -f -p 50 1024
chrt -p 1024
```
Aby ustawić politykę scheduling policy na SCHED_OTHER:
```
chrt -o -p 0 {pid}
chrt -o -p 0 1024
chrt -p 1024
```
Aby ustawić scheduling policy na SCHED_RR:
```
chrt -r -p [1..99] {pid}
```
Aby ustawić politykę na SCHED_RR z priorytetem 20:
```
chrt -r -p 20 1024
chrt -p 1024
```

## Manage tuning profiles

Red Hat posiada wbudowany w OS performance tuning który nazywa się **tuned**. Demon tuned jest potężnym procesem który dynamicznie i w pełni automatycznie przeprowadza tuning systemu. Performance serwera Linux bazuje na informacjach, jakie zbierane są przez systemowy monitoring oraz komponenty, które skłądają się na cały system operacyjny aby dostarczyć end-userowi wymaganą charakterystykę 'performance'ową' jaką sobie zażyczy/zdefiniuje.

Aby zainstalować tuned:
```
dnf install tuned
```
Aby wystartować oraz uruchomić przy starcie
```
systemctl start tuned
systemctl enable tuned
```
Sprawdzenie statusu:
```
systemctl status tuned
```
Aby zarządzać demonem tuned używamy **tuned-adm**, aby sprawdzić aktualnie aktywny profil używany przez system:
```
tuned-adm active
```
Wylistowanie wszystkich dostępnych profili:
```
tuned-adm list
```
Więcej informacji na temat konkretnego profilu:
```
tuned-adm profile_info powersave
```
Aby zmienić aktualny profil na konkretny inny profil:
```
tuned-adm profile powersave
```
Potwierdzenie aktywności:
```
tuned-adm active
```
Aby zaaplikować rekomendowany profil na systemie:
```
tuned-adm recommend
```
Aby wyłaczyć tuning:
```
tuned-adm off
```


## Locate and interpret system log files and journals

### Informacje ogólne
Większość systemowych logów jest zlokalizowana w `/var/log`.

Logi SELinuxa  zapisywane są w pliku `/var/log/audit/audit.log`.

With Systemd, new commands have been created to analyse logs at boot time and later.

### Proces bootowania
Główny task systemd to zarządzanie bootowaniem i dostarczenie informacji o nim. Aby dostać informacje ile bootownaie trwa należy wykonać komendę:
```
systemd-analyze
Startup finished in 422ms (kernel) + 2.722s (initrd) + 9.674s (userspace) = 12.820s
```
Aby dostać informacje na temat ile czasu spędzono dla każdego procesu:
```
systemd-analyze blame
```

### Analiza Journala
Systemd również dba o event log systemu czyli dzienniki systemowe. Syslog nie jest już wymagany. Aby dostać informację na temat journala systemd należy wykonać komendę:
```
journalctl
```
Aby dostać listę eventów przynależnych do procesu crond w journala:
```
journalctl /sbin/crond
journalctl -u crond
```
**Note:** Można zamienić /sbin/crond na `which crond`.

Aby dostać listę wszystkich eventów od ostatniego bootowania:
```
# journalctl -b
```
Aby dostać listę wszystkich eventów, które pojawiły się dzisiaj:
```
# journalctl --since=today
```
Aby dostać listę wszystkich eventów z priorytetem sysloga jako err:
```
# journalctl -p err
```
Aby dostać 10 ostatnich eventów i czekać na kolejne (coś jak tail -f /var/log/messages):
```
# journalctl -f
```

Domyślnie logi Journald są trzymane w `/run/log/journal` ale znikają one po reboocie.
Aby permanentnie trzymać pliki logów Jourlnald należy to skonfigurować:
```
mkdir /var/log/journal
echo "SystemMaxUse=50M" >> /etc/systemd/journald.conf
systemctl restart systemd-journald 
```
**Note:** Ustawienie zmiennej SystemMaxUse jest wymagane ponieważ w innym przypadku 10% filesystemu gdzie trzymane są logi journala może być użyte maksymalnie przez Journald. 

## Preserve system journals

Podgląd journala systemowego: 
```
journalctl
```
Aby zdefiniować jounral permanentnym (reboot nie czyści wówczas journala):
```
mkdir /var/log/journal
```
Defaultowo journal może zająć aż do 10% całkowitej dostępnej przestrzeni dyskowej na tym mount poincie. 
Aby zarządzać maksymalną przestrzenią jaką może zająć ustawiamy wartość zmiennej "SystemMaxUse" na wartość odpowiednio w KB (K), MB (M) lub GB (G).

Aby zaktualizować wartość zmiennej:
```
echo "SystemMaxUse=50M" >> /etc/systemd/journald.conf
```

Zaaplikowanie zmiany poprzez restart usługi:
```
systemctl restart systemd-journald
```

## Start stop and check the status of network services

Aby wylistować wszystkie usługi:
```
systemctl list-units --type service --all
```
Aby wylistować które usługi są 'enabled':
```
systemctl list-unit-files --type service
```

Wylistowanie wszystkich serwisów które nie zostały poprawnie uruchomione:
```
systemctl list-units --failed
```
Wylistowanie wszystkich aktywnych serwisów:
```
systemctl list-units --type service --state=active
```

Aby wyświetlić szczegółowe informacje na temat konkretnego serwisu (httpd):
```
systemctl status httpd
systemctl status network.service
```
Aby sprawdzić czy serwis jest aktywny (active) lub nie (inactive):
```
systemctl is-active sshd
systemctl is-active network.service
```
Aby wylistować czy dana usługa jest 'enabled':
```
systemctl is-enabled sshd
systemctl is-active network.service
``` 
Aby uruchomić serwis:
``` 
systemctl start sshd.service
systemctl start network.service
```
Aby zatrzymać serwis:
```
systemctl stop sshd.service
systemctl stop network.service
```
Aby zrestartować serwis:
```
systemctl restart sshd.service
systemctl try-restart network.service
```

Aby skonfigurować serwis aby startował razem ze startem systemu automatycznie:
```
systemctl enable sshd.service
systemctl enable network.service
systemctl mask sshd
```
Aby skonfigurować serwis aby nie startował razem ze startem systemu:
```
systemctl disable sshd.service
systemctl disable network.service
systemctl unmask sshd
```
**Note:** Maskowanie serwisu zapobiega uruchamianiu serwisu nawet jeżeli jest socket-activated lub dbus-activated.

## Securely transfer files between systems

Aby przesłać lokalny plik do zdalnego hosta do katalogu domowego użytkownika user1:
```
scp file6 user1@10.0.2.6:file6
```
Aby przesłać wszystkie pliki z katalogu do innego katalogu (zdalnego) np. /tmp:
```
scp /etc/ssh/* root@10.0.2.6:/tmp
```
Aby przesłać pliki z zdalnego hosta do hosta lokalnego do katalogu np. /tmp:
```
scp root@10.0.2.6:/tmp/sshd_config /tmp/
```
