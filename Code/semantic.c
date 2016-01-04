#include "semantic.h"

// High-level definitions anlysis
void Program(node* tnode)
{	
	/*
	 * Program	:	ExtDefList
	 * 		;
	 */
	initHash();
        if (tnode->child != NULL)
	{
		ExtDefList(tnode->child);
	}
	checkfunc();
}

void ExtDefList(node* tnode)
{
	/*
	 * ExtDefList	:	ExtDef	ExtDefList
	 * 		|	
	 * 		;
	 */
	if (tnode == NULL) return;
	node* child = tnode->child;
	if (child != NULL)
	{
		ExtDef(child);
		ExtDefList(child->brother);
	}
}

void ExtDef(node* tnode)
{
	/*
	 * ExtDef	:	Specifier ExtDecList SEMI
	 * 		|	Specifier SEMI
	 * 		|	Specifier FunDec SEMI
	 * 		|	Specifier FunDec CompSt
	 * 		;	
	 */
	node* child = tnode->child;
        Type type = Specifier(child);
        child = child->brother;
        if (!strcmp(child->name, "ExtDecList"))
	{
		ExtDecList(type, child);
	}
        else
	if (!strcmp(child->name, "FunDec"))
	{
		tdepth++;
		FuncList f = FuncDec(type, child);
		child = child->brother;
		Hash_func_ele func = malloc(sizeof(struct Hash_func_ele_));
		func->func = f;
		if (!strcmp(child->name, "SEMI"))
		{
			int error = insertFunc(func, 0);
			if (error)
			{
				printf("Error type 19 at Line %d: Inconsistent declaration of function \"%s\"\n", f->row, f->name);
			}
		}
		else
		{
			int error = insertFunc(func, 1);
			if (error == 1)
			{
				printf("Error type 4 at Line %d: Redefined function \"%s\"\n", f->row, f->name);
			}
			if (error == 2)
			{
				printf("Error type 19 at Line %d: Inconsistent declaration or definition of function %s\n", f->row, f->name);
			}
			//************************IR FUNCTION******************************************
			Operand funcop = malloc(sizeof(struct Operand_));
			funcop->kind = OP_FUNC;
			funcop->type = T_NONE;
			funcop->u.value = f->name;

			InterCode code = malloc(sizeof(struct InterCode_));
			code->kind = IR_FUNC;
			code->u.one.op = funcop;
			insertCode(code);
			FieldList para = f->para;
			while (para != NULL)
			{
				Operand paraop = malloc(sizeof(struct Operand_));
				paraop->kind = OP_VAR;
				paraop->type = T_NONE;
				paraop->u.value = para->name;
				InterCode pcode = malloc(sizeof(struct InterCode_));
				pcode->kind = IR_PARAM;
				pcode->u.one.op = paraop;
				insertCode(pcode);
				para = para->tail;
			}
			//*****************************************************************************
			tdepth++;
			CompSt(type, child);
			deleteEle();
			tdepth--;
		}
		deleteEle();
		tdepth--;
	}	
}

void ExtDecList(Type type, node* tnode)
{
	/*
	 * ExtDecList	:	VarDec
	 * 		|	VarDec	COMMA	ExtDecList
	 * 		;
	 */
	node* child = tnode->child;
        FieldList f = VarDec(type, child, 1);
	if (f != NULL && f->type->kind == 1)
	{
		//****************************IP array DEC**********************************************
		Operand op = malloc(sizeof(struct Operand_));
		op->kind = OP_VAR;
		op->type = T_NONE;
		op->u.value = f->name;
		InterCode deccode = malloc(sizeof(struct InterCode_));
		deccode->kind = IR_DEC;
		deccode->u.dec.op = op;
		deccode->u.dec.size = typeSize(f->type);
		insertCode(deccode);
		//**************************************************************************************
	}
	child = child->brother;
	if (child != NULL)
	{
		child = child->brother;
		ExtDecList(type, child);
	}
}


// Specifiers analysis
Type Specifier(node* tnode)
{
	/*
	 * Specifier	:	TYPE
	 * 		|	StructSpecifier
	 * 		;
	 */
	node* child = tnode->child;
	Type type;
	if (!strcmp(child->name, "TYPE"))
	{
		type = malloc(sizeof(struct Type_));
		type->kind = 0;
		if (!strcmp(child->value, "int"))
		{
			type->u.basic = TYPEINT;
		}
		else
		{
			type->u.basic = TYPEFLOAT;
		}

	}
	else
	{
		type = StructSpecifier(child);
	}
	return type;
}

Type StructSpecifier(node* tnode)
{
	/*
	 * StructSpecifier	:	STRUCT OptTag LC DefList RC
	 * 			|	STRUCT Tag
	 * 			;
	 */
	node* child = tnode->child;
	Type type = malloc(sizeof(struct Type_));
	type->kind = 2;
	type->u.structure = malloc(sizeof(struct FieldList_));
	child = child->brother;
	if (!strcmp(child->name, "OptTag") || !strcmp(child->name, "LC"))
	{
		FieldList f = malloc(sizeof(struct FieldList_));
		if (!strcmp(child->name, "OptTag"))
		{
			f->name = OptTag(child);
			child = child->brother;
		}
		else f->name = "";
		type->u.structure->name = f->name;
		child = child->brother;
		tdepth ++;
	
		type->u.structure->tail = DefList(child, 2);
		f->type = type;
		// delete the same layer of Hash_var
		deleteEle();
		tdepth --;
		//insert the new varible node f to Hash_var
		Hash_var_ele structvar = malloc(sizeof(struct Hash_var_ele_));
		structvar->var = f;
		structvar->isStruct = 1;
		structvar->depth = tdepth;
		int error = insertVar(structvar);
		//error information
		if (error)
		{
			printf("Error type 16 at Line %d: Duplicated struct name\"%s\".\n", tnode->row, f->name);
		}
		return type;
	}
	else
	if (!strcmp(child->name, "Tag"))
	{
		return Tag(child);
	}
}

