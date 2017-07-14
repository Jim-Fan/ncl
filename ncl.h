#ifndef _NCL_H_
#define _NCL_H_

#include "parser.tab.h"

typedef struct _ncl_inst
{
    int code;
    unsigned int label;
    void* arg1;
    void* arg2;
    void* arg3;
    void* arg4;
} NCL_INST;

static int NCL_IP = 0;
static int NCL_INST_LIST_SIZE = 128;
static NCL_INST** NCL_INST_LIST = NULL;

static int NCL_SP = 0;
static int NCL_STACK_SIZE = 128;
static int* NCL_STACK = NULL;

static int NCL_REG_SIZE = 26;   // RA to RZ
static int* NCL_REG = NULL;

//

void ncl_init();
void ncl_cleanup();

void ncl_exec_inst(NCL_INST*);
NCL_INST* ncl_new_inst(int,unsigned int, void*,void*,void*,void*);
int ncl_next_inst_label();

int ncl_deref_reg(int);

void ncl_prompt();
void ncl_blame(char*);

#endif
