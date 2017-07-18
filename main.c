#include <stdio.h>
#include "ncl.h"

extern int yyparse();

int main(void)
{
    ncl_init();
    printf("(ncl version 0.1)\n");
    // ncl_prompt();
    yyparse();

    if (ncl_resolve_labels() == 0)
    {
        ncl_exec_inst();
        ncl_dump_reg();
    }
    else
    {
        fprintf(stderr, "Aborted\n");
    }
    ncl_cleanup();
}
