#ifndef _SEMANTIC_H
#define _SEMANTIC_H
#include "node.h"
#include "table.h"
#include "intercode.h"
#include "string.h"
#include "stdio.h"
/* Syntax tree walker functions */

// High-level definitions
void Program(node* tnode);
void ExtDefList(node* tnode);
void ExtDef(node* tnode);
void ExtDecList(Type type, node* tnode);

// Specifiers 
Type Specifier(node* tnode);
Type StructSpecifier(node* tnode);
char* OptTag(node* tnode);
Type Tag(node* tnode);

// Declarators 
FieldList VarDec(Type type, node* tnode, int from);
FuncList FuncDec(Type type, node* tnode);
FieldList VarList(node* tnode);
FieldList ParamDec(node* tnode);

// Statements
void CompSt(Type type, node* tnode);
void StmtList(Type type, node* tnode);
void Stmt(Type type, node* tnode);

// Local definitions
FieldList DefList(node* tnode, int from);
FieldList Def(node* tnode, int from);
FieldList DecList(Type type, node* tnode, int from);
FieldList Dec(Type type, node* tnode, int from);

// Expressions
Type Exp(node* tnode, Operand op);
int Args(node* tnode, FieldList f, Operand op);
Type translate_cond(node* tnode, Operand label_true, Operand label_false);
int typeSize(Type t);

#endif
