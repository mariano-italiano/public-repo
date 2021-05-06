1. Dodaj nowy dysk do maszyny wirtualnej/serwera. Sprawdź czy jest on widoczny w systemie. 
2. Za pomocą narzędzia fdisk załóż partycje:
- 1 podstawową o rozmiarze 200 MB, typ Linux
- 2 podstawową o rozmiarze 100 MB, typ Linux Swap
3. Utworzyć system plików ext3 na nowo utworzonej partycji i zamontowąc jako /user1. W opcjach montowania użyć UUID.
4. Utworzyć przestrzeń wymiany na drugiej nowo utworzonej partycji, dodać montowanie permanentne przy bootowaniu systemu za pomocą label.
5. Deaktywować partycję swap i  usunąć wpisy z pliku /etc/fstab.
6. Założyć wolmen fizyczny 200 MB, grupę wolumenową: VGUser, wolumen logiczny: LVUser.
7. Zamontować powyższy LVM jako /newhome, a następnie zwiększyć rozmiar do 250 MB. Sprawdzić czy miejsca jest więcej. 
