#!/bin/bash

# pętla select
echo "Co wybierasz?";
select zmienna in a b c wyjscie
do

case $zmienna in

"a") echo "wybrałe¶ a";;
"b") echo "wybrałe¶ b";;

"c") echo "wybrałe¶ c";;
"wyjscie") exit;;

*) echo "nic nie wybrałe¶";;
esac

break
done
