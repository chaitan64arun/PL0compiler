%{
#include<stdio.h>
#include<stdlib.h>
#include "plGlobal.h"
#include "y.tab.h"
extern YYLTYPE yylloc;
#define YY_USER_INIT yylloc.first_line=1;
%}

%%
"const"                { return CONST;          }
"var"                  { return VAR;            }
"procedure"            { return PROCEDURE;      }
"begin"                { return START;          }
"end"                  { return END;            }
"call"                 { return CALL;           }
"if"                   { return IF;             }
"then"                 { return THEN;           }
"while"                { return WHILE;          }
"do"                   { return DO;             }
"odd"                  { return ODD;            }
"*"                    { return MULTIPLY;       }
"-"                    { return MINUS;          }
"+"                    { return PLUS;           }
"/"                    { return DIVIDE;         }
":="                   { return ASSIGN;         }
"="                    { return EQUAL;          }
">"                    { return GTTHAN;         }
"<"                    { return LESSTHAN;       }
"<="                   { return LESSEQL;        }
">="                   { return GTEQL;          }
"!="                   { return NOTEQUAL;       }
"("                    { return LPAREN;         }
")"                    { return RPAREN;         }
","                    { return COMMA;          }
";"                    { return SEMICOLON;      }
"."                    { return DOT;            }
[A-Za-z][A-Za-z0-9]*   { yylval.stringVal = yytext; 
                         return IDENT;          }
([1-9][0-9]*)|[0]      { yylval.intVal = atol(yytext); 
                          return number;        }
\n                     {yylloc.first_line++;    }
[ \t\r]                { /*printf("%s : TAB\n",yytext);*/        }
.                      { return JUNK;           }
%%