char* OptTag(node* tnode)
{	
	/*
	 * OptTag	:	ID
	 * 		|
	 * 		;
	 */
	if (tnode->child != NULL)
		return tnode->child->value;   // return the definition name of the stucture
	return NULL;                          // the defined structure does not have a name
}

Type Tag(node* tnode)
{
	/*
	 * Tag	:	ID
	 * 	;
	 */
	//search whether the struture has been defined, if not then error, else return the structure type
	node* child = tnode->child;
	Hash_var_ele structvar = findVar(child->value);
	if (structvar == NULL || structvar->var->type->kind != 2)
	{
		printf("Error type 17 at Line %d: Undefined structure \"%s\".\n", child->row, child->value);
		return NULL;
	}
	return structvar->var->type;
}


// Declarators analysis
FieldList VarDec(Type type, node* tnode, int from)
{
	/*
	 * VarDec	:	ID
	 * 		|	VarDec LB INT RB
	 * 		;
	 */
	node* child = tnode->child;
	FieldList f;
	if (!strcmp(child->name, "ID"))
	{
		f = malloc(sizeof(struct FieldList_));
		f->name = child->value;
		f->type = type;
		Hash_var_ele var = malloc(sizeof(struct Hash_var_ele_));
		var->var = f;
		var->depth = tdepth;
		var->isStruct = 0;
		if (from == 3) var->isStruct = 3;
		int error = insertVar(var);
		if (error)
		{
			if (from == 1) 
				printf("Error type 3 at Line %d: Redefined variable \"%s\"\n", child->row, child->value);
			if (from == 2) 
				printf("Error type 15 at Line %d: Redefined field \"%s\".\n", child->row, child->value);
			if (from == 3)
				printf("Error type 3 at Line %d: Redefined function parameters \"%s\".\n", child->row, child->value);
			//return NULL;
		}
		//***************************IR structure DEC code***********************************
		/*
		if (from == 1 && type->kind == 2)
		{
			Operand decop = malloc(sizeof(struct Operand_));
			decop->kind = OP_VAR;
			decop->type = T_NONE;
			decop->u.name = f->name;
			InterCode deccode = malloc(sizeof(struct InterCode_));
			deccode->kind = IR_DEC;
			deccode->u.dec.op = decop;
			deccode->u.dec.size = typeSize(f->type);
			insertCode(deccode);
			printf("Sturct DeC\n");
		}
		//***********************************************************************************/
	}
	else
	{
		f = VarDec(type, child, from);
		if (f == NULL) return NULL;
		//if (f == NULL) return NULL;
		Type temp = f->type;
		child = child->brother;
		child = child->brother;
		Type t = malloc(sizeof(struct Type_));
		t->kind = 1;
		t->u.array.size = atoi(child->value);
		t->u.array.elem = type;
		//if it is the name of the arry; 
		//in addition, the end of an array type is its their original type like int, float,struct
		if (temp->kind != 1)
		{
			f->type = t;
		}
		else
		{
			// find the end of the array and insert the present dimension
			while(temp->u.array.elem->kind == 1)
			{
				temp = temp->u.array.elem;
			}
			temp->u.array.elem = t;
		}
	}
	return f;
}

FuncList FuncDec(Type type, node* tnode)
{
	/*
	 * FunDec	:	ID LP VarList RP
	 * 		|	ID LP RP
	 * 		;
	 */
	node* child = tnode->child;
	FuncList f = malloc(sizeof(struct FuncList_));
	f->name = child->value;
	f->row = child->row;
	f->type = type;
	f->para = NULL;
	child = child->brother;
	child = child->brother;
	if (!strcmp(child->name, "VarList"))
	{
		f->para = VarList(child);	
	}
	return f;

}

FieldList VarList(node* tnode)
{
	/*
	 * VarList	:	ParamDec COMMA VarList
	 * 		|	ParamDec
	 * 		;
	 */
	node* child = tnode->child;
	FieldList f = ParamDec(child);
	child = child->brother;
	if (child != NULL)
	{
		child = child->brother;
		FieldList tf = f;
		while (tf->tail != NULL)
		{
			tf = tf->tail;
		}
		tf->tail = VarList(child);
		// maybe have problem
	}
	return f;
}

FieldList ParamDec(node* tnode)
{
	/*
	 * ParamDec	:	Specifier VarDec
	 * 		;
	 */
	node* child = tnode->child;
	Type type = Specifier(child);
	return VarDec(type, child->brother, 3);
}

//Statements analysis
void CompSt(Type type, node* tnode)
{
	/*
	 * ComSt	:	LC DefList StmtList RC
	 * 		;
	 */
	node* child = tnode->child;
	child = child->brother;
	if (child != NULL)
	{
		
		if (!strcmp(child->name, "DefList")) 
		{
			DefList(child, 1);
			child = child->brother;
		}
		if (!strcmp(child->name, "StmtList"))
   			StmtList(type, child);
	}
}

void StmtList(Type type, node* tnode)
{
	/*
	 * StmtList	:	Stmt StmtList
	 * 		|
	 * 		;
	 */
	if (tnode == NULL) return;
	node* child = tnode->child;
	if (child != NULL)
	{
		Stmt(type, child);
		StmtList(type, child->brother);
	}
}

