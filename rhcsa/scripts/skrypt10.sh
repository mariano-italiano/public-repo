#!/bin/bash

# pętla select
echo "Co wybierasz?";
select zmienna in a b c wyjscie
do

case $zmienna in

"a") echo "wybrałes a";;
"b") echo "wybrałes b";;

"c") echo "wybrałes c";;
"wyjscie") exit;;

*) echo "nic nie wybrałes";;
esac

break
done
