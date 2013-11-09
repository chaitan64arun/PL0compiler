%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "struct.h"
#include "myerror.h"


symbolTable iTable[TXMAX];
int slevel = 0;
int flevel = 0;
static int tx;
int enter(char* identifier,int ,int, int);
int yylex(void);
int yyerror(const char *s);
int valueChecker( long int value);
int level = 0;
%}

%token <stringVal> IDENT JUNK
%token <intVal> number
%token START 
%token CALL CONST DO END IF ODD PROCEDURE THEN VAR WHILE 
%token DOT PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN NOTEQUAL EQUAL COMMA LESSEQL ASSIGN
%token LESSTHAN GTTHAN GTEQL SEMICOLON 
%start Program

%%


Program:    block DOT                     
          | block error DOT                       {
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(9);
                                                  }
          ;
block:
       
        CONST const_latter 
       
       | block_var 
;

block_var:    VAR VAR_IDENT var_latter 

            | block_procedure
            ;

block_procedure:  
 
       PROCEDURE PROC_IDENT SEMICOLON block SEMICOLON block_procedure
      
      | PROCEDURE error SEMICOLON block SEMICOLON block_procedure 
                                                  {
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(4);
                                                  }
      
      | PROCEDURE PROC_IDENT error block SEMICOLON block_procedure
                                                  {
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(6);
                                                  }
      
      | PROCEDURE PROC_IDENT SEMICOLON block error
                                                  {
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(5);
                                                  }
       
      | statement
                                                  { 
                                                    
                                                  }         
      ;

          
PROC_IDENT:   IDENT                               {         
                                                    enter($1,level,-1,PROCEDUR);//printf("list successful\n");
                                                  } 
            ;     
       
const_latter:   ASSIGNMENT SEMICOLON block_var
	
	            | ASSIGNMENT COMMA const_latter
	     
              | ASSIGNMENT error COMMA const_latter { 
                                                      printf("In line %d ",@1.first_line); 
                                                      myerror(5);
                                                    }
      
              | ASSIGNMENT error SEMICOLON block_var {
                                                       printf("In line %d ",@1.first_line);
                                                       myerror(5);
                                                     }
     
              | error COMMA const_latter            { 
                                                      printf("In line %d ",@1.first_line);
                                                      myerror(4);
                                                    }
      
              | error SEMICOLON block_var           { 
                                                       printf("In line %d ",@1.first_line);
                                                       myerror(4);
                                                    }
              ;
              
ASSIGNMENT:   IDENT EQUAL number                    { 
                                                      char * temp = strtok($1," =");
                                                      enter(temp,-1,$3,CONSTANT); 
                                                      if (!valueChecker($3)) 
                                                      { 
                                                        printf("In line %d ",@1.first_line);
                                                        myerror(30);
                                                      }   
                                                    }
          
            | IDENT EQUAL IDENT                     {
                                                      printf("In line %d ",@1.first_line);
                                                      myerror(2);
                                                    }
           
            | IDENT OTHERSYMBOL number              { 
                                                      printf("In line %d ",@1.first_line);
                                                      myerror(3);
                                                    }
          
            | IDENT OTHERSYMBOL IDENT               { 
                                                      printf("In line %d ",@1.first_line);
                                                      myerror(3);  
                                                    }
                                                    
            | IDENT ASSIGN number                   {
                                                      printf("In line %d ",@1.first_line);
                                                      myerror(1);
                                                    }
            ;   

OTHERSYMBOL:  PLUS
            | MINUS 
            | MULTIPLY
            | DIVIDE
            | LPAREN
            | RPAREN
            | NOTEQUAL
            | COMMA
            | LESSEQL
            | LESSTHAN
            | GTTHAN
            | GTEQL
            | SEMICOLON
            | JUNK
            |
            ;

var_latter:   COMMA VAR_IDENT var_latter

            | SEMICOLON block_procedure
        
            | error COMMA VAR_IDENT var_latter    { 
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(5);
                                                  }
        
            | error SEMICOLON block_procedure     {
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(5);
                                                  }
            ;
            
VAR_IDENT:  IDENT                                 { 
                                                    char* temp = strtok($1,";");
                                                    temp = strtok(temp,",");
                                                    enter(temp,level,-1,VARIABLE); 
                                                  }
            ;
                    
