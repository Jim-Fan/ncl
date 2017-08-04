%{
#include <stdio.h>
#include <string.h>
#include "ncl.h"

    /* Lexer would provide */
extern int yylex(void);
extern int yylineno;

    /* Parser should provide */
void yyerror(char* s)
{
    /* Can I do better than saying "ncl: syntax error" */
    /* fprintf(stderr, "ncl: %s\n", s); */

    /* Too bad, yytext is empty string */
    /* fprintf(stderr, "ncl: syntax error \"%s\"\n", yytext); */

    /* I am wondering how and if I should pass argument s */
    fprintf(stderr, "ncl: syntax error on line %d\n", yylineno);
}

%}

        /* Return value by lexer's rule, which is part of yylex() */
        /* Coded as C enum in parser header */
%token EOL
%token IF
%token SET
%token GOTO
%token COLON
%token PUSH POP
%token ASSIGN
%token HALT

        /* typedef of YYSTYPE i.e. type of yylval */
%union {
    unsigned int n;
    struct NCL_INST* inst;
    int r;
    char* s;
    int op;
}

%token <s> LABEL
%token <n> NUMBER
%token <r> REG
%token <n> PLUS MINUS CMP_EQ CMP_GT CMP_GTE CMP_LT CMP_LTE

        /* Associativity and precedence, not applicable here */
/* %nonassoc <fn> CMP */
/* %left TIMES DIV */

        /* Map data type of each grammatical construct */
%type <inst> stmt
%type <inst> label_stmt
%type <n> op

        /* Top level production rule */
%start calclist

%%

label_stmt:
  LABEL COLON stmt        { $$ = ncl_set_inst_label($1, $3); }
;


        /* 4 type of assignment to register, distinguished by higher
         * word of 5the arg of ncl_new_inst():
         *
         *      0: Assign register value to register
         *      1: Assign hard-coded numeric value to register
         *      2: Assign new numeric value derived from
         *         operation on two registers
         *      3: Assign new numeric value derived from
         *         operation on a register and a hard-coded
         *         number (not the other way round)
         *
         * Lower word of 5th arg contains the operator, thus
         * arg packed as:
         *
         *      2<<16 | OPERATOR
         */
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
  |
  HALT                  { $$ = ncl_new_inst(
                                HALT,
                                NULL,
                                NULL, NULL, NULL, NULL); }
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
  |
  CMP_LT    { $$ = CMP_LT; }
  |
  CMP_LTE   { $$ = CMP_LTE; }
;


        /****************    Parser main loop ***************/

calclist:

        /* Skip empty rule would fail bison */
        /* Why? Without empty rule, there is no terminal production
         * rule. And since calclist is recursively defined,
         * production would not terminate
         */
  %empty
  |
  calclist EOL {
    /* nothing to do? */
  }
  |
  calclist stmt EOL {
    ncl_append_inst($2);
  }
  |
  calclist label_stmt EOL {
    ncl_append_inst($2);
  }
  |
  calclist error EOL {
    /* Using yyerrok allows recovery from syntax error and thus
     * checking on later lines is possible */
    yyerrok;

    /* Using YYABORT halts compiling upon first faulty line */
    //YYABORT;
  }
;


%%
