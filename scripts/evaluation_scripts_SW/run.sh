#!/bin/bash
word="2d13pt 2d49pt 3d19pt 3d343pt"

for i in $word;do echo $i start `date` > time.txt && cd $i && python3 run_on_sunway.py && echo $i end `date` >> time.txt && cd ..;done
