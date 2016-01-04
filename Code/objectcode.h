#ifndef _OBJECTCODE_H
#define _OBJECTCODE_H

#include "intercode.h"

#define regnum 32
typedef struct Reg_* Reg;
typedef struct Var_* Var;

struct Reg_
{
	char name[3];
	char* varn;
	int age;
};

struct Var_
{
	char* name;
	int offset;
	Var next;
};

Reg reglist[32];
extern Var varlist;
void initReg();
Reg getReg(Operand op, int lr, FILE* fp);
int getOffset(char* name);
Reg findReg(FILE* fp);
void addVar(char* name);
Reg checkReg(char* name, int ir, FILE* fp);
void printObjectCode(char* f);
int funcSpace(InterCode code);
void printOneCode(InterCode code, FILE* fp);
void storeReg(FILE* fp);
#endif


