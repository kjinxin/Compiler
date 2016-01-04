#include "objectcode.h"


Var varlist;
int goffset = 0, paranum = 0, argnum = 0;
// initialize the reg
void initReg()
{
	int i;
	for (i = 0; i < regnum; i++)
	{
		reglist[i] = malloc(sizeof(struct Reg_));
		reglist[i]->varn = NULL;
		reglist[i]->age = 0;
	}
	sprintf(reglist[0]->name, "%s", "$0");
	sprintf(reglist[1]->name, "%s", "$1");
	sprintf(reglist[2]->name, "%s", "$v0");
	sprintf(reglist[3]->name, "%s", "$v1");
	sprintf(reglist[4]->name, "%s", "$a0");
	sprintf(reglist[5]->name, "%s", "$a1");
	sprintf(reglist[6]->name, "%s", "$a2");
	sprintf(reglist[7]->name, "%s", "$a3");
	sprintf(reglist[8]->name, "%s", "$t0");
	sprintf(reglist[9]->name, "%s", "$t1");
	sprintf(reglist[10]->name, "%s", "$t2");
	sprintf(reglist[11]->name, "%s", "$t3");
	sprintf(reglist[12]->name, "%s", "$t4");
	sprintf(reglist[13]->name, "%s", "$t5");
	sprintf(reglist[14]->name, "%s", "$t6");
	sprintf(reglist[15]->name, "%s", "$t7");
	sprintf(reglist[16]->name, "%s", "$s0");
	sprintf(reglist[17]->name, "%s", "$s1");
	sprintf(reglist[18]->name, "%s", "$s2");
	sprintf(reglist[19]->name, "%s", "$s3");
	sprintf(reglist[20]->name, "%s", "$s4");
	sprintf(reglist[21]->name, "%s", "$s5");
	sprintf(reglist[22]->name, "%s", "$s6");
	sprintf(reglist[23]->name, "%s", "$s7");
	sprintf(reglist[24]->name, "%s", "$t8");
	sprintf(reglist[25]->name, "%s", "$t9");
	sprintf(reglist[26]->name, "%s", "$k0");
	sprintf(reglist[27]->name, "%s", "$k1");
	sprintf(reglist[28]->name, "%s", "$gp");
	sprintf(reglist[29]->name, "%s", "$sp");
	sprintf(reglist[30]->name, "%s", "$fp");
	sprintf(reglist[31]->name, "%s", "$ra");
	varlist = NULL;
}

// get the specific reg
Reg getReg(Operand op, int lr, FILE* fp)
{
	if (op == NULL) return NULL;
	char* name = malloc(32);
	Reg regop;
	switch (op->kind)
	{
		case OP_VAR:
		case OP_VADDR:
			sprintf(name, "%s", op->u.value);
			break;
		case OP_TVAR:
		case OP_TADDR:
			sprintf(name, "%c%d", 't', op->u.num);
			break;
		case OP_CONS:
			regop = findReg(fp);
			fprintf(fp, "li %s, %s\n", regop->name, op->u.value);
			return regop;
		default: break;

	}
	int offset = 0;
	switch (op->type)
	{
		case T_NONE:
			regop = findReg(fp);//checkReg(name, lr, fp);
			regop->varn = name;
			offset = getOffset(name);
			if (offset != -1)
				fprintf(fp, "lw %s, -%d($fp)\n", regop->name, offset);
			break;
		case T_ADDR:
			{
				regop = findReg(fp);
				offset = getOffset(name);
				fprintf(fp, "addi %s, $fp, -%d\n", regop->name, offset);
			break;
			}
		case T_STAR:
			regop = findReg(fp);//checkReg(name, lr, fp);
			regop->varn = name;
			offset = getOffset(name);
			if (offset != -1)
				fprintf(fp, "lw %s, -%d($fp)\n", regop->name, offset);
			if (lr == 1)
			{
				Reg regnew = findReg(fp);
				fprintf(fp, "lw %s, 0(%s)\n", regnew->name, regop->name);
				return regnew;
			}
			break;
		default: break;
	}
	return regop;
}

