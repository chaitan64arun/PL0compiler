%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  
#include "plGlobal.h"
#include "y.tab.h"
extern YYLTYPE yylloc;
#define YY_USER_INIT yylloc.first_line=1;
%}



number [0-9]+
alphabet [a-zA-Z]
alphanumeral [0-9a-zA-Z]
pattern {alphabet}(_|{alphabet}|{alphanumeral})*
value {number}
special_symbols [+-/()!==,.<=<>=>;:=]+
pattern_symbol {special_symbols}

%%

[ |\t] ;


{value} {//printf("number found is %f \n",atof(yytext));
        yylval.intVal = atol(yytext);
        return number;
        }

"*" {//printf("symbol found is %s \n",multiply);
    return MULTIPLY;
    }   

{pattern_symbol}  {

	if(strcmp(yytext,"+")==0)  {
        //printf("symbol found is %s \n",plus);
        return PLUS;
  }
	else if(strcmp(yytext,"-")==0)	{
        //printf("symbol found is %s \n",minus);
        return MINUS;
  }
	else if(strcmp(yytext,"/")==0)  {
        //printf("symbol found is %s \n",divide);
        return DIVIDE;
  }
	else if(strcmp(yytext,"(")==0)  {
        //printf("symbol found is %s \n",lparen);
        return LPAREN;
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
  }
	else if(strcmp(yytext,")")==0)  {
        //printf("symbol found is %s \n",rparen);
        return RPAREN;
  }
	else if(strcmp(yytext,"!=")==0)  { 
        //printf("symbol found is %s \n",notequal);
        return NOTEQUAL;
  }
	else if(strcmp(yytext,"=")==0)  {
        //printf("symbol found is %s \n",eql);
        return EQUAL;
  }
  	else if(strcmp(yytext,":=")==0)  {
        //printf("symbol found is %s \n",eql);
        return ASSIGN;
  }
	else if(strcmp(yytext,",")==0) {
       //printf("symbol found is %s \n",comma);
       return COMMA; 
  }
	else if(strcmp(yytext,".")==0) {
         //printf("symbol found is %s \n",dot);
         return DOT; 
  }
	else if(strcmp(yytext,"<=")==0) {
        //printf("symbol found is %s \n",lesseql);
        return LESSEQL;
  }
	else if(strcmp(yytext,"<")==0) {
        //printf("symbol found is %s \n",lessthan);
        return LESSTHAN;
  }
	else if(strcmp(yytext,">=")==0) {
        //printf("symbol found is %s \n",gteql);
        return GTEQL;
  }
  	
  
	else if(strcmp(yytext,">")==0) {
        //printf("symbol found is %s \n",gtthan);
        return GTTHAN;
  }
  	else if(strcmp(yytext,";")==0)  {
        //printf("symbol found is %s \n",semicolon);
        return SEMICOLON;
  }
  else {
    yylval.stringVal = yytext;
        //printf("word is %s \n",yytext);
	      return JUNK;}
  }
	
{pattern}  { 
	if(strcmp(yytext,"begin")==0) {
    return START;
  }
  else if(strcmp(yytext,"call")==0) {
        return CALL;
  }
  else if(strcmp(yytext,"const")==0)  {
    //printf("symbol found is %s \n ",constsym);
    return CONST;
  }
  else if(strcmp(yytext,"do")==0) { 
    //printf("symbol found is %s \n ",dosym);
    return DO;
  }
  else if(strcmp(yytext,"end")==0)  {
    //printf("symbol found is %s \n ",endsym);
    return END;
  }
  else if(strcmp(yytext,"if")==0) {
    //printf("symbol found is %s \n ",ifsym);
    return IF;
  }

  else if(strcmp(yytext,"odd")==0)  {
    //printf("symbol found is %s \n ",oddsym);
    return ODD;
  }
  else if(strcmp(yytext,"procedure")==0)  {
    //printf("symbol found is %s \n",procsym);
    return PROCEDURE;
  }
  else if(strcmp(yytext,"then")==0) {
    //printf("symbol found is %s \n",thensym);
    return THEN;
  }
  else if(strcmp(yytext,"var")==0)  {
    //printf("symbol found is %s \n",varsym);
    return VAR;
  }
  else if(strcmp(yytext,"while")==0)  {
    //printf("symbol found is %s \n",whilesym);
    return WHILE;
  }
  else{
    yylval.stringVal = yytext;
    //printf("word found is %s \n",yytext);  
    return IDENT;}
           }


\n    {yylloc.first_line++;}
%%
int yywrap(void)
{
return 1;
}
