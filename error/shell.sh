#!/bin/sh
yacc -d pl0.y 
lex pl0.l
cc y.tab.c lex.yy.c -ll
./a.out < input.txt
