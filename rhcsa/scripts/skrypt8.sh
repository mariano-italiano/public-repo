#!/bin/bash
#	instrukcja case - przydatne np. podczas wykonywania skryptów

#	z parametrami
case "$1" in

"--nowy-plik") {
echo "Utworzono plik: $2";

touch $2;

};;
"--usun-plik") {

echo "Usunięto plik: $2";
rm -f $2;

};;
*) echo "Użycie: $0 <opcja> nazwa_pliku";
esac
