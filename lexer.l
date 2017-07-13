%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
%}

                /* Define name regexp pattern here */

                /* Define state variable here */
%x UNKNOWN_CHAR

%%

<UNKNOWN_CHAR>[^\n]*    { fprintf(stderr,"lex error at '%s'\n",yytext); }
<UNKNOWN_CHAR>\n        { BEGIN(INITIAL); return EOL; }

\n          { return EOL; }

[ \t\r]+    { /* It is not precise to say space chars are
               * ignored they do serve as delimitors, and
               * are thus lexically significant.
               */
            }

[1-9][0-9]*     { yylval.n = atoi(yytext);
                  return NUMBER;
                }

L[1-9][0-9]*    { return LABEL; }

R[A-Z]      { yylval.r = (yytext[1] >= 'a' ? yytext[1]-32 : yytext[1]);
              yylval.r -= 'A';
              return REG;
            }

"if"        { return IF; }
"then"      { return THEN; }
"set"       { return SET; }
"goto"      { return GOTO; }
"push"      { return PUSH; }
"pop"       { return POP; }

"=="        { return CMP; }
"="         { return ASSIGN; }

">"         { return CMP; }
">="        { return CMP; }
"<"         { return CMP; }
"<="        { return CMP; }
"!="        { return CMP; }

.           { /*fprintf(stderr,
                "Unrecognized character: %c (int %d)\n",
                yytext[0],
                (int)yytext[0]);
              */
              yyless(yyleng-1);
              BEGIN(UNKNOWN_CHAR);
              // What to do then?
            }

%%
