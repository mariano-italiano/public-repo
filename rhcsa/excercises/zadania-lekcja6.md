1. Napisz skrypt, który będzie zapisywał aktualną datę i godzinę do pliku "/tmp/skrypt.cron.log". Zaplanuj wywołanie tego skryptu co 10 minut w poniedziałki i czwartki. 

2. Zaplanuj wyłączenie serwera za pomocą 'at' za 3 minuty.

3. Skonfiguruj usłgę NTP tak, aby synchronizowała czas i korzystała z serwerów:
- 0.pl.pool.ntp.org
- 1.pl.pool.ntp.org

4. Skonfiguruj repo lokalne na serwerze i ustaw aby serwer sam z niego korzystał. Pakiety mają się znajdować w /home/local-repo. Wykorzystaj narzędzie 'dnf' i pakiet 'createrepo'. Na koniec zainstaluj dowolny pakiet z repozytorium aby sprawdzić czy działa.