void Stmt(Type type, node* tnode)
{
	/*
	 * Stmt	:	Exp SEMI
	 * 	|	CompSt
	 * 	|	RETURN Exp SEMI
	 * 	|	IF LP Exp RP Stmt
	 * 	|	IF LP Exp RP Stmt ELSE Stmt
	 * 	|	WHILE LP Exp RP Stmt
	 * 	;
	 */
	node* child = tnode->child;
	if (child == NULL) return;
	if (!strcmp(child->name, "Exp"))
	{
		/*
		Operand op = malloc(sizeof(struct Operand_));
		op->kind = OP_TVAR;
		op->type = T_NONE;
		op->u.num = varnum ++;
		*/
		Exp(child, NULL);
	}
	else
	if (!strcmp(child->name, "CompSt"))
	{
		tdepth ++;
		CompSt(type, child);
		deleteEle();
		tdepth --;
	}
	else
	if (!strcmp(child->name, "RETURN"))
	{
		child = child->brother;
		//**************************IR return************************************
		Operand op = malloc(sizeof(struct Operand_));
		op->kind = OP_TVAR;
		op->type = T_NONE;
		op->u.num = varnum ++;
		Type t = Exp(child, op);
		InterCode code = malloc(sizeof(struct InterCode_));
		code->kind = IR_RETURN;
		code->u.one.op = op;
		insertCode(code);
		//************************************************************************
		if (t != NULL && isEqualType(type, t))
		{
			printf("Error type 8 at Line %d: Type mismatched for return.\n", child->row);
		}
	}
	else
	if (!strcmp(child->name, "IF"))
	{
		child = child->brother->brother;
		//**************************IR IF*****************************************
		Operand label1 = malloc(sizeof(struct Operand_));
		label1->kind = OP_LABEL;
		label1->u.num = labnum ++;
		label1->type = T_NONE;

		Operand label2 = malloc(sizeof(struct Operand_));
		label2->kind = OP_LABEL;
		label2->type = T_NONE;
		label2->u.num = labnum ++;

		Type t = translate_cond(child, label1, label2);

		InterCode code1 = malloc(sizeof(struct InterCode_));
		code1->kind = IR_LABEL;
		code1->u.one.op = label1;
		insertCode(code1);

		child = child->brother->brother;
		Stmt(type, child);

		child = child->brother;
		if (child != NULL)
		{
		//***************************IR IF ELSE***************************************
			Operand label3 = malloc(sizeof(struct Operand_));
			label3->kind = OP_LABEL;
			label3->u.num = labnum ++;
			label3->type = T_NONE;

			InterCode code3 = malloc(sizeof(struct InterCode_));
			code3->kind = IR_GOTO;
			code3->u.one.op = label3;
			insertCode(code3);

			InterCode code2 = malloc(sizeof(struct InterCode_));
			code2->kind = IR_LABEL;
			code2->u.one.op = label2;
			insertCode(code2);

			Stmt(type, child->brother);

			InterCode code4 = malloc(sizeof(struct InterCode_));
			code4->kind = IR_LABEL;
			code4->u.one.op = label3;
			insertCode(code4);
		}
		else
		{
			InterCode code2 = malloc(sizeof(struct InterCode_));
			code2->kind = IR_LABEL;
			code2->u.one.op = label2;
			insertCode(code2);
		}
		//************************************************************************
		if (t != NULL && !((t->kind == 0 || t->kind == 3) && t->u.basic == TYPEINT))
		{
			printf("Error type ? at Line %d: Error judge condition\n", child->row);
		}
	}
	else
	if (!strcmp(child->name, "WHILE"))
	{
		//****************************IR WHILE**************************************
		child = child->brother->brother;

		Operand label1 = malloc(sizeof(struct Operand_));
		label1->kind = OP_LABEL;
		label1->type = T_NONE;
		label1->u.num = labnum ++;

		Operand label2 = malloc(sizeof(struct Operand_));
		label2->kind = OP_LABEL;
		label2->type = T_NONE;
		label2->u.num = labnum ++;

		Operand label3 = malloc(sizeof(struct Operand_));
		label3->kind = OP_LABEL;
		label3->type = T_NONE;
		label3->u.num = labnum ++;

		InterCode code1 = malloc(sizeof(struct InterCode_));
		code1->kind = IR_LABEL;
		code1->u.one.op = label1;

		InterCode code2 = malloc(sizeof(struct InterCode_));
		code2->kind = IR_LABEL;
		code2->u.one.op = label2;

		InterCode code3 = malloc(sizeof(struct InterCode_));
		code3->kind = IR_LABEL;
		code3->u.one.op = label3;

		insertCode(code1);
		Type t = translate_cond(child, label2, label3);
		insertCode(code2);
		child = child->brother->brother;
		Stmt(type, child);
		InterCode code4 = malloc(sizeof(struct InterCode_));
		code4->kind = IR_GOTO;
		code4->u.one.op = label1;
		insertCode(code4);
		insertCode(code3);
		//***********************************************************************
		if (t != NULL && !((t->kind == 0 || t->kind == 3) && t->u.basic == TYPEINT))
		{
			printf("Error type ? at Line %d: Error judge condition\n", child->row);
		}
	}
}

// Local Definitions analysis
FieldList DefList(node* tnode, int from)
{
	/*
	 * DefList	:	Def DefList
	 * 		|	
	 * 		;
	 */
	if (tnode == NULL) return NULL;
	node* child = tnode->child;
	if (child != NULL)
	{
		FieldList f = Def(child, from);
		child = child->brother;
		if (f == NULL)
		{
			f = DefList(child, from);
			return f;			
		}
		FieldList tf = f;
		while (tf->tail != NULL)
		{
			tf = tf->tail;
		}
		tf->tail = DefList(child, from);
		return f;
	}
	return NULL;
}

FieldList Def(node* tnode, int from)
{
	/*
	 * Def	:	Specifier DecList SEMI
	 * 	;
	 */
	node* child = tnode->child;
	Type type = Specifier(child);
	child = child->brother;
	return DecList(type, child, from);
}

FieldList DecList(Type type, node* tnode, int from)
{
	/*
	 * DecList	:	Dec
	 * 		|	Dec COMMA DecList
	 * 		;
	 */
	node* child = tnode->child;
	FieldList f = Dec(type, child, from);
	child = child->brother;
	if (child != NULL)
	{
		child = child->brother;
		if (f == NULL)
		{
			f = DecList(type, child, from);
			return f;
		}
		FieldList tf = f;
		while (tf->tail != NULL)
		{
			tf = tf->tail;
		}
		tf->tail = DecList(type, child, from);
	}
	return f;
}

