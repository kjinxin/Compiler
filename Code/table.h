#ifndef _TABLE_H
#define _TABLE_H

#include "node.h"
#include "string.h"
#include "stdio.h"
#define TABLESIZE 32767	// define the size of the hash table
#define TABLELAYER 100  // define the maximize layer of variables
#define TYPEINT 0
#define TYPEFLOAT 1
extern int tdepth;
typedef struct Type_* Type;
typedef struct FieldList_* FieldList;
typedef struct FuncList_* FuncList;
typedef struct Hash_var_ele_* Hash_var_ele;
typedef struct Hash_func_ele_* Hash_func_ele;

// type definition
struct Type_
{
	enum {BASIC, ARRAY, STRUCTURE, CONSTANT} kind;
	union
	{
		//base type
		int basic;
		//type of array and its size
		struct { Type elem; int size; } array;
		//type of structure
		FieldList structure;
	} u;
};

// variable definition
struct FieldList_
{
	char* name;	// the name of the field
	Type type; 	// the type of the field 
	FieldList tail; // the next field
};

// function definition
struct FuncList_
{
	char* name;	// the name of the function
	int isDefined;  // whether the function has been defined
	int row;
	Type type; 	// the type of the function
	FieldList para; // the parameters of the function
};

// the element of variable hash table
struct Hash_var_ele_
{
	FieldList var;
	int depth;
	int isStruct;
	Hash_var_ele next;
	Hash_var_ele layernext;
};

// the element of funciton hash table
struct Hash_func_ele_
{
	FuncList func;
	Hash_func_ele next;
};

// hash tables of variable and function
Hash_var_ele hash_var[TABLESIZE];
Hash_func_ele hash_func[TABLESIZE];

// the head of each variable layer
Hash_var_ele layerhead[TABLELAYER];


unsigned int hash_pjw(char* name);
void initHash();
int insertVar(Hash_var_ele var);
Hash_var_ele findVar(char* name);
int insertFunc(Hash_func_ele func, int isDefined);
Hash_func_ele findFunc(char* name);
int isEqualPara(FieldList f1, FieldList f2);
int isEqualType(Type t1, Type t2);
void deleteEle();
void checkfunc();
#endif
