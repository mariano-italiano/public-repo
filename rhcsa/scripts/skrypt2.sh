#!/bin/bash
clear

#	to jest komentarz echo "tekst1";

echo "tekst 2 ....."; zmienna1="zmienna tekst";

echo Zmienna1 to ciag znakow: $zmienna1; zmienna2=3;

echo Zmienna2 to liczba = $zmienna2; zmienna3="plik.utworzony.przez.skrypt"; touch $zmienna3;

date >> $zmienna3; echo "Napisz cos:"; read zmienna4;

echo Wpisales: $zmienna4; echo $zmienna4 >> $zmienna3;
