%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "struct.h"
#include "myerror.h"

int level = 0;//counts blocks
int enter(char* identifier,int ,int, int);//add to symbol table
int yylex(void);
int yyerror(const char *s);
int valueChecker( long int value);//checks if a number has more than 14 digits

symbolTable iTable[TXMAX];
int slevel = 0;//counts statements
int flevel = 0;
static int tx;//symbol table index register
static int cx;//code index
int i;
int flag = 0;//flags
int expression_patch = 0;
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
       
       const_start const_latter 
       
       | var_start block_var 
;
const_start:  CONST                               { //block started
                                                    block[level].dx = 3;
                                                    iTable[tx].adr = cx;
                                                    block[level].tx0 = tx;
                                                    gen("jmp",0,0);//forward referencing
                                                  }
          
;
var_start: 
                                                  { //block started
                                                    block[level].dx = 3;
                                                    iTable[tx].adr = cx;
                                                    block[level].tx0 = tx;
                                                    gen("jmp",0,0);//forward reference
                                                  }
        ;
          
block_start:                                      {
                                                    level++;
                                                  }
              ;

block_var:    VAR VAR_IDENT var_latter {}
            | block_procedure
            ;

block_procedure:  
 
       PROCEDURE PROC_IDENT SEMICOLON block_start block block_action SEMICOLON block_procedure
      
      | PROCEDURE error SEMICOLON block_start block block_action SEMICOLON block_procedure 
                                                  {
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(4);
                                                  }
      
      | PROCEDURE PROC_IDENT error block_start block block_action SEMICOLON block_procedure
                                                  {
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(6);
                                                  }
      
      | PROCEDURE PROC_IDENT SEMICOLON block_start block error
                                                  {
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(5);
                                                  }
       
      | state_action  pre_action statement post_action
                                                  { //in statement
                                                    gen("opr",0,0);
                                                  }         
      ;

state_action:                                     {//back patching
                                                    code[iTable[block[level].tx0].adr].a = cx;  
                                                    iTable[block[level].tx0].adr = cx;
                                                    block[level].cx0 = cx;
                                                    gen("int", 0 ,block[level].dx); 
                                                  }
            ;
  
block_action:                                     {
                                                    level--;
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
                    
statement:  STATE_IDENT ASSIGN expression         { //rvalue
                                                    if(statement[slevel].i) 
                                                    {
                                                      gen("sto",level - iTable[statement[slevel].i].level, iTable[statement[slevel].i].adr);
                                                    }
                                                  } 
        
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
                                                      {
                                                        gen("cal",level - iTable[statement[slevel].i].level, iTable[statement[slevel].i].adr);
                                                      }
                                                      else
                                                      {
                                                        printf("In line %d ",@1.first_line);
                                                        myerror(15);
                                                      }
                                                    }
                                                  }
                                                  
          | START pre_action statement post_action statement_latter END
         
          
          | START pre_action statement post_action statement_latter error 
                                                  { 
                                                    printf("In line %d ",@1.first_line);
                                                    myerror(17); 
                                                  }  
         
          | IF condition THEN then_action pre_action statement post_action
                                                  { //back patch
                                                    code[statement[slevel].cx1].a = cx; 
                                                  }
        
          | IF condition pre_action statement post_action
                                                  { 
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(16);
                                                  }
         
          | WHILE while_action condition condition_action DO pre_action statement post_action 
                                                  {//back patch
                                                    gen("jmp",0, statement[slevel].cx1);
                                                    code[statement[slevel].cx2].a = cx;  
                                                  }
         
          | WHILE while_action condition condition_action pre_action statement post_action
                                                  { 
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(18);
                                                  }
         
         | 
;

pre_action:                                       {
                                                    slevel++;
                                                  }
          ;
          
post_action:                                      {
                                                    slevel--;
                                                  }
          ;
          
while_action:                                     {
                                                    statement[slevel].cx1 = cx;
                                                  }           
          ;

