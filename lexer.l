%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
%}

                /* Define name regexp pattern here */

                /* Define state variable here */
%x UNKNOWN_CHAR
%x COMMENT

%%

<UNKNOWN_CHAR>[^\n]*    { fprintf(stderr,"lex error at '%s'\n",yytext); }
<UNKNOWN_CHAR>\n        { BEGIN(INITIAL); return EOL; }

                /* Anything between # and EOL is comment */
"#"         { BEGIN(COMMENT); }
<COMMENT>.  { /* ignore */ }
<COMMENT>\n { BEGIN(INITIAL); return EOL; }

\n          { return EOL; }

[ \t\r]+    { /* It is not precise to say space chars are
               * ignored they do serve as delimitors, and
               * are thus lexically significant.
               */
            }

0|[1-9][0-9]*   { yylval.n = atoi(yytext);
                  return NUMBER;
                }

R[A-Z]      { yylval.r = (yytext[1] >= 'a' ? yytext[1]-32 : yytext[1]);
              yylval.r -= 'A';
              return REG;
            }

"@"[A-Z]{1,8}   { /* DON'T do this, copy anything to be retained instead:
                   * yylval.s = yytext;
                   */
                  // TODO: Clean up label
                  char* label = malloc(strlen(yytext));
                  strcpy(label, yytext);
                  yylval.s = label;
                  return LABEL;
                }

"if"        { return IF; }
"set"       { return SET; }
"goto"      { return GOTO; }
":"         { return COLON; }
"push"      { return PUSH; }
"pop"       { return POP; }

"="         { return ASSIGN; }

"=="        { return CMP_EQ; }
">"         { return CMP_GT; }
">="        { return CMP_GTE; }
    /*
"<"         { return CMP; }
"<="        { return CMP; }
"!="        { return CMP; }
    */
"+"         { return PLUS; }
"-"         { return MINUS; }

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
