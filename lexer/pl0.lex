%{
#include<stdio.h>
#include<stdlib.h>
%}

%%
const                { printf("%s : CONST\n",yytext);          }
var                  { printf("%s : VAR\n",yytext);            }
procedure            { printf("%s : PROCEDURE\n",yytext);      }
begin                { printf("%s : BEGIN\n",yytext);          }
end                  { printf("%s : END\n",yytext);            }
call                 { printf("%s : CALL\n",yytext);           }
if                   { printf("%s : IF\n",yytext);             }
then                 { printf("%s : THEN\n",yytext);           }
while                { printf("%s : WHILE\n",yytext);          }
do                   { printf("%s : DO\n",yytext);             }
odd                  { printf("%s : ODD\n",yytext);            }
\*                   { printf("%s : STAR\n",yytext);           }
\-                   { printf("%s : MINUS\n",yytext);          }
\+                   { printf("%s : PLUS\n",yytext);           }
\/                   { printf("%s : SLASH\n",yytext);          }
:=                   { printf("%s : ASSIGN\n",yytext);         }
\=                   { printf("%s : EQUAL\n",yytext);          }
\>                   { printf("%s : GREATER\n",yytext);        }
\<                   { printf("%s : LESSER\n",yytext);         }
\<=                  { printf("%s : LEQUAL\n",yytext);         }
\>=                  { printf("%s : GEQUAL\n",yytext);         }
\!=                  { printf("%s : NEQUAL\n",yytext);         }
\(                   { printf("%s : LPAREN\n",yytext);         }
\)                   { printf("%s : RPAREN\n",yytext);         }
\,                   { printf("%s : COMMA\n",yytext);          }
\;                   { printf("%s : SEMICOLON\n",yytext);      }
\.                   { printf("%s : DOT\n",yytext);            }
[A-Za-z][A-Za-z0-9]* { printf("%s : IDENT\n",yytext);          }
([1-9][0-9]*)|[0]    { printf("%s : NUMBER\n",yytext);         }
\n                   { /*printf("%s : NEXTLINE\n",yytext);*/   }
[ \t\r]              { /*printf("%s : TAB\n",yytext);*/        }
.                    { printf("%s : UNKNOWN\n",yytext);        }
%%

int main() {
	yylex();
	return 0;
}
