#ifndef PLGLOBAL_H
#define PLGLOBAL_H
#define YYSTYPE_IS_DECLARED 1

#define AMAX 2047 //max address size

typedef union
{
  long int intVal;
  char* stringVal;
}YYSTYPE;
extern YYSTYPE yylval;

#endif
