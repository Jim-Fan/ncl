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

    NCL_STACK = (int*)malloc(NCL_STACK_SIZE * sizeof(unsigned int));
    for (int i = 0; i < NCL_STACK_SIZE; ++i) {
        NCL_STACK[i] = 0x0;
    }

    NCL_REG = (int*)malloc(NCL_REG_SIZE * sizeof(unsigned int));
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
                if (NCL_INST_LIST[i]->label != NULL)
                    free(NCL_INST_LIST[i]->label);
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

//  Execute array of instruction collected by parsing phase
void ncl_exec_inst()
{
    int ip = 0;
    int jump_ip = 0;
    int err = 0;
    int k = 0, x = 0, y = 0, z = 0;
    NCL_INST* i = NULL;

NEXT_INST:
    i = NCL_INST_LIST[ip];
    if (i == NULL) goto NCL_EXEC_RETURN;

    switch (i->code)
    {
        case PUSH:
            if (NCL_SP+1 >= NCL_STACK_SIZE)
            {
                fprintf(stderr, "ncl: fatal runtime error, stack overflow\n");
                err = 1;
                goto NCL_EXEC_RETURN;
            }

            // arg1 determines REG or NUMBER is pushed
            if ((int)i->arg1 == NUMBER)
                NCL_STACK[NCL_SP++] = (unsigned int)i->arg2;
            else
                NCL_STACK[NCL_SP++] = NCL_REG[(int)i->arg2];

            ++ip;
            break;

        case POP:
            if (NCL_SP <= 0)
            {
                fprintf(stderr, "ncl: fatal runtime error, stack underflow\n");
                err = 1;
                goto NCL_EXEC_RETURN;
            }

            NCL_REG[(int)i->arg1] = NCL_STACK[NCL_SP-1];
            --NCL_SP;
            ++ip;
            break;

        case SET:

            k = (int)i->arg3 >> 16;  // extract upper 16-bit
            z = (int)i->arg3 & 0x0000FFFF;  // extract lower 16-bit

            if (k == 0) // SET REG = REG
            {
                NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2];
            }
            else if (k == 1) // SET REG = NUMBER
            {
                NCL_REG[(int)i->arg1] = (unsigned int)i->arg2;
            }
            else if (k == 2) // SET REG = REG op REG
            {
                switch (z)
                {
                    case PLUS:
                       NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                               +
                                               NCL_REG[(int)i->arg4];  
                        break;

                    case MINUS:
                       NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                               -
                                               NCL_REG[(int)i->arg4];  
                        break;

                    case CMP_EQ:
                        NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                                ==
                                                NCL_REG[(int)i->arg4];
                        break;

                    case CMP_GT:
                        NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                                >
                                                NCL_REG[(int)i->arg4];
                        break;

                    case CMP_GTE:
                        NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                                >=
                                                NCL_REG[(int)i->arg4];
                        break;

                    case CMP_LT:
                        NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                                <
                                                NCL_REG[(int)i->arg4];
                        break;

                    case CMP_LTE:
                        NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                                <=
                                                NCL_REG[(int)i->arg4];
                        break;
                }
            }
            else if (k == 3) // SET REG = REG op NUMBER
            {
                switch (z)
                {
                    case PLUS:
                       NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                               +
                                               (unsigned int)i->arg4;
                        break;

                    case MINUS:
                       NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                               -
                                               (unsigned int)i->arg4;
                        break;

                    case CMP_EQ:
                        NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                                ==
                                                (unsigned int)i->arg4;
                        break;

                    case CMP_GT:
                        NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                                >
                                                (unsigned int)i->arg4;
                        break;

                    case CMP_GTE:
                        NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                                >=
                                                (unsigned int)i->arg4;
                        break;

                    case CMP_LT:
                        NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                                <
                                                (unsigned int)i->arg4;
                        break;

                    case CMP_LTE:
                        NCL_REG[(int)i->arg1] = NCL_REG[(int)i->arg2]
                                                <=
                                                (unsigned int)i->arg4;
                        break;
                }
            }

            ++ip;
            break;

        case GOTO:

            // Jump only if register value is true
            if (! NCL_REG[(int)i->arg2])
            {
                ++ip;
                break;
            }

            // i->arg1 has the instruction array index to jump to
            ip = i->arg1;
            break;

        case HALT:
            goto NCL_EXEC_RETURN;

        default:
            ncl_blame("Unrecognised instruction code");
            break;
    }
    goto NEXT_INST;

NCL_EXEC_RETURN:
    return;
}

NCL_INST* ncl_new_inst(
    int code,
    char* label,
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

int ncl_append_inst(NCL_INST* i)
{
    // If given instruction is NULL, it is error
    if (i == NULL) return 1;

    // If instruction list is full, it is error
    if (NCL_IP+1 >= NCL_INST_LIST_SIZE)
    {
        ncl_blame("Instruction list overflow");
        return 2;
    }

    NCL_INST_LIST[NCL_IP++] = i;
    return 0;
}

NCL_INST* ncl_set_inst_label(char* label, NCL_INST* i)
{
    i->label = label;
    return i;
}

int ncl_resolve_labels()
{
    NCL_INST* i;
    char* s;
    int err = 0;
    int found = 0;

    for (int k=0; k<NCL_INST_LIST_SIZE; ++k)
    {
        i = NCL_INST_LIST[k];

        // Only lookup label for GOTO statements
        if (i == NULL || i->code != GOTO) continue;

        // This is GOTO statement, three scenario will arise:
        // 1. The label is defined exactly once, good
        // 2. The label is defined more than once, bad
        // 3. The label is not defined at all, bad
        //
        // All are handled. Not handled are:
        // 4. Line label defined, not used, but more than once

        // Is the GOTO label resolved?
        found = 0;

        // Because GOTO label was allocated separately, keep a pointer
        // and free it later
        s = (char*)i->arg1;

        for (int m=0; m<NCL_INST_LIST_SIZE; ++m)
        {
            // If line being scanned has no label, move on
            if (NCL_INST_LIST[m] == NULL
                ||
                NCL_INST_LIST[m]->label == NULL) continue;

            // If GOTO label matches this line label...
            if (strcmp(s, NCL_INST_LIST[m]->label) == 0)
            {
                // Make GOTO label points to the actual instruction address
                i->arg1 = m;

                // If the GOTO label has been found already, this is dup
                if (found)
                {
                    fprintf(
                        stderr,
                        "ncl: duplicate line label %s\n",
                        s);
                }
                else
                {
                    found += 1;
                }

                // No need to break so as to scan through all lines for dup
                // and free label
            }
        }

        if (! found)
        {
            // Blame if GOTO label cannot be resolved
            // No way I can tell faulty line because comment/blank lines
            // are not there any more
            err = 1;
            fprintf(
                stderr,
                "ncl: unresolved line label %s\n",
                s);

            // Now the label is useless
            i->arg1 = NULL;
        }

        free(s);
    }

    return err;
}

unsigned int ncl_deref_reg(int r)
{
    return NCL_REG[r];
}

void ncl_prompt()
{
    printf("[%d] ", ncl_next_inst_label());
}

void ncl_blame(char* what)
{
    printf("\t%s\n", what);
}

void ncl_dump_reg()
{
    printf("ncl state dump:\n\n");
    printf("\tIP: %10d\tSP: %10d\n\n", NCL_IP, NCL_SP);

    int offset = NCL_REG_SIZE/2;
    for (int i=0; i<offset; ++i)
    {
        printf("\tR%c: %10u\tR%c: %10u\n",
            i+'A',
            NCL_REG[i],
            i+'A'+offset,
            NCL_REG[i+offset]
        );
    }
}
