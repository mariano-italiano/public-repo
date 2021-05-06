# RHCSA - Lekcja 7

Zamieszczam materiały i komendy (polecenia) które były użyte podczas zajęć.

[Configure IPv4 and IPv6 addresses](#Configure-IPv4-and-IPv6-addresses)</br>
[Configure hostname resolution](#Configure-hostname-resolution)</br>
[Configure network services to start automatically at boot](#Configure-network-services-to-start-automatically-at-boot)</br>
[Restrict network access using firewall-cmd/firewall](#Restrict-network-access-using-firewall-cmd)</br>

## Configure IPv4 and IPv6 addresses

### Konfiguracja Adresu IPv4
Całą konfiguracja jest robiona poprzez **nmcli**.

Wylistowanie połaczeń:
```
nmcli connection show
```
Sprawdzenie statusu połączenia:
```
nmcli device status
```

Sprawdzenie aktualnej konfiguracji:
```
nmcli device show
```

Usunięcie urządzenia (nie robimy dla aktywnego urządzenia sieciowego!):
```
nmcli connection delete enp0s3
```

Dodanie nowego połączenia dla nowego urządzenia (enp0s8):
```
nmcli connection add con-name eth0 ifname enp0s8 type ethernet ip4 10.0.2.16/24 gw4 10.0.2.2
```

Sprawdzenie konfiguracji:
```
nmcli connection show
ip addr
nmcli device show enp0s8
```

Włączenie interfejsu:
```
nmcli connection up eth0
```

Wyłączenie interfejsu:
```
nmcli connection down eth0
```

Konfiguracja Adresu IP manualnie:
```
nmcli connection modify eth0 ipv4.address 10.0.2.15/24
nmcli connection modify eth0 ipv4.gateway 10.0.2.2
nmcli connection modify eth0 ipv4.method manual
```


### Konfiguracja Adresu IPv6 
Cała metodologia jest taka sama co konfigurowanie IPv4, jedyna zmiana jaka jest to tylko inna konfiguracja adresu IP.

Dodanie nowego połączenia dla nowego urządzenia (enp0s8):
```
nmcli connection add con-name eth0 ifname enp0s8 type ethernet ip6 2006:ac81::1105/64 gw6 2006:ac81::1101
```
Konfiguracja Adresu IP manualnie:
```
nmcli connection modify eth0 ipv6.addresses 2006:ac81::1105/64
nmcli connection modify eth0 ipv6.gateway 2006:ac81::1101
nmcli connection modify eth0 ipv6.method manual
```
## Configure hostname resolution

Wyświetlenie hostname w krótkim formacie:
```
hostname -s
```

Wyświetlenie hostname w długim formacie (FQDN):
```
hostname -f
```

Aby zmienić hostname należy wyedytować plik /etc/hostname:
```
vi /etc/hostname
```

Aby następnie zaktualizować hostname wykonaj:
```
hostnamectl
```

Aby zobaczyć aktualną konfigurację serwerów DNS na serwerze:
```
cat /etc/resolv.conf
```

Aby zaktualizować serwery DNS na konkretnym interfejsie:
```
nmcli con mod eth0 ipv4.dns "8.8.8.8 8.8.4.4"
```

Aby wymusiś zaczytanie nowej konfiguracji DNS wykonaj:
```
nmcli con reload
systemctl restart NetworkManager
```

Aby manualnie nadpisać to co jest skonfigurowane na serwerach DNS wyedytuj plik /etc/hosts (lokalny serwer DNS):
```
vi /etc/hosts
```

Przykładowy wpis:
```
172.28.18.3 RHEL8.local RHEL8
```

## Configure network services to start automatically at boot

Są dwa sposoby aby spełnić wymóg i zrealizować temat. 
1. Włączenie serwisu który używa network on boot, na przykład httpd (apache)

Instalacja httpd:
```
dnf install httpd
```
Włączenie przy bootowaniu:
```
systemctl enable httpd
```

Inny sposób to użycie serwisu Network Managera:
```
systemctl enable NetworkManager
```

2. Druga metoda to włączenie karty sieciowej lub połączenia przy bootowaniu:
```
nmcli connection modify eth0 connection.autoconnect yes
```

Powyższa komenda włącza połączenie przy starcie systemu, jeśli zdefiniujemy `connection.autoconnect no` wóczas interfejs bedzie wyłączony.

## Restrict network access using firewall-cmd

Lokalny firewall jest zarządzany przez komende **firewall-cmd*.

Wylistowanie wszystkich zones:
```
firewall-cmd --get-zones
```

Sprawdzenie co jest skonfigurowane na konkretnej zonie:
```
firewall-cmd --zone work --list-all
```

Tworzenie nowej zony:
```
firewall-cmd --new-zone servers
```

Nowo stworzona zona nie będzie permanentna, dobrą praktyką jest używanie ruli persystentnych i przełącznika `-–permanent`:
```
firewall-cmd --new-zone servers --permanent
```

Wszystkie zmiany dokonywane na firewallu nie są aplikowane, dopóki nie wykonamy reload:
```
firewall-cmd --reload
```

Przed przypisaniem network adaptera do konkretnej zony, powinniśmy najpierw dodać wszystkie wymagane usługi, które mają się w niej znajdować tak, aby nie zostać zblokowanym, dobra praktyka to dodanie przynajmniej SSH:
```
firewall-cmd --zone servers --add-service ssh --permanent
```

Zona jest gotowa aby przypisać do niej interfejs sieciowy:
```
firewall-cmd --change-interface eth0 --zone servers --permanent
```

Na koniec, jeżli konfiguracja nam odpowiada i chcemy aby była ona domyślną (używamy zawsze -–permanent aby była konsystenta po reboocie):
```
firewall-cmd --set-default servers
```

Aby wylistować zony przypisane do interfejsów sieciowych:
```
firewall-cmd --get-active-zones
```

Aby dodać kolejne usługi, można sprawdzić jakie są dostępne predefiniowane na firewallu usługi:
```
firewall-cmd --get-services
```

Jeśli chcemy dodać konkretny serwis/usługę:
```
firewall-cmd --add-service http --permanent
```

Usunięcie usługi:
```
firewall-cmd --remove-service http --permanent
```

Jeżeli chcemy dodać port/usługę która nie jest zdefiniowana na firewallu możemy oczywiście dodać tylko port jaki chcemy:
```
firewall-cmd --add-port 8080/tcp --permanent
```

Usunięcie portu:
```
firewall-cmd --remove-port 8080/tcp --permanent
```
