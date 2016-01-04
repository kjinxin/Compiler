#include "intercode.h"

InterCode c_head = NULL;
InterCode c_tail = NULL;

int varnum = 1;
int labnum = 1;

// insert an intercode into the list
void insertCode(InterCode code)
{
	code->pre = NULL;
	code->next = NULL;
	if (c_head == NULL)
	{
		c_head = code;
		c_tail = code;
	}
	else
	{
		code->pre = c_tail;
		c_tail->next = code;
		c_tail = code;
	}
}

// delete an intercode from the list
void deleteCode(InterCode code)
{
	if (code == c_head && code == c_tail)
	{
		c_head = NULL;
		c_tail = NULL;
		free(code);
	}
	else if (code == c_head)
	{
		c_head = c_head->next;
		c_head->pre = NULL;
		free(code);
	}
	else if (code == c_tail)
	{
		c_tail = c_tail->pre;
		c_tail->next = NULL;
		free(code);
	}
	else
	{
		code->pre->next = code->next;
		code->next->pre = code->pre;
	}
}

// print the intercode into the output file
void printCode(char* fname)
{
	rmcons();
	reptvar();
	return;
	FILE * f = fopen(fname, "w");
	if (f == NULL)
	{
		printf("open file error\n");
		return;
	}
	InterCode code = c_head;
	int i = 0;
	while (code != NULL)
	{
	       //printf("%d   %d\n", code->kind, i ++);
		switch (code->kind)
		{
			case IR_LABEL:
				fputs("LABEL ", f);
				printOperand(code->u.one.op, f);
				fputs(" :", f);
				break;
			case IR_FUNC:
				fputs("FUNCTION ", f);
				printOperand(code->u.one.op, f);
				fputs(" :", f);
				break;
			case IR_ASSIGN:
				printOperand(code->u.assign.left, f);
				fputs(" := ", f);
				printOperand(code->u.assign.right, f);
				break;
			case IR_ADD:
				printOperand(code->u.binop.result, f);
				fputs(" := ", f);
				printOperand(code->u.binop.op1, f);
				fputs(" + ", f);
				printOperand(code->u.binop.op2, f);
				break;
			case IR_MINUS:
				printOperand(code->u.binop.result, f);
				fputs(" := ", f);
				printOperand(code->u.binop.op1, f);
				fputs(" - ", f);
				printOperand(code->u.binop.op2, f);
				break;
			case IR_MUL:
				printOperand(code->u.binop.result, f);
				fputs(" := ", f);
				printOperand(code->u.binop.op1, f);
				fputs(" * ", f);
				printOperand(code->u.binop.op2, f);
				break;
			case IR_DIV:
				printOperand(code->u.binop.result, f);
				fputs(" := ", f);
				printOperand(code->u.binop.op1, f);
				fputs(" / ", f);
				printOperand(code->u.binop.op2, f);
				break;
			case IR_GOTO:
				fputs("GOTO ", f);
				printOperand(code->u.one.op, f);
				break;
			case IR_IFGOTO:
				fputs("IF ", f);
				printOperand(code->u.triop.x, f);
				fputs(" ", f);
				fputs(code->u.triop.relop, f);
				fputs(" ", f);
				printOperand(code->u.triop.y, f);
				fputs(" GOTO ", f);
				printOperand(code->u.triop.z, f);
				break;
			case IR_RETURN:
				fputs("RETURN ", f);
				printOperand(code->u.one.op, f);
				break;
			case IR_DEC:
				fputs("DEC ", f);
				printOperand(code->u.dec.op, f);
				char size[30];
				sprintf(size, "%d", code->u.dec.size);
				fputs(" ", f);
				fputs(size, f);
				break;
			case IR_CALL:
				//code->u.assign.left->u.value = "hahs";
				printOperand(code->u.assign.left, f);
				fputs(" := CALL ", f);
				printOperand(code->u.assign.right, f);
				break;
			case IR_PARAM:
				fputs("PARAM ", f);
				printOperand(code->u.one.op, f);
				break;
			case IR_ARG:
				fputs("ARG ", f);
				printOperand(code->u.one.op, f);
				break;
			case IR_READ:
				fputs("READ ", f);
				printOperand(code->u.one.op, f);
				break;
			case IR_WRITE:
				fputs("WRITE ", f);
				printOperand(code->u.one.op, f);
				break;
		}
		code = code->next;
		fputs("\n", f);
	}
}

// print the operand into the output file
void printOperand(Operand op, FILE* f)
{
	if (op == NULL) return;
	char var[30];
	memset(var, 0, sizeof(var));
	switch (op->kind)
	{
		case OP_VAR: case OP_VADDR:
			switch (op->type)
			{
				case T_NONE:
					break;
				case T_ADDR:
					fputs("&", f);
					break;
				case T_STAR:
					fputs("*", f);
					break;
			}
			fputs(op->u.value, f);
			break;
		case OP_TVAR: case OP_TADDR:
			sprintf(var, "%d", op->u.num);
			switch (op->type)
			{
				case T_NONE:
					fputs("t", f);
					break;
				case T_ADDR:
					fputs("&t", f);
					break;
				case T_STAR:
					fputs("*t", f);
					break;
			}
			fputs(var, f);
			break;
		case OP_CONS:
			fputs("#", f);
			fputs(op->u.value, f);
			break;
		case OP_FUNC:
			fputs(op->u.value, f);
			break;
		case OP_LABEL:
			fputs("label", f);
			sprintf(var, "%d", op->u.num);
			fputs(var, f);
			break;
	}
}

void rmcons()
{
	InterCode code = c_head;
	while (code != NULL)
	{
		if (code->kind == IR_ADD || code->kind == IR_MINUS || code->kind == IR_MUL || code->kind == IR_DIV)
		{
			if (code->u.binop.op1->kind == OP_CONS && code->u.binop.op2->kind == OP_CONS)
			{

				int cons1 = atoi(code->u.binop.op1->u.value);
				int cons2 = atoi(code->u.binop.op2->u.value);
				int result = 0;
				switch (code->kind)
				{
					case IR_ADD:
						result = cons1 + cons2;
						break;
					case IR_MINUS:
						result = cons1 - cons2;
						break;
					case IR_MUL:
						result = cons1 * cons2;
						break;
					case IR_DIV:
						result = cons1 / cons2;
						break;
				}
				if (code->u.binop.result->kind == OP_TVAR || code->u.binop.result->kind == OP_TADDR)
				{
					code->u.binop.result->kind = OP_CONS;
					code->u.binop.result->type = T_NONE;
					code->u.binop.result->u.value = malloc(32);
					sprintf(code->u.binop.result->u.value, "%d", result);
					InterCode temp = code;
					code = code->next;
					deleteCode(temp);
					continue;
				}	
			}
		}
		code = code->next;
	}
	//printf("rmcons\n");
}

void reptvar()
{
	InterCode code = c_head;
	while (code != NULL)
	{
		if (code->kind == IR_ASSIGN && code->u.assign.right->kind == OP_TVAR && code->u.assign.left->type != T_STAR)
		{
			code->u.assign.right->kind = code->u.assign.left->kind;
			code->u.assign.right->type = code->u.assign.left->type;
			/*if (code->u.assign.left->kind == OP_VAR)
				code->u.assign.right->u.value = code->u.assign.left->u.value;
			if (code->u.assign.left->kind == OP_TVAR)
				code->u.assign.right->u.num = code->u.assign.left->u.num;*/
			code->u.assign.right->u = code->u.assign.left->u;
			InterCode temp = code;
			code = code->next;
			deleteCode(temp);
			continue;
		}
		code = code->next;
	}
}
