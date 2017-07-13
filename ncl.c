#include <stdio.h>
#include <stdlib.h>
#include "ncl.h"

/* Initialise ncl machine i.e. registers, stack, instruction array */
void ncl_init()
{
    NCL_INST_LIST = (NCL_INST**)malloc(NCL_INST_LIST_SIZE * sizeof(NCL_INST*));
    for (int i=0; i<NCL_INST_LIST_SIZE; ++i)
    {
        NCL_INST_LIST[i] = NULL;
    }

    NCL_STACK = (int*)malloc(NCL_STACK_SIZE * sizeof(int));
    for (int i = 0; i < NCL_STACK_SIZE; ++i) {
        NCL_STACK[i] = 0x0;
    }

    NCL_REG = (int*)malloc(NCL_REG_SIZE * sizeof(int));
    for (int i = 0; i < NCL_REG_SIZE; ++i) {
        NCL_REG[i] = 0x0;
    }
}

/*  Clean up ncl machine i.e. registers, stack, instruction array */
void ncl_cleanup()
{
    if (NCL_INST_LIST != NULL)
    {
        // Could loop through a lot unused, NULL pointers
        for (int i=0; i<NCL_INST_LIST_SIZE; ++i)
        {
            if (NCL_INST_LIST[i] != NULL)
            {
                free(NCL_INST_LIST[i]);
                NCL_INST_LIST[i] = NULL;
            }
        }
        free(NCL_INST_LIST);
    }
    if (NCL_STACK != NULL) free(NCL_STACK);
    if (NCL_REG != NULL) free(NCL_REG);

    NCL_INST_LIST = NULL;
    NCL_STACK = NULL;
    NCL_REG = NULL;
}

/*  Execute an instruction, change state of ncl machine, append
 *  instruction object to list if run ok. Consider this as
 *  eval(syntax_tree* t) of a LISP interpreter
 */
void ncl_exec_inst(NCL_INST* i)
{
    // If instruction list is full, abort
    if (NCL_IP+1 >= NCL_INST_LIST_SIZE)
    {
        ncl_blame("Instruction list overflow");
        return;
    }

    // Run instruction, append to instruction list if run ok:
    int err = 0;
    int should_insert = 0;
    switch (i->code)
    {
        case PUSH:
            if (NCL_SP+1 >= NCL_STACK_SIZE)
            {
                ncl_blame("Stack overflow");
                err = 1;
                break;
            }
            NCL_STACK[NCL_SP++] = (int)i->arg1;
            should_insert = 1;
            break;

        case POP:
            if (NCL_SP <= 0)
            {
                ncl_blame("Stack underflow");
                err = 1;
                break;
            }
            NCL_REG[(int)i->arg1] = NCL_STACK[NCL_SP-1];
            --NCL_SP;
            should_insert = 1;
            break;

        case SET:
            NCL_REG[(int)i->arg1] = (int)i->arg2;
            should_insert = 1;

        default:
            break;
    }

    if (!err && should_insert)
    {
        NCL_INST_LIST[NCL_IP++] = i;
    }

NCL_EXEC_RETURN:
    return;
}

NCL_INST* ncl_new_inst(
    int code,
    unsigned int label,
    void* arg1,
    void* arg2,
    void* arg3,
    void* arg4)
{
    NCL_INST* i = (NCL_INST*)malloc(sizeof(NCL_INST));
    i->code = code;
    i->label = label;
    i->arg1 = arg1;
    i->arg2 = arg2;
    i->arg3 = arg3;
    i->arg4 = arg4;
    return i;
}

int ncl_next_inst_label()
{
    return NCL_IP + 1;
}

void ncl_prompt()
{
    printf("[%d] ", ncl_next_inst_label());
}

void ncl_blame(char* what)
{
    printf("\t%s\n", what);
}
