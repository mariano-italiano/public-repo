#!/bin/bash

#	zmienne i zmienne specjalne
###########################################################

#	zmienna
zmienna1=2;

zmienna2=3;
suma1=$[$zmienna1 + $zmienna2];

let suma2=zmienna1+zmienna2;
echo $suma1;

echo $suma2;
###########################################################

#	zmienne specjalne

#	nazwa biez±cego skryptu: $0 echo $0;

#	argumenty skryptu: $1 - $9 echo "argument 1: $1"; echo "argument 2: $2";
#	wszystkie argumenty: $@

echo "wszystkie argumenty: $@";
# kod powrotu ostatnio wydanego polecenia: $?

echo "kod powrotu ostatnio wydanego polecenia: $?";

#	generujemy błąd lssfsdfsdff 2> /dev/null
echo "Czy jest błąd (1)? : $?";

#	PID bież±cej powłoki: $$ echo "PID powłoki: $$";
