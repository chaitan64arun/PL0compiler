%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "myerror.h"

#include "plGlobal.h"

int yylex(void);
int yyerror(const char *s);
int valueChecker( long int value);

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
          
block:    CONST const_latter 
       
        | block_var 
        ;

block_var:    VAR VAR_IDENT var_latter {}
            | block_procedure
            ;

block_procedure:  
 
       PROCEDURE IDENT SEMICOLON block SEMICOLON block_procedure
      
      | PROCEDURE error SEMICOLON block SEMICOLON block_procedure 
                                                  {
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(4);
                                                  }
      
      | PROCEDURE IDENT error block SEMICOLON block_procedure
                                                  {
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(6);
                                                  }
      
      | PROCEDURE IDENT SEMICOLON block error
                                                  {
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(5);
                                                  }
       
      | statement
          
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
            
VAR_IDENT:  IDENT                                 
            ;
                    
statement:  IDENT ASSIGN expression         
        
          | IDENT EQUAL expression          {
                                                    printf("--error found : USE OF '=' operator instead of ':=' in line %d\n",@1.first_line);
                                                  }          

          | CALL IDENT                            
                                                  
          | START statement statement_latter END
         
          
          | START statement statement_latter error 
                                                  { 
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(17); 
                                                  }  
         
          | IF condition THEN statement
        
          | IF condition statement 
                                                  { 
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(16);
                                                  }
         
          | WHILE condition DO statement 
         
          | WHILE condition statement
                                                  { 
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(18);
                                                  }
         
         | 
;

condition:  ODD expression                        

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

term:     factor factor_latter
          ; 

term_latter:  PLUS term term_latter

            | MINUS term term_latter
	 
	          |  {}
            ;
            
factor:   IDENT                                       

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

int yyerror(const char *s) {}

int main(void) {

  yyparse();

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
