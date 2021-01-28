#!/bin/bash

#	zmienne środowiskowe echo $HOME;

echo $USER; echo $HOSTNAME;

export set ZMIENNA_NOWA="nowa zmienna środowiskowa"; echo $ZMIENNA_NOWA;

#	zmienne tablicowe
tablica1=(1 2 3 4);

tablica2=(jeden dwa trzy);
echo ${tablica1[0]};

echo ${tablica2[2]};
unset tablica1[2];

echo ${tablica1[@]};

unset tablica2[@];
echo ${tablica2[@]};
