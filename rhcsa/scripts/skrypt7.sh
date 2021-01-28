#!/bin/bash

#	instrukcja warunkowa if

#	sprawdzanie warunków: man test if [ -e plik1 ]
then

echo "plik1 istnieje"; else

echo "plik1 nie istnieje";
fi

if [ -e plik1 ]

then
echo "plik1 istnieje";

elif [ -e plik2 ]

then
echo "plik2 istnieje, a plik1 nie";

else
echo "zaden plik nie istnieje";

fi
