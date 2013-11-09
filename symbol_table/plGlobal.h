#ifndef PLGLOBAL_H
#define PLGLOBAL_H
#define YYSTYPE_IS_DECLARED 1
typedef union
{
  long int intVal;
  char* stringVal;
}YYSTYPE;
extern YYSTYPE yylval;
typedef struct symbol_table symbolTable;
struct symbol_table
{
  int block_num;
  char* identifier;
  int type;//type = 0 => variable ; type = 1 => function
  symbolTable *next;
};


#endif