statement:  STATE_IDENT ASSIGN expression         { } 
        
          | STATE_IDENT EQUAL expression          {
                                                    printf("--error found : USE OF '=' operator instead of ':=' in line %d\n",@1.first_line);
                                                  }          

          | CALL IDENT                            {
                                                    statement[slevel].i = position($2);
                                                    if (statement[slevel].i==0)
                                                    {
                                                      printf("In line %d %s-",@1.first_line,$2);
                                                      myerror(11);
                                                    }
                                                    else
                                                    {
                                                      if (iTable[statement[slevel].i].kind == PROCEDUR)
                                                      { }
                                                      else
                                                      {
                                                        printf("In line %d ",@1.first_line);
                                                        myerror(15);
                                                      }
                                                    }
                                                  }
                                                  
          | START statement statement_latter END
         
          
          | START statement statement_latter error 
                                                  { 
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(17); 
                                                  }  
         
          | IF condition THEN statement
                                                  { }
        
          | IF condition statement 
                                                  { 
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(16);
                                                  }
         
                                                    
          | WHILE condition DO statement 
                                                  {}
         
          | WHILE condition statement 
                                                  { 
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(18);
                                                  }
         
         | 
;

                  
STATE_IDENT:  IDENT                               {
                                                    char* temp = strtok($1," :=");
                                                    statement[slevel].i = position(temp);
                                                    if(!statement[slevel].i) 
                                                    {
                                                      printf("In line %d %s-",@1.first_line,$1);
                                                      myerror(11);
                                                    }
                                                    else 
                                                    {
                                                      if (iTable[statement[slevel].i].kind != VARIABLE)
                                                      {
                                                        printf("In line %d ",@1.first_line);
                                                        myerror(12);
                                                       
                                                      }
                                                    }
                                                  }
          ;
          
condition:  ODD expression                        {
                                                   }

          | expression expression_latter
          ;

statement_latter:
       
           SEMICOLON statement statement_latter 

          |
          ;

expression:   PLUS term term_latter

            | term term_latter       
            
            | MINUS term term_latter
            ;
 

expression_latter:  
            EQUAL expression                      

          | NOTEQUAL expression                  
          | LESSTHAN expression                   
          
          | GTTHAN  expression                    
        
          | GTEQL expression                      

          | LESSEQL expression                      
         
          | error expression                      { 
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(20);
                                                  }
          ;

term:
          factor  factor_latter
          ; 

term_latter:  PLUS term term_latter

            | MINUS term term_latter
	 
	          |  {}
            ;
            
factor:   IDENT                                   {
                                                    factor_i[flevel] = position($1);
                                                    if(!factor_i[flevel])
                                                    {
                                                      printf("In line %d %s-",@1.first_line,$1);
                                                      myerror(11);
                                                    }
                                                    else
                                                    {
                                                      if(iTable[factor_i[flevel]].kind == CONSTANT)
                                                      {}
                                                      else if(iTable[factor_i[flevel]].kind == VARIABLE)
                                                      {}
                                                      else if(iTable[factor_i[flevel]].kind == PROCEDUR)
                                                      {
                                                        myerror(21);
                                                      }
                                                      else {}
                                                    } 
                                                  }           

          | number                                {
                                                    int num = $1;
                                                    if ($1 > AMAX)
                                                    {
                                                      myerror(30);
                                                      num = 0;
                                                    }
                                                   
                                                  }
        
          | LPAREN expression RPAREN              
        
          | LPAREN expression error               {
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(22);
                                                  } 

          | error RPAREN                          {
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(22);
                                                  } 
          ;

            
factor_latter:           
          MULTIPLY factor factor_latter 

        | DIVIDE factor factor_latter
               
        | 
        ;
 
%%

int yyerror(const char *s) {
  //liprintf( "%s around line no %d\n",s, yylloc.first_line);
}

int enter(char* identifier, int level, int val, int type) {
  
  if(tx > TXMAX) return 0;
  tx++;
  
  strcpy(iTable[tx].name, identifier);
  iTable[tx].kind = type;
  
  if (type == CONSTANT) 
  {
    if (val > AMAX)
    {
      myerror(30);
      val = 0;
    }
    else
    {
      iTable[tx].val = val;
      iTable[tx].level = -1;
    }
  } 
  else if (type == VARIABLE)
  {
    iTable[tx].val = -1;
    iTable[tx].level = level;
    iTable[tx].adr = block[level].dx;
    block[level].dx++;
  } else
  {
    iTable[tx].val = -1;
    iTable[tx].level = level;
  }
  return 1;
}


int main(void) {
   
  yyparse();
 
  
  exit(0);
}

int position(char* identifier) {
  int i;
  strcpy(iTable[0].name,identifier);
 
  i = tx;
  while (strcmp(iTable[i].name,identifier) )
  {
    i--;
  }
    
  return i;
}

int valueChecker(long int value) {
  int count = 1;
  while( value)
  {
    count++;
    value = value/10;
  }
  if(count <= 14)
  {
    return 1;
  }
  else return 0;
}
