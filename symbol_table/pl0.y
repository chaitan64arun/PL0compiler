%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "plGlobal.h"

int block_num = 0;
int listCreator(char* identifier,int, int);
int yylex(void);
int yyerror(const char *s);
int valueChecker( long int value);
symbolTable *head = NULL;
symbolTable *presentNode = NULL;
%}

%token <stringVal> IDENT JUNK
%token <intVal> number
%token START 
%token CALL CONST DO END IF ODD PROCEDURE THEN VAR WHILE 
%token DOT PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN NOTEQUAL EQUAL COMMA LESSEQL ASSIGN
%token LESSTHAN GTTHAN GTEQL SEMICOLON 
%start Program

%%


Program:

       block DOT {}                     
       block error DOT {printf("--error found : skipping everthing till DOT in line %d\n",@1.first_line); }
;

block:
       
       CONST const_latter {}
       
       | block_var {}
;

block_var:

       VAR VAR_IDENT var_latter {} 

       | block_procedure {}
;

block_procedure:       
 
       PROCEDURE PROC_IDENT SEMICOLON block SEMICOLON block {  
       }
       
       | statement {}         
;

PROC_IDENT:
         IDENT 
         {           block_num++;
                     listCreator($1,block_num,2);
         } 
   ;     
       
const_latter:

    	 ASSIGNMENT SEMICOLON block_var {}
	
	    | ASSIGNMENT COMMA const_latter {}	 
	     
      | ASSIGNMENT error COMMA const_latter{printf("--error found : skipping everthing till comma in line %d\n",@1.first_line); }
      
      | ASSIGNMENT error SEMICOLON block_var {printf("--error found : skipping everthing till semicolon in line %d\n",@1.first_line); }
     
      | error COMMA const_latter { printf("--error found : skipping everything after const till comma in line %d\n",@1.first_line); }
      
      | error SEMICOLON block_var { printf("--error found : skipping everything after const till comma in line %d\n",@1.first_line); }
;

ASSIGNMENT:
          
          IDENT EQUAL number { char * temp = strtok($1," =");
                if (listCreator(temp,block_num,0)) 
                if (!valueChecker($3)) { printf("--error found : number out of bound in line %d\n",@1.first_line);}  }
          
          | IDENT EQUAL IDENT { printf("--error found : = succeeded by IDENT in line %d\n",@1.first_line);}
           
          | IDENT OTHERSYMBOL number { printf("--error found : expecting 'equalto' in line %d\n",@1.first_line);}
          
          | IDENT OTHERSYMBOL IDENT { printf("--error found : expecting 'equalto' in line %d\n",@1.first_line);}
          
            
;   

OTHERSYMBOL:
          
          PLUS {}
          | MINUS {} 
          | MULTIPLY {}
          | DIVIDE {}
          | LPAREN {}
          | RPAREN {}
          | NOTEQUAL {} 
          | COMMA {}
          | LESSEQL {}
          | ASSIGN {}
          | LESSTHAN {}
          | GTTHAN {}
          | GTEQL {}
          | SEMICOLON {}
          | JUNK {}
          |
;

var_latter:
        
        COMMA VAR_IDENT var_latter {}

        | SEMICOLON block_procedure {}
        
        | error COMMA VAR_IDENT var_latter { printf("--error found : skipping everything till comma in line %d\n",@1.first_line);}
        
        | error SEMICOLON block_procedure { printf("--error found : skipping everything till semicolon in line %d\n",@1.first_line);}
; 
VAR_IDENT:
         IDENT 
         { 
                char* temp = strtok($1,";");
                temp = strtok(temp,",");
                listCreator(temp,block_num,1);
         }
 ;        
statement:
       
          IDENT ASSIGN expression {}
        
         | IDENT EQUAL expression { printf("--error found : USE OF '=' operator instead of ':=' in line %d\n",@1.first_line);
                                  }          

         | CALL IDENT {}

         | START statement statement_latter END {}  
         
          
         | START statement statement_latter error END{ 
                              printf(" Error Found : END or SEMICOLON missing in line %d\n",@1.first_line); }  
         
         | IF condition THEN statement {}
        
         | IF condition statement { printf("Error Found : THEN missing in line %d\n",@1.first_line); }
         
         | WHILE condition DO statement {}
         
         | WHILE condition statement { printf("Error found : DO missing in line %d\n",@1.first_line); }
         
         | {}
;          

condition:

         ODD expression {}

         | expression expression_latter {}
;

statement_latter:
        
         SEMICOLON statement statement_latter {}
         | {}
;

expression:

      	 PLUS term term_latter {}

         | term term_latter {}

         | MINUS term term_latter {} 
;

expression_latter:
    
        EQUAL expression {}

         | NOTEQUAL expression {}

         | LESSTHAN expression {}
          
         | GTTHAN  expression {}
        
         | GTEQL expression {}

         | LESSEQL expression {}  
         
         | error expression { printf("--error found : relational operator expected\n");}

;

	
term:
         factor factor_latter {}

; 

term_latter:

         PLUS term term_latter {}

       | MINUS term term_latter {}
	 
	     |  {}
	 
	 
;
factor:
        
        IDENT {}

        | number {}
        
        | LPAREN expression RPAREN {} 
        
        | LPAREN expression error {printf("--error found : missing right parenthesis in line %d\n",@1.first_line);} 

        | error RPAREN {printf("--error found : parenthesis mismatch in line %d\n",@1.first_line);} 
;

factor_latter:
            
        MULTIPLY factor factor_latter {}
        
        | DIVIDE factor factor_latter {}
        
        | {}
;	
%%

int yyerror(const char *s) {
  
}
int listCreator(char* identifier,int block_num, int type)
{
  symbolTable *node = (symbolTable*)malloc(sizeof(symbolTable));
  node->next = NULL;
  node->identifier = malloc(sizeof(identifier));
  node->block_num = block_num;
  node->type = type;
  strcpy(node->identifier, identifier);
  if(head == NULL) {
    presentNode = node;
    head = node;
    return 1;
    } else {
    presentNode->next = node;
    presentNode = node;
    return 1;
  }
  return 0;
}

int main(void) {
  head = NULL;
  presentNode = NULL;
  yyparse();
  symbolTable *node = (symbolTable*)malloc(sizeof(symbolTable));
  node = head;
  while( node != NULL ) {
      printf("ident :%s\t type:%d\t block:%d\n",node->identifier,node->type,node->block_num);
      if(node->next == NULL)
        break;
      
      node = node->next;
      
  }
   exit(0);
}

int listChecker(char* identifier,int block_num, int type)
{
  symbolTable *node = (symbolTable*)malloc(sizeof(symbolTable));
  node = head;
  while( node != NULL ) {
    if (!strcmp(node->identifier, identifier) && node->type == type){
      if( node->block_num == block_num  && type == 0)
        {return 1;}
      if( node->block_num == 0)
       return 1;
      if(type == 1)
        {return 1;}
    } else {
      if(node->next == NULL)
        break;
      }
      node = node->next;
      
  }
  return 0;
}
int valueChecker( long int value)
{
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

