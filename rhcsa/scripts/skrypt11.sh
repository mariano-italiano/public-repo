#!/bin/bash

#	pętla while i until x=1;

#	jesli warunek jest prawdziwy to wykonywane jest polecenie while [ $x -ne 10 ]
do

echo "x jest równe $x"; x=$[x+1];

done

y=1;

#	jesli warunek nie jest prawdziwy to wykonywane jest polecenie until [ $y -eq 10 ]

do

echo "y jest rowne $y"; y=$[y+1];
done
