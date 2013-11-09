#ifndef PLGLOBAL_H
#define PLGLOBAL_H
#define YYSTYPE_IS_DECLARED 1

#define TXMAX 300 //length of identifier table
#define AL 10 //length of identifiers
#define nmax 14 //max number of digits in numbers
#define LEVMAX 3 //max depth of block nesting
#define CXMAX 200 //size of code array
#define AMAX 2047 //max address size
#define ILEN 5
typedef union
{
  long int intVal;
  char* stringVal;
}YYSTYPE;
extern YYSTYPE yylval;

typedef struct symbol_table symbolTable;
struct symbol_table
{
  char name[AL];
  int val;
  int kind; //type = 0,1 => variable ; type = 2 => function
  int adr;  
  int level;
};
typedef struct
{
  char f[ILEN];//function code
  int l;//level
  int a; //displacement address
} mycode;

mycode code[TXMAX];
 
#define CONSTANT 0
#define VARIABLE 1
#define PROCEDUR 2

#endif
