#include <stdio.h>
#include "ncl.h"

extern int yyparse();

int main(void)
{
    ncl_init();
    printf("(ncl version 0.1)\n");
    ncl_prompt();
    yyparse();
    ncl_cleanup();
}