condition_action:                                 {//forward reference
                                                    statement[slevel].cx2 = cx;
                                                    gen("jpc",0,0);
                                                  }
          ;
          
then_action:                                      {//forward reference
                                                    statement[slevel].cx1 = cx;
                                                    gen("jpc", 0, 0);
                                                  }
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
          
condition:  ODD expression                        {//odd condition
                                                    gen("opr",0,6); 
                                                  }

          | expression expression_latter
          ;

statement_latter:
       
           SEMICOLON pre_action statement post_action statement_latter 

          |
          ;

expression:   PLUS term plus_action term_latter

            | term term_action term_latter        { 
                                                    expression_patch = 0;
                                                  }

            | MINUS term minus_action term_latter
            ;
            
plus_action:                                      {
                                                    gen("opr",0,2);
                                                  }
            ;
            
term_action:                                      {
                                                    expression_patch = 1;
                                                  }
            ;
            
minus_action:                                     {
                                                    if(expression_patch == 0) 
                                                      gen("opr",0,1);//unary 
                                                    if(expression_patch == 1)
                                                      gen("opr",0,3); //binary
                                                  }
            ;

expression_latter:  
            EQUAL expression                      {
                                                    gen("opr",0,8);  
                                                  }

          | NOTEQUAL expression                   {
                                                    gen("opr",0,9);  
                                                  }

          | LESSTHAN expression                   {
                                                    gen("opr",0,10);
                                                  }
          
          | GTTHAN  expression                    {
                                                    gen("opr",0,12);
                                                  }
        
          | GTEQL expression                      {
                                                    gen("opr",0,11);
                                                  }

          | LESSEQL expression                    {
                                                    gen("opr",0,13);
                                                  }  
         
          | error expression                      { 
                                                    printf("In line %d ",@1.first_line); 
                                                    myerror(20);
                                                  }
          ;

term:
          fpre_action factor fpost_action factor_latter
          ; 

term_latter:  PLUS term plus_action term_latter

            | MINUS term minus_action term_latter
	 
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
                                                      {
                                                        gen("lit", 0, iTable[factor_i[flevel]].val);
                                                      }
                                                      else if(iTable[factor_i[flevel]].kind == VARIABLE)
                                                      {//lvalue
                                                        gen("lod", level - iTable[factor_i[flevel]].level, iTable[factor_i[flevel]].adr);
                                                      }
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
                                                    gen("lit", 0, num);
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

fpre_action:                                      {
                                                    flevel++;
                                                  }
            ;
            
fpost_action:                                     {
                                                    flevel--;
                                                  }
            ;
            
factor_latter:           
          MULTIPLY fpre_action factor fpost_action multiply_action factor_latter 

        | DIVIDE fpre_action factor fpost_action divide_action factor_latter
               
        | 
        ;
        	
multiply_action:                                  {
                                                    gen("opr",0,4); 
                                                  }
        ;

divide_action:                                    {
                                                    gen("opr",0,5);
                                                  }
        ;
                
%%

int yyerror(const char *s) {
  //liprintf( "%s around line no %d\n",s, yylloc.first_line);
}

int enter(char* identifier, int level, int val, int type) {
  //symbol table
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
//generates code
int gen( char* x, int y, int z) {
  if(cx > CXMAX)
  {
    printf(" PROGRAM TOO LONG");
    exit(0);
  } 
  else
  {
    strcpy(code[cx].f,x);
    code[cx].l = y;
    code[cx].a = z;
    cx++;
    return 1;
  }
  return 0;
}

int main(void) {
  int i =0;
  for( i = 0; i < TXMAX; i++)
  {
    strcpy(code[i].f,"PPP");
    code[i].l = -1;
  }  
  yyparse();
  i = 0;
  while(code[i].l !=-1)
    {
      printf("%d\t\t%s\t\t%d\t\t%d\n",i,code[i].f,code[i].l,code[i].a);
      i++;
    } 
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
  //position in symbol table  
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