int getOffset(char* name)
{
	Var var = varlist;
	while (var != NULL)
	{
		if (!strcmp(name, var->name))
		{
			return var->offset;
		}
		var = var->next;
	}
	//printf("error offset %s\n", name);
	return -1;
}

Reg findReg(FILE* fp)
{
	int i;
	for (i = 8; i < 24; i ++)
	{
		if (reglist[i]->age != 0)
			reglist[i]->age ++;
	}
	int num = 0, max = 0;
	for (i = 8; i < 24; i ++)
	{
		if (reglist[i]->age == 0)
		{
			reglist[i]->varn = NULL;
			reglist[i]->age = 1;
			return reglist[i];
		}
		if (reglist[i]->age > max)
		{
			num = i;
			max = reglist[i]->age;
		}
	}
	/*
	if (reglist[num]->varn != NULL) 
	{
		addVar(reglist[num]->varn);
		int offset = getOffset(reglist[num]->varn);
		fprintf(fp, "sw %s, -%d($fp)\n", reglist[num]->name, offset);
	}
	*/
	reglist[num]->varn = NULL;
	reglist[num]->age = 1;
	return reglist[num];
}

void addVar(char* name)
{
	Var var = varlist;
	while (var != NULL)
	{
		if (!strcmp(name, var->name)) 
			return;
		var = var->next;
	}
	Var varnew = malloc(sizeof(struct Var_));
	varnew->name = name;
	varnew->offset = goffset + 4;
	goffset += 4;
	varnew->next = varlist;
	varlist = varnew;
}
Reg checkReg(char* name, int lr, FILE* fp)
{
	int i;
	for (i = 8; i < 24; i ++)
	{
		if (reglist[i]->varn != NULL && !strcmp(reglist[i]->varn, name))
		{
			return reglist[i];
		}
	}
	Reg regnew = findReg(fp);
	regnew->varn = name;
	/*
	regnew->varn = name;
	int offset = getOffset(name);
	if (offset != -1)
		fprintf(fp, "lw %s, -%d($fp)\n", regnew->name, offset);
	*/
	return regnew;
	
}
// print the assembly code
void printObjectCode(char* f)
{
	FILE *fp = fopen(f, "w");
	if (fp == NULL)
	{
		printf("error happens while opening file: %s\n", f);
		return;
	}
	fputs(".data\n", fp);
	fputs("_prompt: .asciiz \"Enter an integer:\"\n", fp);
	fputs("_ret: .asciiz \"\\n\"\n", fp);
	fputs(".globl main\n", fp);
	fputs(".text\n\n", fp);

	fputs("read:\n", fp);
	fputs(" li $v0, 4\n", fp);
	fputs(" la $a0, _prompt\n", fp);
	fputs(" syscall\n", fp);
	fputs(" li $v0, 5\n", fp);
	fputs(" syscall\n", fp);
	fputs(" jr $ra\n\n", fp);

	fputs("write:\n", fp);
	fputs(" li $v0, 1\n", fp);
	fputs(" syscall\n", fp);
	fputs(" li $v0, 4\n", fp);
	fputs(" la $a0, _ret\n", fp);
	fputs(" syscall\n", fp);
	fputs(" move $v0, $0\n", fp);
	fputs(" jr $ra\n", fp);
	
	initReg();
	InterCode code = c_head;
	while (code != NULL)
	{
		printOneCode(code, fp);
		code = code->next;
	}
}

int funcSpace(InterCode code)
{
	int tt = 0;
	InterCode co = code->next;
	while (co != NULL && co->kind != IR_FUNC)
	{
		tt++;
		co = co->next;
	}
	return -(tt * 4 * 3);
}

