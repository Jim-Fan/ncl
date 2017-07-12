#include <stdio.h>
#include "ncl.h"

extern int yyparse();

int main(void)
{
    printf("(ncl version 0.1)\n");
    ncl_prompt();
    return yyparse();
}
