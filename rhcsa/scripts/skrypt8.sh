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

Skrypt8:

#!/bin/bash
# pętle for

for i in 1 2 3 4 5
do

echo $i;

done

for i in skrypt*
do

echo $i;
done
