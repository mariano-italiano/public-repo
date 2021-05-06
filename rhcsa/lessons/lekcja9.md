# RHCSA - Lekcja 9

Zamieszczam materiały i komendy (polecenia) które były użyte podczas zajęć.

[Find and retrieve container images from a remote registry](#Find-and-retrieve-container-images-from-a-remote-registry)</br>
[Inspect container images](#Inspect-container-images)</br>
[Perform basic container management such as running starting stopping and listing running containers](#Perform-basic-container-management-such-as-running-starting-stopping-and-listing-running-containers)</br>
[Run a service inside a container](#Run-a-service-inside-a-container)</br>
[Configure a container to start automatically as a systemd service](#Configure-a-container-to-start-automatically-as-a-systemd-service)</br>
[Attach persistent storage to a container](#Attach-persistent-storage-to-a-container)</br>

## Find and retrieve container images from a remote registry

### Podman

Instalowanie podmana:
```
dnf install podman
```

Wyszukiwanie obrazów kontenerów:
```
podman search httpd
```

Ściągnięcie image'u:
```
podman pull docker.io/library/httpd
```

Wylstowanie lokalnych imageów:
```
podman images
```

## Inspect container images

### Podman

Sprawdzenie image'y lokalnych:
```
podman inspect docker.io/library/httpd
```

### Skopeo

Instalacja skopeo:
```
dnf install skopeo
```

Sprawdzenie image'y zdalnych (remote) za pomocą skopeo:
```
skopeo inspect docker://registry.fedoraproject.org/fedora:latest
```

## Perform basic container management such as running, starting, stopping, and listing running containers

Wystartowanie kontenera:
```
podman run docker.io/library/httpd
```

Wystartowanie kontenera w detacted mode (d) z terminalem(t) i z opcją na port forwarding (p):
```
podman run -dt -p 8080:80/tcp docker.io/library/httpd
```

Wylistowanie kontenerów, które działają na systemie:
```
podman ps
```

Wylistowanie wszystkich kontenerów które działają i nie są aktywne na systemie:
```
podman ps -a
```

Wylistowanie logów z danego kontenera:
```
podman logs ..container-id..
```

Wylistowanie procesów w danym kontenerze:
```
podman top ..container-id..
```

Stopowanie kontenera:
```
podman stop ..container-id..
```

Startowanie kontenera:
```
podman start ..container-id..
```

Usunięcie kontenera:
```
podman remove ..container-id..
```

## Run a service inside a container

Używając Dockerfile (umożliwia to dodanie doadtkowej aplikacji/plików do naszego obrazu kontenera):
```
vim Dockerfile
```
Plik powinien wyglądać następująco: 
```
FROM registry.access.redhat.com/ubi8/ubi-init
RUN yum -y install httpd; yum clean all; systemctl enable httpd;
RUN echo "Successful Web Server Test" redirect-to /var/www/html/index.html
RUN mkdir /etc/systemd/system/httpd.service.d/; echo -e '[Service]\nRestart=always' redirect-to /etc/systemd/system/httpd.service.d/httpd.conf
EXPOSE 80
```
Następnie aby zbudować image kontenera:
```
podman build -t <imageName> .
```

Uruchomienie kontenera:
```
podman run -d --name=<kontenerName> -p 80:80 <imageName>
```
Sprawdzenie statusu:
```
podman ps
```


## Configure a container to start automatically as a systemd service

Na początku musimy włączyć boolean dla selinuxa aby zezwolić na wykonanie kontenera przez systemd:
```
setsebool -P container_manage_cgroup on
```

Następnie musimy uruchomić kontener aby nadać mu nazwę:
```
podman run -d --name httpd-server -p 8080:80 httpd
```

Nasyępnie musimy stworzyć definicję service'u dla systemd aby być zdolnym do zarządzania kontenerem (start/stop/enable/disable):
```
vim /etc/systemd/system/httpd-container.service
```

Plik powinien wyglądać tak:
```
[Unit]
Description=httpd Container Service
Wants=syslog.service

[Service]
Restart=always
ExecStart=/usr/bin/podman start -a httpd-server
ExecStop=/usr/bin/podman stop -t 2 httpd-server

[Install]
WantedBy=multi-user.target
```

Teraz możemy używać standardowej komendy systemctl do zarządzania (start/stop/enable/disable) serwisem:
```
systemctl start httpd-container.service
systemctl status httpd-container.service
systemctl enable httpd-container.service
```

## Attach persistent storage to a container

Tworzenie folderu, gdzie kontener będzie zamontowany:
```
mkdir /home/student/containers/disk1
```

Uruchomienie konteneru z opcją 'priviledge' i z opcją zamontowania na konkretny zasób (dodatkowo z -it i /bin/bash aby udostępnić terminal połączeniowy):
```
podman run --privileged -it -v /home/cengland/containers/disk1:/mnt httpd-server /bin/bash
```

Potwierdzenie zamontowania:
```
df -h
```