FieldList Dec(Type type, node* tnode, int from)
{
	/*
	 * Dec	:	VarDec
	 * 	|	VarDec	ASSIGNOP Exp
	 * 	;
	 */
	node* child = tnode->child;
	FieldList f = VarDec(type, child, from);
	if (from == 1 && f->type->kind == 1)
	{
	//*******************************local IR array***************************************
		Operand op = malloc(sizeof(struct Operand_));
		op->kind = OP_VAR;
		op->type = T_NONE;
		op->u.value = f->name;

		InterCode deccode = malloc(sizeof(struct InterCode_));
		deccode->kind = IR_DEC;
		deccode->u.dec.op = op;
		deccode->u.dec.size = typeSize(f->type);
		insertCode(deccode);
	//**************************************************************************************
	}

	//***************************IR structure DEC code***********************************
	if (from == 1 && f->type->kind == 2)
	{
		Operand decop = malloc(sizeof(struct Operand_));
		decop->kind = OP_VAR;
		decop->type = T_NONE;
		decop->u.name = f->name;
		InterCode deccode = malloc(sizeof(struct InterCode_));
		deccode->kind = IR_DEC;
		deccode->u.dec.op = decop;
		deccode->u.dec.size = typeSize(f->type);
		insertCode(deccode);
	}
	//***********************************************************************************
	child = child->brother;
	if (child != NULL)
	{
		if (from == 2)
		{
			printf("Error type 15 at Line %d: initialize member elements in struct\n", child->row);
		}
		child = child->brother;
	//***************************IR DEC assign***********************************************
		Operand op = malloc(sizeof(struct Operand_));
		op->kind = OP_TVAR;
		op->type = T_NONE;
		op->u.num = varnum ++;

		Operand result = malloc(sizeof(struct Operand_));
		result->kind = OP_VAR;
		result->type = T_NONE;
		result->u.value = f->name;
		Type t = Exp(child, op);

                InterCode code = malloc(sizeof(struct InterCode_));
		code->kind = IR_ASSIGN;
		code->u.assign.left = result;
		code->u.assign.right = op;
		insertCode(code);

		if (isEqualType(t, f->type))
		{
			printf("Error type 5 at Line %d: Type mismatched for assignment.\n", child->row);
		}

	}
	return f;
}

