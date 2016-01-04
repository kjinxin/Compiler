#include "table.h"

int tdepth = 0;
unsigned int hash_pjw(char* name)
{
	unsigned int val = 0, i;
	for (; *name; name ++)
	{
		val = (val << 2) + *name;
		if (i = val & ~0x3fff) val = (val ^ (i >> 12)) & 0x3fff;
	}
	return val;
}

void initHash()
{
	int i;
	for (i = 0; i < TABLESIZE; i ++)
	{
		hash_func[i] = NULL;
		hash_var[i] = NULL;
	}
	for (i = 0; i < TABLELAYER; i ++)
	{
		layerhead[i] = NULL;
	}

	// insert function read()
	FuncList fr = malloc(sizeof(struct FuncList_));
	fr->name = malloc(10);
	strcpy(fr->name, "read");
	fr->isDefined = 1;
	fr->row = 0;
	fr->type = malloc(sizeof(struct Type_));
	fr->type->kind = BASIC;
	fr->type->u.basic = TYPEINT;
	fr->para = NULL;
	Hash_func_ele funcr = malloc(sizeof(struct Hash_func_ele_));
	funcr->func = fr;
	funcr->next = NULL;
	insertFunc(funcr, 1);
	// insert function write()
	FuncList fw = malloc(sizeof(struct FuncList_));
	fw->name = malloc(32);
	strcpy(fw->name, "write");
	fw->isDefined = 1;
	fw->row = 0;
	fw->type = malloc(sizeof(struct Type_));
	fw->type->kind = BASIC;
	fw->type->u.basic = TYPEINT;
	fw->para = malloc(sizeof(struct FieldList_));
	fw->para->name = malloc(32);
	strcpy(fw->para->name, "wpara");
	fw->para->type = fw->type;
	fw->para->tail = NULL;
	Hash_func_ele funcw = malloc(sizeof(struct Hash_func_ele_));
	funcw->func = fw;
	funcw->next = NULL;
	insertFunc(funcw, 1);
}

void checkfunc()
{
	int i;
	for (i = 0; i < TABLESIZE; i ++)
	{
		if (hash_func[i] != NULL && hash_func[i]->func->isDefined == 0)
		printf("Error type 18 at Line %d: Undefined function \"%s\"\n", hash_func[i]->func->row, hash_func[i]->func->name);
	}
}
int insertVar(Hash_var_ele var)
{
	int pos = hash_pjw(var->var->name);
	Hash_var_ele curvar = hash_var[pos];
	while (curvar != NULL)
	{
		// repeat definition
		if (!strcmp(var->var->name, curvar->var->name) && (var->depth == curvar->depth || curvar->isStruct == 1))
		{
			return 1;
		}
		curvar = curvar->next;
	}
	// insert at the head 
	var->next = hash_var[pos];
	hash_var[pos] = var;
	var->layernext = layerhead[tdepth];
	layerhead[tdepth] = var;
	return 0;
}

Hash_var_ele findVar(char* name)
{
	int pos = hash_pjw(name);
	Hash_var_ele curvar = hash_var[pos];
	while (curvar != NULL)
	{
		if (!strcmp(curvar->var->name, name))
		{
			return curvar;
		}
		curvar = curvar->next;
	}
	return NULL;
}

int insertFunc(Hash_func_ele func, int isDefined)
{
	int pos = hash_pjw(func->func->name);
	Hash_func_ele curfunc = hash_func[pos];
	while (curfunc != NULL)
	{
		//repeat definition
		if (!strcmp(func->func->name, curfunc->func->name)) break;
		curfunc = curfunc->next;
	}
	if (curfunc != NULL)
	{
		if (isDefined == 1 && curfunc->func->isDefined == 1) return 1;
		FieldList f1 = curfunc->func->para;
		FieldList f2 = func->func->para;
		if (isEqualPara(f1, f2))
		{
			return 2;
		}
		else
		{
			if (isDefined == 1) curfunc->func->isDefined = 1;
		}

	}
	else
	{
		func->func->isDefined = isDefined;
		func->next = hash_func[pos];
		hash_func[pos] = func;	
	}
	return 0;
}

Hash_func_ele findFunc(char* name)
{
	int pos = hash_pjw(name);
	Hash_func_ele curfunc = hash_func[pos];
	while (curfunc != NULL)
	{
		if (!strcmp(curfunc->func->name, name)) return curfunc;
		curfunc = curfunc->next;
	}
	return NULL;
}

int isEqualPara(FieldList f1, FieldList f2)
{
	if (f1 == NULL && f2 == NULL) return 0;
	if (f1 == NULL || f2 == NULL) return 1;
	if (!isEqualType(f1->type, f2->type)) return isEqualPara(f1->tail, f2->tail);
	return 1;
}

int isEqualType(Type t1, Type t2)
{
	if (t1 == NULL && t2 == NULL) return 0;
	if (t1 == NULL || t2 == NULL) return 1;
	if (t1->kind == 0 || t1->kind == 3)
	{
		if ((t2->kind == 0 || t2->kind == 3) && t1->u.basic == t2->u.basic)
		return 0;
		return 1;
	}
	else
	if (t1->kind == 1)
	{
		if (t2->kind != 1)
			return 1;
		if (t1->u.array.size != t2->u.array.size)
			return 1;
		return isEqualType(t1->u.array.elem, t2->u.array.elem);

	}
	if (t1->kind == 2)
	{
		if (t2->kind != 2)
			return 1;
		return isEqualPara(t1->u.structure->tail, t2->u.structure->tail);
		
	}
	return 0;
}

void deleteEle()
{
	Hash_var_ele temp = layerhead[tdepth];
	while (temp != NULL)
	{
		int pos = hash_pjw(temp->var->name);
		Hash_var_ele curvar = hash_var[pos];
		if (curvar == temp)
		{
			hash_var[pos] = curvar->next;			
		}	
		else
		{
			while (curvar->next != NULL && curvar->next != temp)
			{
				curvar = curvar->next;
			}			
			if (curvar->next == temp)
			{
				curvar->next = temp->next;
			}
		}
		curvar = temp;
		temp = temp->layernext; 		
		free(curvar);
	}
	layerhead[tdepth] = NULL;
}
