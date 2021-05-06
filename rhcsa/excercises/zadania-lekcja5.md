1. Utwórz katalog /home/projekt1 i /home/projekt2. Ustaw ACL do katalogów jak poniżej:
- /home/projekt1 – rwx dla student1 i 2 + takie same domyślne uprawnienia
- /home/projekt2 – rx dla student3 i 4 + takie same domyślne uprawnienia

2. Skonfiguruj nowe urządzenie blokowe VDO z politykką zapisu "sync" i nazwą "vdo-k-disk". Stwórz na tym urządzeniu filesystem XFS i zamontuj zasób na /home/vdo-disk. Nastepnie zmień politykę ompresji na auto.

3. Stwórz nowy dysk warstwowy za pomocą stratis z poolą o nazwie "str1". Skorzystaj z fizycznego dysku z poprzedniego zadania. Przygotuj odpowiednio dysk (wyczyść). Stwórz na niej filesystem o nazwie "file1". Następnie zamontuj dysk na /home/str-disk. Zapisz kilka przykładowych plików. Następnie wykonaj snapshot. Usuń wszystkie pliki i przywróć filesystem z snapshotu. Czy pliki są widoczne na filesystemie?

4. Poćwicz AutoFS (wymaga server + client).