// Expressions analysis
Type Exp(node* tnode, Operand place)
{
	/*
	 * Exp	:	Exp ASSIGNOP Exp
	 * 	|	Exp AND Exp
	 * 	|	Exp OR Exp
	 * 	|	Exp RELOP Exp
	 * 	|	Exp PLUS Exp
	 * 	|	Exp MINUS Exp
	 * 	|	Exp STAR Exp
	 * 	|	Exp DIV	Exp
	 * 	|	LP Exp Rp
	 * 	|	MINUS Exp
	 * 	|	NOT Exp
	 * 	|	ID LP Args RP
	 * 	|	ID LP RP
	 * 	|	Exp DOT ID
	 * 	|	ID
	 * 	|	INT
	 * 	|	FLOAT
	 * 	;
	 */
	node* child = tnode->child;
	if (!strcmp(child->name, "Exp"))
	{	
		if (!strcmp(child->brother->name, "ASSIGNOP"))
		{
			node* childT = child->child;
			Operand  leftv = malloc(sizeof(struct Operand_));
			if (strcmp(childT->name, "ID") == 0 && childT->brother == NULL)
			{
				leftv->kind = OP_TVAR;
				leftv->type = T_NONE;
				leftv->u.num = varnum ++;
			}
			else if (strcmp(childT->name, "Exp") == 0 && childT->brother != NULL && strcmp(childT->brother->name, "LB") == 0)
			{
				leftv->kind = OP_TADDR;
				leftv->type = T_STAR;
				leftv->u.num = varnum ++;
				//leftv->type = T_STAR;

			}
			else if (strcmp(childT->name, "Exp") == 0 && childT->brother != NULL && strcmp(childT->brother->name, "DOT") == 0){
			
				leftv->kind = OP_TADDR;
				leftv->type = T_STAR;
				leftv->u.num = varnum ++;
				//leftv->type = T_STAR;
			}
			else 
			{
				printf("Error type 6 at Line %d: The left-hand side of an assignment must be a variable.\n", child->row);
			}

				Type t1 = Exp(child, leftv);
				Operand rightv = malloc(sizeof(struct Operand_));
				rightv->kind = OP_TVAR;
				rightv->type = T_NONE;
				rightv->u.num = varnum ++;
				child = child->brother->brother;

				Type t2 = Exp(child, rightv);

				InterCode code1 = malloc(sizeof(struct InterCode_));
				code1->kind = IR_ASSIGN;
				code1->u.assign.left = leftv;
				code1->u.assign.right = rightv;
				insertCode(code1);

				if (place != NULL)
				{
				        Operand tplace = malloc(sizeof(struct InterCode_));
				        tplace->kind = OP_TVAR;
			                tplace->type = T_NONE;
				        tplace->u.value = place->u.value;

	                                InterCode code2 = malloc(sizeof(struct InterCode_));
				        code2->kind = IR_ASSIGN;
				        code2->u.assign.left = tplace;
				        code2->u.assign.right = leftv;
				}

			/*
			if (t1 != NULL && t1->kind == 3)
			{
				printf("Error type 6 at Line %d: The left-hand side of an assignment must be a variable.\n", child->row);
			}
			*/
			// modify lab2
			/*if (!(strcmp(childT->name, "ID") == 0 && childT->brother == NULL || strcmp(childT->name, "Exp") == 0 && childT->brother != NULL && strcmp(childT->brother->name, "LB") == 0 || strcmp(childT->name, "Exp") == 0 && childT->brother != NULL && strcmp(childT->brother->name, "DOT") == 0))
			{
				printf("Error type 6 at Line %d: The left-hand side of an assignment must be a variable.\n", child->row);
			}*/
			if (t1 != NULL && t2 != NULL && isEqualType(t1, t2))
			{
				printf("Error type 5 at Line %d: Type mismatched for assignment.\n", child->row);
				return NULL;
			}
			return t1;
		} 
		if (!strcmp(child->brother->name, "AND") || !strcmp(child->brother->name, "OR") || !strcmp(child->brother->name, "RELOP"))
		{
			Operand label1 = malloc(sizeof(struct Operand_));
			label1->kind = OP_LABEL;
			label1->type = T_NONE;
			label1->u.num = labnum ++;

			Operand label2 = malloc(sizeof(struct Operand_));
			label2->kind = OP_LABEL;
			label2->type = T_NONE;
			label2->u.num = labnum ++;

			Operand cons = malloc(sizeof(struct Operand_));
			cons->kind = OP_CONS;
			cons->type = T_NONE;
			cons->u.value = malloc(32);
			strcpy(cons->u.value, "0");

			if (place != NULL)
			{
				Operand place1 = malloc(sizeof(struct Operand_));
				place1->kind = place->kind;
				place1->type = place->type;
				place1->u = place->u;
				InterCode code0 = malloc(sizeof(struct InterCode_));
				code0->kind = IR_ASSIGN;
				code0->u.assign.left = place1;
				code0->u.assign.right = cons;
				insertCode(code0);
			}

			Type tt = translate_cond(tnode, label1, label2);
			InterCode code1 = malloc(sizeof(struct InterCode_));
			code1->kind = IR_LABEL;
			code1->u.one.op = label1;
			insertCode(code1);

			Operand cons1 = malloc(sizeof(struct Operand_));
			cons1->kind = OP_CONS;
			cons1->type = T_NONE;
			cons1->u.value = malloc(32);
			strcpy(cons1->u.value, "1");

			if (place != NULL)
			{

				Operand place2 = malloc(sizeof(struct Operand_));
				place2->kind = place->kind;
				place2->type = place->type;
				place2->u = place->u;
				InterCode code2 = malloc(sizeof(struct InterCode_));
				code2->kind = IR_ASSIGN;
				code2->u.assign.left = place2;
				code2->u.assign.right = cons1;
				insertCode(code2);
			}

			InterCode code3 = malloc(sizeof(struct InterCode_));
			code3->kind = IR_LABEL;
			code3->u.one.op = label2;
			insertCode(code3);
			return tt;
			/*
			Type t1 = Exp(child, NULL);
			child = child->brother->brother;
			Type t2 = Exp(child, NULL);
			if (t1 != NULL && (t1->kind == 0 || t1->kind == 3) && t1->u.basic == TYPEINT)
			{
				// if these two share the same type, then return the right left value type
				if (t2 != NULL && (t2->kind == 0 && t2->kind == 3) && t2->u.basic == TYPEINT)
				{
					return t1;
				}
			}
			printf("Error type 7 at Line %d: illegal use of logical operands.\n", child->row);
			*/
		}
		if (!strcmp(child->brother->name, "PLUS") || !strcmp(child->brother->name, "MINUS") || !strcmp(child->brother->name, "STAR") || !strcmp(child->brother->name, "DIV"))
		{
		//*************************************************IP PLUS, MINUS, STAR, DIV*****************************

			Operand op1 = malloc(sizeof(struct Operand_));
			op1->kind = OP_TVAR;
			op1->type = T_NONE;
			op1->u.num = varnum ++;

			Operand op2 = malloc(sizeof(struct Operand_));
			op2->kind = OP_TVAR;
			op2->type = T_NONE;
			op2->u.num = varnum ++;
			//printf("%dzhatian\n", varnum);	
		//*******************************************************************************************************
			node* nnode = child->brother;
			Type t1 = Exp(child, op1);
			child = child->brother->brother;
			Type t2 = Exp(child, op2);

			if (t1 != NULL && t2 != NULL)
			if ((t1->kind == 0 || t1->kind == 3) && (t2->kind == 0 || t2->kind == 3) && t1->u.basic == t2->u.basic)
			{
				InterCode code = malloc(sizeof(struct InterCode_));
				if (!strcmp(nnode->name, "PLUS"))
					code->kind = IR_ADD;
				else
				if (!strcmp(nnode->name, "MINUS"))
					code->kind = IR_MINUS;
				else
				if (!strcmp(nnode->name, "STAR"))
					code->kind = IR_MUL;
				else
				if (!strcmp(nnode->name, "DIV"))
					code->kind = IR_DIV;

				if (place != NULL)
				{
				        code->u.binop.result = place;
				        code->u.binop.op1 = op1;
			          	code->u.binop.op2 = op2;
				        insertCode(code);
				}
				return t1;
			}
			if (t1 != NULL && t2 != NULL)
				printf("Error type 7 at Line %d: Type mismatched for operands.\n", child->row);
			return NULL;
		}
		if (!strcmp(child->brother->name, "LB"))
		{
			Operand op0 = malloc(sizeof(struct Operand_));
			op0->kind = OP_TADDR;
			op0->type = T_NONE;
			op0->u.num = varnum ++;
			Type t1 = Exp(child, op0);
			child = child->brother->brother;
			if (t1->kind != 1)
			{
				printf("Error type 10 at Line %d: common variables use [] array operation\n", child->row);
				return NULL;
			}
			else
			{	
				Operand op1 = malloc(sizeof(struct Operand_));
				op1->kind = OP_TVAR;
				op1->type = T_NONE;
				op1->u.num = varnum ++;

				Type t2 = Exp(child, op1);
				
				Operand cons = malloc(sizeof(struct Operand_));
				cons->kind = OP_CONS;
				cons->type = T_NONE;
				cons->u.value = malloc(32);
				int size = typeSize(t1->u.array.elem);
				sprintf(cons->u.value, "%d", size);
				
				Operand tempop = malloc(sizeof(struct Operand_));
				tempop->kind = OP_TADDR;
				tempop->type = T_NONE;
				tempop->u.num = varnum ++;

				InterCode code1 = malloc(sizeof(struct InterCode_));
				code1->kind = IR_MUL;
				code1->u.binop.result = tempop;
				code1->u.binop.op1 = op1;
				code1->u.binop.op2 = cons;
				insertCode(code1);

				if (place != NULL)
				{
					if (place->kind != OP_TADDR && place->kind != OP_VADDR)
					{
						place->kind = OP_TADDR;
						place->type = T_STAR;
					}

					Operand tplace = malloc(sizeof(struct Operand_));
					tplace->kind = OP_TADDR;
					tplace->type = T_NONE;
					tplace->u.value = place->u.value;

					InterCode code2 = malloc(sizeof(struct InterCode_));
					code2->kind = IR_ADD;
					code2->u.binop.result = tplace;
					code2->u.binop.op1 = op0;
					code2->u.binop.op2 = tempop;
					insertCode(code2);
				}

				if ((t2->kind == 0 || t2->kind == 3) && t2->u.basic == TYPEINT)
				{
					
					return t1->u.array.elem;
				}
				else
				{
					printf("Error type 12 at Line %d: something not integer appears in []\n", child->row);
					return NULL;
				}
			}

		}
		if (!strcmp(child->brother->name, "DOT"))
		{
		//********************************************IR struct***********************************
			Operand op1 = malloc(sizeof(struct Operand_));
			op1->kind = OP_TADDR;
			op1->type = T_NONE;
			op1->u.num = varnum ++;

			Type t1 = Exp(child, op1);
			child = child->brother->brother;
			if (t1->kind != 2)
			{
				printf("Error type 13 at Line %d: Illegal use of \".\".\n", child->row);
				return NULL;
			}
			else
			{
				char* name2 = child->value;
				FieldList ft = t1->u.structure->tail;
				int size = 0;
				while (ft != NULL)
				{
					if (!strcmp(ft->name, name2))
					{
						Operand op2 = malloc(sizeof(struct Operand_));
						op2->kind = OP_CONS;
						op2->type = T_NONE;
						op2->u.value = malloc(30);
						sprintf(op2->u.value, "%d", size);

						if (place != NULL)
						{
							if (place->kind != OP_TADDR && place->kind != OP_VADDR)
							{
								place->kind = OP_TADDR;
								place->type = T_STAR;
							}

							Operand op3 = malloc(sizeof(struct Operand_));
							op3->kind = OP_TADDR;
							op3->type = T_NONE;
							op3->u.value = place->u.value;
	
							InterCode code = malloc(sizeof(struct InterCode_));
							code->kind = IR_ADD;
							code->u.binop.result = op3;
							code->u.binop.op1 = op1;
							code->u.binop.op2 = op2;
							insertCode(code);
						}
						return ft->type;
					}
					size += typeSize(ft->type);
					ft = ft->tail;
				}
				printf("Error type 14 at Line %d: Non-existent field \"%s\".\n", child->row, name2);
				return NULL;
			}
		}
	}
	else
	if (!strcmp(child->name, "LP"))
	{
		child = child->brother;
		return Exp(child, place);
	}
	else
	if (!strcmp(child->name, "MINUS"))
	{
	//*************************************IR MINUS************************************
		child = child->brother;
		Operand op1 = malloc(sizeof(struct Operand_));
		op1->kind = OP_TVAR;
		op1->type = T_NONE;
		op1->u.num = varnum ++;

		Operand op2 = malloc(sizeof(struct Operand_));
		op2->kind = OP_CONS;
		op2->type = T_NONE;
		op2->u.value = malloc(32);
		strcpy(op2->u.value, "0");

		Type t = Exp(child, op1);
		if (place != NULL)
		{
		        InterCode code = malloc(sizeof(struct InterCode_));
	        	code->kind = IR_MINUS;
	        	code->u.binop.op1 = op2;
	        	code->u.binop.op2 = op1;
	        	code->u.binop.result = place;
	        	insertCode(code);
		}
		if (t->kind == 0 || t->kind == 3)
		{	
			return t;
		}
		else
		{
			printf("Error type 7 at Line %d: Operatinos type mismatched\n", child->row);
			return NULL;
		}
	}
	else
	if (!strcmp(child->name, "NOT"))
	{

		Operand label1 = malloc(sizeof(struct Operand_));
		label1->kind = OP_LABEL;
		label1->type = T_NONE;
		label1->u.num = labnum ++;

		Operand label2 = malloc(sizeof(struct Operand_));
		label2->kind = OP_LABEL;
		label2->type = T_NONE;
		label2->u.num = labnum ++;

		Operand cons = malloc(sizeof(struct Operand_));
		cons->kind = OP_CONS;
		cons->type = T_NONE;
		cons->u.value = malloc(32);
		strcpy(cons->u.value, "0");

		if (place != NULL)
		{
			InterCode code0 = malloc(sizeof(struct InterCode_));
			code0->kind = IR_ASSIGN;
			code0->u.assign.left = place;
			code0->u.assign.right = cons;
			insertCode(code0);
		}

		Type t = translate_cond(tnode, label1, label2);
		InterCode code1 = malloc(sizeof(struct InterCode_));
		code1->kind = IR_LABEL;
		code1->u.one.op = label1;
		insertCode(code1);

		Operand cons1 = malloc(sizeof(struct Operand_));
		cons1->kind = OP_CONS;
		cons1->type = T_NONE;
		cons1->u.value = malloc(32);
		strcpy(cons1->u.value, "1");
		if (place != NULL)
		{
			InterCode code2 = malloc(sizeof(struct InterCode_));
			code2->kind = IR_ASSIGN;
			code2->u.assign.left = place;
			code2->u.assign.right = cons1;
			insertCode(code2);
		}

		InterCode code3 = malloc(sizeof(struct InterCode_));
		code3->kind = IR_LABEL;
		code3->u.one.op = label2;
		insertCode(code3);

		child = child->brother;
		//Type t = Exp(child);
		if ((t->kind == 0 || t->kind == 3) && t->u.basic == TYPEINT)
		{
		
			return t;
		}
		else
		{
			printf("Error type 7 at Line %d: Operations type mismatched\n", child->row);
			return NULL;
		}
	}
	else
	if (!strcmp(child->name, "ID"))
	{
		if (child->brother == NULL)
		{
			Hash_var_ele var = findVar(child->value);
			if (var != NULL)
			{
			//*************************************************IR ID********************************
			/*	
				Operand right = malloc(sizeof(struct Operand_));
				right->kind = OP_TVAR;
				right->type = T_NONE;
				right->u.value = var->var->name;
				InterCode assign = malloc(sizeof(struct InterCode_));
				assign->kind = IR_ASSIGN;
				assign->u.assign.left = place;
				assign->u.assign.right = right;
				insertCode(assign);
			*/
				if (place != NULL)
				{
					if (var->isStruct == 3)
					{
						place->kind = OP_VADDR;
						place->type = T_NONE;
						place->u.value = child->value;
					}
					else
					if (!(place->kind == OP_TADDR || place->kind == OP_VADDR))
					{
						place->kind = OP_VAR;
						place->type = T_NONE;
						place->u.value = child->value;
					}
					else
					{	
						Operand right = malloc(sizeof(struct Operand_));
						right->kind = OP_VAR;
						right->type = T_ADDR;
						right->u.value = child->value;
                                         
						if (place != NULL)
						{
						        InterCode assign = malloc(sizeof(struct InterCode_));
					        	assign->kind = IR_ASSIGN;
					        	assign->u.assign.left = place;
					        	assign->u.assign.right = right;
					        	insertCode(assign);
						}
					}
				}
			//****************************************************************************************
				return var->var->type;
			}
			else 
			{
				printf("Error type 1 at Line %d: Using undefined variables %s\n", child->row, child->value);
				return NULL;
			}
		}
		else
		{
			//******************************************IR function **********************************
			Hash_func_ele func = findFunc(child->value);
			Hash_var_ele var = findVar(child->value);
			if (var != NULL && func == NULL)
			{
				printf("Error type 11 at Line %d: Common variable \"%s\" use () function operation\n", child->row, child->value);
				return NULL;
			}
			if (func == NULL || func->func->isDefined == 0)
			{
				printf("Error type 2 at LIne %d: undefined function \"%s\"\n",child->row, child->value);
				return NULL;
			}
			FieldList para = func->func->para;
			child = child->brother;
			child = child->brother;
			if (!strcmp(child->name, "RP"))
			{
				//**********************************ID LP RP************************************
				if (!strcmp(func->func->name, "read"))
				{
					if (place != NULL)
					{
						InterCode code = malloc(sizeof(struct InterCode_));
						code->kind = IR_READ;
						code->u.one.op = place;
						insertCode(code);
					}
				}
				else
				{
					if (place != NULL)
					{
						Operand funcn = malloc(sizeof(struct Operand_));
						funcn->kind = OP_FUNC;
						funcn->type = T_NONE;
						funcn->u.value = func->func->name;
						InterCode code = malloc(sizeof(struct InterCode_));
						code->kind = IR_CALL;
						code->u.assign.left = place;
						code->u.assign.right = funcn;
						insertCode(code);
					}
					else
					{
						
						Operand funcn = malloc(sizeof(struct Operand_));
						funcn->kind = OP_FUNC;
						funcn->type = T_NONE;
						funcn->u.value = func->func->name;
						Operand left = malloc(sizeof(struct Operand_));
						left->kind = OP_TVAR;
						left->type = T_NONE;
						left->u.num = varnum ++;
						InterCode code = malloc(sizeof(struct InterCode_));
						code->kind = IR_CALL;
						code->u.assign.left = left;
						code->u.assign.right = funcn;
						insertCode(code);
					}
				}
				if (para != NULL)
				{
					printf("Error type 9 at Line %d: parameters unmatched in function %s\n", child->row, func->func->name);
				}
			}
			else
			{
			//*******************************IR function with args***********************************
				Operand arg_list = malloc(sizeof(struct Operand_));
				if (Args(child, para, arg_list))
				{
					printf("Error type 9 at Line %d: parameters unmatched in function %s\n", child->row, func->func->name);
				}
				arg_list = arg_list->next;
				if (!strcmp(func->func->name, "write"))
				{
					InterCode code = malloc(sizeof(struct InterCode_));
					code->kind = IR_WRITE;
					code->u.one.op = arg_list;
					insertCode(code);
				}
				else
				{
					while (arg_list != NULL)
					{
						InterCode code = malloc(sizeof(struct InterCode_));
						code->kind = IR_ARG;
						code->u.one.op = arg_list;
						insertCode(code);
						arg_list = arg_list->next;
					}

					Operand funcn = malloc(sizeof(struct Operand_));
					funcn->kind = OP_FUNC;
					funcn->type = T_NONE;
					funcn->u.value = func->func->name;

					//Operand left = malloc(sizeof(struct Operand_));
					//left->kind = OP_TVAR;
					//left->type = T_NONE;
					//left->u.num = place->u.num;

					if (place == NULL)
					{
						place = malloc(sizeof(struct Operand_));
						place->kind = OP_TVAR;
						place->type = T_NONE;
						place->u.num = varnum ++;
					}
				        InterCode code = malloc(sizeof(struct InterCode_));
				        code->kind = IR_CALL;
				        code->u.assign.left = place;
				        code->u.assign.right = funcn;
				        insertCode(code);
				}
			}
			return func->func->type;

		}
	}
	else
	if (!strcmp(child->name, "INT"))
	{
		/*
		Operand right = malloc(sizeof(struct Operand_));
		right->kind = OP_CONS;
		right->type = T_NONE;
		right->u.value = malloc(20);
		strcpy(right->u.value, child->value);
		InterCode assign = malloc(sizeof(struct InterCode_));
		assign->kind = IR_ASSIGN;
		assign->u.assign.left = place;
		assign->u.assign.right = right;
		insertCode(assign);
		*/
		if (place != NULL)
		{
			place->kind = OP_CONS;
			place->type = T_NONE;
			place->u.value = child->value;
		}
		//printf("heheh%s\n", child->value);
		Type t = malloc(sizeof(struct Type_));
		t->kind = 3;
		t->u.basic = TYPEINT;
		return t;
	}
	else
	if (!strcmp(child->name, "FLOAT"))
	{
		/*
		Operand right = malloc(sizeof(struct Operand_));
		right->kind = OP_CONS;
		right->type = T_NONE;
		right->u.value = malloc(20);
		strcpy(right->u.value, child->value);
		InterCode assign = malloc(sizeof(struct InterCode_));
		assign->kind = IR_ASSIGN;
		assign->u.assign.left = place;
		assign->u.assign.right = right;
		insertCode(assign);
		*/
		if (place != NULL)
		{
			place->kind = OP_CONS;
			place->type = T_NONE;
			place->u.value = child->value;
		}
		Type t = malloc(sizeof(struct Type_));
		t->kind = 3;
		t->u.basic = TYPEFLOAT;
		return t;
	}

}

