#include <stdio.h>
#include "ncl.h"

extern int yyparse();

int main(void)
{
    ncl_init();
    printf("(ncl version 0.1)\n");

    int result = yyparse();
    if (result != 0)
    {
        fprintf(stderr, "Aborted\n");
        goto CLEAN_UP;
    }

    result = ncl_resolve_labels();
    if (result == 0)
    {
        ncl_exec_inst();
        ncl_dump_reg();
    }
    else
    {
        fprintf(stderr, "Aborted\n");
    }

CLEAN_UP:
    ncl_cleanup();
    return result;
}
