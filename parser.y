%{
#include <stdio.h>
#include "ncl.h"

    /* Lexer would provide */
extern int yylex(void);

    /* Parser should provide */
void yyerror(char* s)
{
    fprintf(stderr, "yyerror: %s\n", s);
}

%}

        /* Return value of lexer's yylex() */
        /* Coded as C enum in parser header */
%token EOL
%token IF THEN
%token SET
%token GOTO LABEL
%token PUSH POP REG

        /* typedef of YYSTYPE i.e. type of yylval */
%union {
    int n;
    struct NCL_INST* inst;
}

%token <n> NUMBER

        /* Associativity and precedence */
%nonassoc <fn> CMP
%nonassoc ASSIGN
%left PLUS MINUS
%left TIMES DIV

        /* Map data type of semantic construct */
%type <inst> stmt
%type <n> exp

        /* Top level production rule */
%start calclist

%%

stmt:
  IF exp THEN stmt      { /* $$ = newbranch($2, $4, NULL); */ }
  |
  GOTO LABEL            { }
  |
  SET REG ASSIGN exp    { }
  |
  PUSH exp              { $$ = ncl_new_inst(
                                PUSH,
                                ncl_next_inst_label(),
                                $2, NULL, NULL, NULL); }
  |
  POP REG               { }
;


exp:
  exp CMP exp       { /* $$ = newcmp($2, $1, $3); */ }
  |
  exp PLUS exp      { /* $$ = newast('+', $1, $3); */ }
  |
  exp MINUS exp     { /* $$ = newast('-', $1, $3); */ }
  |
  exp TIMES exp     { /* $$ = newast('*', $1, $3); */ }
  | 
  exp DIV exp       { /* $$ = newast('/', $1, $3); */ }
  |
  NUMBER            { $$ = $1; }
  |
  REG               { }
;


        /****************    EOPL   ***************/

calclist:

        /* Skip empty rule would fail bison */
        /* Why? Without empty rule, there is no terminal production
         * rule. And since calclist is recursively defined,
         * production would not terminate
         */
  %empty
  |
  calclist EOL {
    ncl_prompt();
  }
  |
  calclist stmt EOL {
    //treeprint(0, $2);
    //printf("= %f\n", eval($2));
    //treefree($2);
    ncl_exec_inst($2);
    ncl_prompt();
  }
  |
  calclist error EOL {
    /* Minimal error recovery */
    yyerrok;
    ncl_prompt();
  }
;


%%
