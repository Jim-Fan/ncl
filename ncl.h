#ifndef _NCL_H_
#define _NCL_H_

#include "parser.tab.h"

typedef struct _ncl_inst
{
    int code;
    char* label;
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
static unsigned int* NCL_STACK = NULL;

static int NCL_REG_SIZE = 26;   // RA to RZ
static unsigned int* NCL_REG = NULL;

//

void ncl_init();
void ncl_cleanup();

void ncl_exec_inst();
NCL_INST* ncl_new_inst(int,char*,void*,void*,void*,void*);
int ncl_next_inst_label();
int ncl_append_inst(NCL_INST*);
NCL_INST* ncl_set_inst_label(char*,NCL_INST*);
int ncl_resolve_labels();

unsigned int ncl_deref_reg(int);

void ncl_prompt();
void ncl_blame(char*);
void ncl_dump_reg();

#endif