void storeReg(FILE* fp)
{
	int i;
	for (int i = 8; i < 24; i ++)
	{
		if (reglist[i]->varn != NULL)
		{
			addVar(reglist[i]->varn);
			int offset = getOffset(reglist[i]->varn);
			fprintf(fp, "sw %s, -%d($fp)\n", reglist[i]->name, offset);
		}
		reglist[i]->varn = NULL;
		reglist[i]->age = 0;
	}
}
void printOneCode(InterCode code, FILE* fp)
{
	switch (code->kind)
	{
		case IR_LABEL:
			fprintf(fp, "%s%d:\n", "label", code->u.one.op->u.num);
			break;
		case IR_FUNC:
			{
			int i;
			for (i = 8; i < 24; i ++)
			{
				reglist[i]->varn = NULL;
				reglist[i]->age = 0;
			}
			fprintf(fp, "\n%s:\n", code->u.one.op->u.value);
			goffset = 0;
			paranum = 2;
			
			fprintf(fp, "move $fp, $sp\n");
			int funcspace = funcSpace(code);
			fprintf(fp, "addi $sp, $sp, %d\n", funcspace);
			break;
			}
		case IR_ASSIGN:
			{
				Reg r1 = getReg(code->u.assign.left, 0, fp);
				Reg r2 = getReg(code->u.assign.right, 1, fp);

				if (code->u.assign.left->type == T_STAR)
				{
					fprintf(fp, "sw %s, 0(%s)\n", r2->name, r1->name);
				}
				else fprintf(fp, "move %s, %s\n", r1->name, r2->name);

				//**************************************modify
				addVar(r1->varn);
				int offset = getOffset(r1->varn);
				if (offset != -1) fprintf(fp, "sw %s, -%d($fp)\n", r1->name, offset);
				
				break;
			}
		case IR_ADD:
		case IR_MINUS:
		case IR_MUL:
		case IR_DIV:
			{
			Reg r1 = getReg(code->u.binop.result, 0, fp);
			Reg r2 = getReg(code->u.binop.op1, 1, fp);
			Reg r3 = getReg(code->u.binop.op2, 1, fp);
			switch (code->kind)
			{
				case IR_ADD:
					fprintf(fp, "add %s, %s, %s\n", r1->name, r2->name, r3->name);
					break;
				case IR_MINUS:
					fprintf(fp, "sub %s, %s, %s\n", r1->name, r2->name, r3->name);
					break;
				case IR_MUL:
					fprintf(fp, "mul %s, %s, %s\n", r1->name, r2->name, r3->name);
					break;
				case IR_DIV:
					fprintf(fp, "div %s, %s\n", r2->name, r3->name);
					fprintf(fp, "mflo %s\n", r1->name);
					break;
				default:break;
			}
				//**************************************modify
				addVar(r1->varn);
				int offset = getOffset(r1->varn);
				fprintf(fp, "sw %s, -%d($fp)\n", r1->name, offset);
			break;
			}
		case IR_GOTO:
			fprintf(fp, "j label%d\n", code->u.one.op->u.num);
			break;
		case IR_IFGOTO:
			{
			Reg r1 = getReg(code->u.triop.x, 1, fp);
			Reg r2 = getReg(code->u.triop.y, 1, fp);
			if (!strcmp(code->u.triop.relop, "=="))
			{
				fprintf(fp, "beq %s, %s, label%d\n", r1->name, r2->name, code->u.triop.z->u.num);
			}
			if (!strcmp(code->u.triop.relop, "!="))
			{
				fprintf(fp, "bne %s, %s, label%d\n", r1->name, r2->name, code->u.triop.z->u.num);
			}
			if (!strcmp(code->u.triop.relop, ">"))
			{
				fprintf(fp, "bgt %s, %s, label%d\n", r1->name, r2->name, code->u.triop.z->u.num);
			}
			if (!strcmp(code->u.triop.relop, "<"))
			{
				fprintf(fp, "blt %s, %s, label%d\n", r1->name, r2->name, code->u.triop.z->u.num);
			}
			if (!strcmp(code->u.triop.relop, ">="))
			{
				fprintf(fp, "bge %s, %s, label%d\n", r1->name, r2->name, code->u.triop.z->u.num);
			}
			if (!strcmp(code->u.triop.relop, "<="))
			{
				fprintf(fp, "ble %s, %s, label%d\n", r1->name, r2->name, code->u.triop.z->u.num);
			}
			break;
			}
		case IR_RETURN:
			{
			Reg r1 = getReg(code->u.one.op, 1, fp);
			fprintf(fp, "move $v0, %s\n", r1->name);
			fprintf(fp, "jr $ra\n");
			break;
			}
		case IR_DEC:
			{
			Var varnew = malloc(sizeof(struct Var_));
			varnew->name = code->u.dec.op->u.value;
			varnew->offset = goffset + code->u.dec.size;
			goffset += code->u.dec.size;
			varnew->next = varlist;
			varlist = varnew;
			break;
			}
		case IR_CALL:
			{
			//storeReg(fp);
			fprintf(fp, "addi $sp, $sp, -8\n");
			fprintf(fp, "sw $fp, 0($sp)\n");
			fprintf(fp, "sw $ra, 4($sp)\n");
			fprintf(fp, "jal %s\n", code->u.assign.right->u.value);
			Reg r1 = getReg(code->u.assign.left, 0, fp);
			fprintf(fp, "move $sp, $fp\n");
			fprintf(fp, "lw $fp, 0($sp)\n");
			fprintf(fp, "lw $ra, 4($sp)\n");
			fprintf(fp, "addi $sp, $sp, 8\n");
			fprintf(fp, "move %s, $v0\n", r1->name);
			fprintf(fp, "addi $sp, $sp, %d\n", argnum * 4);

			//**************************************modify
			addVar(r1->varn);
			int offset = getOffset(r1->varn);
			fprintf(fp, "sw %s, -%d($fp)\n", r1->name, offset);
			argnum = 0;
			break;
			}
		case IR_PARAM:
			{
			Reg r1 = getReg(code->u.one.op, 0, fp);
			fprintf(fp, "lw %s, %d($fp)\n", r1->name, paranum * 4);

			//**************************************modify
			addVar(r1->varn);
			int offset = getOffset(r1->varn);
			fprintf(fp, "sw %s, -%d($fp)\n", r1->name, offset);
			paranum ++;
			break;
			}
		case IR_ARG:
			{
			Reg r1 = getReg(code->u.one.op, 1, fp);
			fprintf(fp, "addi $sp, $sp, -4\n");
			fprintf(fp, "sw %s, 0($sp)\n", r1->name);
			argnum ++;
			break;
			}
		case IR_READ:
			{
			Reg r1 = getReg(code->u.one.op, 0, fp);
			fprintf(fp, "addi $sp, $sp, -4\n");
			fprintf(fp, "sw $ra, 0($sp)\n");
			fprintf(fp, "jal read\n");
			fprintf(fp, "move %s, $v0\n", r1->name);
			fprintf(fp, "lw $ra, 0($sp)\n");
			fprintf(fp, "addi $sp, $sp, 4\n");
			//**************************************modify
			addVar(r1->varn);
			int offset = getOffset(r1->varn);
			fprintf(fp, "sw %s, -%d($fp)\n", r1->name, offset);
			break;
			}
		case IR_WRITE:
			{
			Reg r1 = getReg(code->u.one.op, 1, fp);
			fprintf(fp, "addi $sp, $sp, -4\n");
			fprintf(fp, "sw $ra, 0($sp)\n");
			fprintf(fp, "move $a0, %s\n", r1->name);
			fprintf(fp, "jal write\n");
			fprintf(fp, "lw $ra, 0($sp)\n");
			fprintf(fp, "addi $sp, $sp, 4\n");
			break;
			}
		default:
			break;
	}
}
