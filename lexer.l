%option noyywrap yylineno

%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
%}

                /* Define named regexp pattern here */

                /* Define lexer state variable here */
%x UNKNOWN_CHAR
%x COMMENT

%%

                /* Once unknown char is found, eat everything up to EOL */
<UNKNOWN_CHAR>[^\n]*    { fprintf(
                            stderr,
                            "ncl: unidentified token at \"%s\" on line %d\n",
                            yytext,
                            yylineno); }

                /* EOL turns off unknown char state */
<UNKNOWN_CHAR>\n        { BEGIN(INITIAL); return EOL; }

                /* Anything between # and EOL is comment */
"#"         { BEGIN(COMMENT); }
<COMMENT>.  { /* ignored */ }
<COMMENT>\n { BEGIN(INITIAL); return EOL; }

\n          { return EOL; }

[ \t\r]+    { /* It is not precise to say space chars are
               * ignored they do serve as delimitors, and
               * are thus lexically significant
               */
            }

                /* Number */
0|[1-9][0-9]*   { yylval.n = atoi(yytext);
                  return NUMBER;
                }

                /* Register name
                 * Turn A-Z into array index for register array */
R[A-Z]      { yylval.r = (yytext[1] >= 'a' ? yytext[1]-32 : yytext[1]);
              yylval.r -= 'A';
              return REG;
            }

                /* Line label */
"@"[A-Z]{1,8}   { /* DON'T do this, copy anything to be retained like
                   * below instead of this:
                   * yylval.s = yytext;
                   */
                  char* label = malloc(strlen(yytext));
                  strcpy(label, yytext);
                  yylval.s = label;
                  return LABEL;
                }

                /* Keywords, operators does not need lvalue update,
                 * however, returning the token enum as identifiter
                 * is needed
                 */
"if"        { return IF; }
"set"       { return SET; }
"goto"      { return GOTO; }
":"         { return COLON; }
"push"      { return PUSH; }
"pop"       { return POP; }
"halt"      { return HALT; }

"="         { return ASSIGN; }

"=="        { return CMP_EQ; }
">"         { return CMP_GT; }
">="        { return CMP_GTE; }
"<"         { return CMP_LT; }
"<="        { return CMP_LTE; }
    /*
"!="        { return CMP; }
    */
"+"         { return PLUS; }
"-"         { return MINUS; }

                /* Obviously error if none of above rules match */
.           { // Push back the offending char, UNKNOWN_CHAR rules
              // will handle it _as_a_whole_
              yyless(yyleng-1);
              BEGIN(UNKNOWN_CHAR);
              // What to do then? Ans: Refer to UNKNOWN_CHAR rules
            }

%%
