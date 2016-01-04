#ifndef _INTERCODE_H
#define _INTERCODE_H

#include "string.h"
#include "stdio.h"
#include "stdlib.h"
//operation type structure
typedef struct Operand_* Operand;
typedef struct InterCode_* InterCode;
struct Operand_ {
	enum {
		OP_VAR, OP_TVAR, OP_CONS, OP_FUNC, OP_LABEL, OP_TADDR, OP_VADDR
	} kind;
	enum {
		T_NONE, T_ADDR, T_STAR
	}type;
	union {
		int num;  // tvar, label
		char* value;  // cons
		char* name;   // func, var
	} u;
	Operand next;
};

struct InterCode_ {
	enum {
		IR_LABEL, IR_FUNC, IR_ASSIGN, IR_ADD, IR_MINUS, IR_MUL, IR_DIV, IR_GOTO, IR_IFGOTO, IR_RETURN, IR_DEC, IR_CALL, IR_PARAM, IR_ARG, IR_READ, IR_WRITE
	} kind;

	union {
		struct {  // label, func, goto, return, param, arg, read, write
			Operand op; 
		} one;
		struct {  // assign call
			Operand left, right;
		} assign;
		struct {  // add, minus, mul, div
			Operand result, op1, op2; 
		} binop;
		struct {  // ifgoto
			Operand x, y, z;
			char* relop;
		} triop;
		struct { // dec
			Operand op;
			int size;
		} dec;
	} u;
	InterCode pre, next;
};

extern InterCode c_head, c_tail;
extern int varnum, labnum;

// IR related function
void insertCode(InterCode code);
void deleteCode(InterCode code);
void printCode(char* fname);
void printOperand(Operand op, FILE* f);
void rmcons();
void reptvar();
#endif
