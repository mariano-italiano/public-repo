#!/bin/bash

clear
# cytowanie
echo "to jest katalog domowy: $HOME";
# znak maskuj±cy \

echo "to jest przyklad dziłania znaku maskuj±cego: \$HOME";

#	łańcuch tekstowy - brak interpretacji znaków specjalnych echo '$HOME';

#	odwrotny apostrof - np. cytowanie polecenia zmienna=`echo "jestes w: "; pwd`;

echo $zmienna; # wyswietlenie wyniku polecenia
#	zapis skrócony tego co powyżej

echo $(echo "jestes w: "; pwd);
