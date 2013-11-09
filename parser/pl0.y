%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
%}

%token IDENT number
%token START 
%token CALL CONST DO END IF ODD PROCEDURE THEN VAR WHILE 
%token DOT PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN NOTEQUAL EQUAL COMMA LESSEQL ASSIGN
%token LESSTHAN GTTHAN GTEQL SEMICOLON 
%start Program

%%


Program:
       block DOT { printf("block DOT\n"); exit(0);}
	                          
      ;
block:
       
       CONST const_latter { printf("CONST const_latter\n");}
       
       | block_var {}
;

block_var:

       VAR IDENT var_latter { printf("VAR IDENT var_latter\n");}
      
       | block_procedure {}
;

block_procedure:       
 
       PROCEDURE IDENT SEMICOLON block SEMICOLON block { printf("PROCEDURE IDENT SEMICOLON block SEMICOLON block\n");}
       
       | statement {printf("statement \n");}         
;

const_latter:

	 IDENT EQUAL number SEMICOLON block_var { printf("IDENT EQUAL number SEMICOLON block_var\n");}
	
	| IDENT EQUAL number COMMA const_latter { printf("IDENT EQUAL number COMMA const_latter\n"); }	    
;

var_latter:
        
        COMMA IDENT var_latter { printf("COMMA IDENT var_latter\n");}
        
        | SEMICOLON block_procedure { printf("SEMICOLON block_procedure\n");}
; 


statement:
       
          IDENT ASSIGN expression { printf("IDENT ASSIGN expression\n");}
          
         | CALL IDENT { printf("CALL IDENT\n");}

         | START statement statement_latter END { printf("START statement statement_latter END\n"); }  
         
         | IF condition THEN statement { printf("IF condition THEN statement \n"); }
         
         | WHILE condition DO statement { printf("WHILE condition DO statement \n"); }
         
         | {}
;          

condition:

         ODD expression { printf("ODD expression \n");}

         | expression expression_latter { printf("expression expression_latter \n"); }
;

statement_latter:
         SEMICOLON statement statement_latter { printf("SEMICOLON statement statement_latter \n");}

         | {}
;

expression:

	 PLUS term term_latter { printf( "PLUS term term_latter\n"); }

         | term term_latter { printf("term term_latter\n"); }

         | MINUS term term_latter { printf("MINUS term term_latter\n"); } 
;

expression_latter:
         EQUAL expression { printf("EQUAL expression\n"); }

         | NOTEQUAL expression { printf("NOTEQUAL expression\n"); }

         | LESSTHAN expression { printf("LESSTHAN expression\n");}
          
         | GTTHAN  expression { printf("GTTHAN  expression\n"); }
        
         | GTEQL expression { printf("GTEQL expression  \n");}

         | LESSEQL expression { printf("LESSEQL expression \n");}  

;

	
term:
         factor factor_latter { printf("factor factor_latter\n"); }

; 

term_latter:

         PLUS term term_latter { printf("PLUS term term_latter\n");}

       | MINUS term term_latter { printf("MINUS term term_latter\n");}
	 
	 |{}
	 
	 
;
factor:
        
        IDENT { printf("IDENT\n"); }

        | number {printf("number\n");}
        
        | LPAREN expression RPAREN {printf("LPAREN expression RPAREN\n");} 

;

factor_latter:
            
        MULTIPLY factor factor_latter {printf("MULTIPLY factor factor_latter\n"); }

        | DIVIDE factor factor_latter {printf("DIVIDE factor factor_latter\n"); }
        
        | {}
;	
%%

int yyerror(char *s) {
  printf("Process Ended : %s\n",s);
}

int main(void) {
  yyparse();
}
