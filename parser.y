%{
#include <stdio.h>
#include <string.h>
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
%token COLON
%token PUSH POP
%token ASSIGN

        /* typedef of YYSTYPE i.e. type of yylval */
%union {
    int n;
    struct NCL_INST* inst;
    int r;
    char* s;
    int op;
}

%token <s> LABEL
%token <n> NUMBER
%token <r> REG
%token <n> PLUS MINUS CMP_EQ CMP_GT CMP_GTE

        /* Associativity and precedence */
        /* Example:                     */
/* %nonassoc <fn> CMP */
/* %left TIMES DIV */

        /* Map data type of semantic construct */
%type <inst> stmt
%type <inst> label_stmt
%type <n> op

        /* Top level production rule */
%start calclist

%%

label_stmt:
  LABEL COLON stmt        { $$ = ncl_set_inst_label($1, $3); }
;


stmt:
  GOTO LABEL IF REG     { $$ = ncl_new_inst(
                                GOTO,
                                NULL,
                                $2, $4, NULL, NULL); }
  |
  SET REG ASSIGN REG            { $$ = ncl_new_inst(
                                        SET,
                                        NULL,
                                        $2, $4, 0, NULL); }
  |
  SET REG ASSIGN NUMBER         { $$ = ncl_new_inst(
                                        SET,
                                        NULL,
                                        $2, $4, 1<<16, NULL); }
  |
  SET REG ASSIGN REG op REG     { $$ = ncl_new_inst(
                                        SET,
                                        NULL,
                                        $2, $4, 2<<16|$5, $6);}
  |
  SET REG ASSIGN REG op NUMBER  { $$ = ncl_new_inst(
                                        SET,
                                        NULL,
                                        $2, $4, 3<<16|$5, $6);}
  |
  PUSH NUMBER           { $$ = ncl_new_inst(
                                PUSH,
                                NULL,
                                NUMBER, $2, NULL, NULL); }
  |
  PUSH REG              { $$ = ncl_new_inst(
                                PUSH,
                                NULL,
                                REG, $2, NULL, NULL); }
  |
  POP REG               { $$ = ncl_new_inst(
                                POP,
                                NULL,
                                $2, NULL, NULL, NULL); }
;


op:
  PLUS      { $$ = PLUS; }
  |
  MINUS     { $$ = MINUS; }
  |
  CMP_EQ    { $$ = CMP_EQ; }
  |
  CMP_GT    { $$ = CMP_GT; }
  |
  CMP_GTE   { $$ = CMP_GTE; }
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
    // ncl_prompt();
  }
  |
  calclist stmt EOL {
    //ncl_exec_inst($2);
    ncl_append_inst($2);
    // ncl_prompt();
  }
  |
  calclist label_stmt EOL {
    //ncl_exec_inst($2);
    ncl_append_inst($2);
    // ncl_prompt();
  }
  |
  calclist error EOL {
    /* Minimal error recovery */
    yyerrok;
    // ncl_prompt();
  }
;


%%
