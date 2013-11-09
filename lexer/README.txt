Author: Miriappalli Arun Chaitanya
Roll No: CS08B024

***************************************************
		A lexer Program for PL/0 Language
***************************************************
pl0.lex is program which tokenizes the input into the specified tokens.

Required Programs to Execute the program
1. Flex ( Fast Lexer )
2. gcc ( GNU C Compiler )

Compile:
flex pl0.lex > pl0lexer.cc
gcc -o pl0lex_test plolexer.cc -ll

Execute:
./pl0lex_test 

( or )
./pl0lex_test > input file

EOF is ^D
