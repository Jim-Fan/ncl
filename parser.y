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
%token IF
%token SET
%token GOTO
%token PUSH POP

        /* typedef of YYSTYPE i.e. type of yylval */
%union {
    int n;
    struct NCL_INST* inst;
    int r;
}

%token <n> LABEL
%token <n> NUMBER
%token <r> REG
%token <n> REG_VAL

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
  GOTO LABEL IF REG     { }
  |
  SET REG ASSIGN exp    { $$ = ncl_new_inst(
                                SET,
                                ncl_next_inst_label(),
                                $2, $4, NULL, NULL); }
  |
  PUSH exp              { $$ = ncl_new_inst(
                                PUSH,
                                ncl_next_inst_label(),
                                $2, NULL, NULL, NULL); }
  |
  POP REG               { $$ = ncl_new_inst(
                                POP,
                                ncl_next_inst_label(),
                                $2, NULL, NULL, NULL); }
;


exp:
  /*
  exp CMP exp       { }
  |
  exp TIMES exp     { }
  | 
  exp DIV exp       { }
  |
  */
  exp PLUS exp      { $$ = $1 + $3; }
  |
  exp MINUS exp     { $$ = $1 - $3; }
  |
  REG_VAL           { $$ = ncl_deref_reg($1); }
  |
  NUMBER            { $$ = $1; }
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