int Args(node* tnode, FieldList f, Operand arg_list)
{
	/*
	 * Args	:	Exp COMMA Args
	 * 	|	Exp
	 * 	;
	 */
	if (tnode == NULL && f == NULL) return 0;
	if (tnode == NULL || f == NULL) return 1;
	node* child = tnode->child;
	Operand op = malloc(sizeof(struct Operand_));
	if (f->type->kind == 1 || f->type->kind == 2)
		op->kind = OP_TADDR;
	else
		op->kind = OP_TVAR;
	op->type = T_NONE;
	op->u.num = varnum ++;
	
	Type t = Exp(child, op);

	op->next = arg_list->next;
	arg_list->next = op;

	if (isEqualType(t, f->type)) return 1;
	child = child->brother;
	if (child != NULL)
	return Args(child->brother, f->tail, arg_list);
	else
	if (f->tail == NULL) return 0;
	return 1;
}

Type translate_cond(node* tnode, Operand label_true, Operand label_false)
{
	node* child = tnode->child;
	if (!strcmp(child->name, "Exp"))
	{
		//printf("%s\n", child->brother->value);
		node* child1 = child;
		child = child->brother;
		if (!strcmp(child->name, "RELOP"))
		{
			Operand t1 = malloc(sizeof(struct Operand_));
			t1->kind = OP_TVAR;
			t1->type = T_NONE;
			t1->u.num = varnum ++;

			Operand t2 = malloc(sizeof(struct Operand_));
			t2->kind = OP_TVAR;
			t2->type = T_NONE;
			t2->u.num = varnum ++;

			Type tt1 = Exp(child1, t1);
			Type tt2 = Exp(child->brother, t2);

			InterCode code1 = malloc(sizeof(struct InterCode_));
			code1->kind = IR_IFGOTO;
			code1->u.triop.z = label_true;
			code1->u.triop.x = t1;
			code1->u.triop.y = t2;
			code1->u.triop.relop = child->value;
			insertCode(code1);

			InterCode code2 = malloc(sizeof(struct InterCode_));
			code2->kind = IR_GOTO;
			code2->u.one.op = label_false;
			insertCode(code2);
			return tt1;
		}
		else
		if (!strcmp(child->name, "AND"))
		{
			Operand label1 = malloc(sizeof(struct Operand_));
			label1->kind = OP_LABEL;
			label1->type = T_NONE;
			label1->u.num = labnum ++;

			Type tt1 = translate_cond(child1, label1, label_false);

			InterCode code = malloc(sizeof(struct InterCode_));
			code->kind = IR_LABEL;
			code->u.one.op = label1;
			insertCode(code);

			Type tt2 = translate_cond(child->brother, label_true, label_false);
			return tt1;
		}
		else
		if (!strcmp(child->name, "OR"))
		{	
			Operand label1 = malloc(sizeof(struct Operand_));
			label1->kind = OP_LABEL;
			label1->type = T_NONE;
			label1->u.num = labnum ++;

			Type tt1 = translate_cond(child1, label_true, label1);

			InterCode code = malloc(sizeof(struct InterCode_));
			code->kind = IR_LABEL;
			code->u.one.op = label1;
			insertCode(code);

			Type tt2 = translate_cond(child->brother, label_true, label_false);
			return tt1; 
		}
	}
	else
	if (!strcmp(child->name, "NOT"))
	{
		return translate_cond(child->brother, label_false, label_true);
	}

	Operand t1 = malloc(sizeof(struct Operand_));
	t1->kind = OP_TVAR;
	t1->type = T_NONE;
	t1->u.num = varnum ++;

	Type tt1 = Exp(tnode, t1);

	Operand t2 = malloc(sizeof(struct Operand_));
	t2->kind = OP_CONS;
	t2->type = T_NONE;
	t2->u.value = malloc(32);
	strcpy(t2->u.value, "0");

	InterCode code1 = malloc(sizeof(struct InterCode_));
	code1->kind = IR_IFGOTO;
	code1->u.triop.z = label_true;
	code1->u.triop.x = t1;
	code1->u.triop.y = t2;
	code1->u.triop.relop = malloc(32);
	strcpy(code1->u.triop.relop, "!=");
	insertCode(code1);

	InterCode code2 = malloc(sizeof(struct InterCode_));
	code2->kind = IR_GOTO;
	code2->u.one.op = label_false;
	insertCode(code2);
	return tt1;

}

int typeSize(Type t)
{
	if (t->kind == 0 ||t->kind == 3)
		return 4;
	if (t->kind == 1)
	{
		return t->u.array.size * typeSize(t->u.array.elem);
	}
	if (t->kind == 2)
	{
		int size = 0;
		FieldList f = t->u.structure->tail;
		while (f != NULL)
		{
			size += typeSize(f->type);
			f = f->tail;
		}
		return size;
	}
	return 0;
}
