#include "node.h"
extern int yylineno;
node* cre_node(char* name, char* value)
{
	node* tnode = malloc(sizeof(node));
	tnode->row = yylineno;
	strcpy(tnode->name, name);
	strcpy(tnode->value, value);
	tnode->child = NULL;
	tnode->brother = NULL;
	return tnode;
}

/* add a child node to a father node */
void add_child(node* father, node* child)
{
	if (father != NULL &&  child != NULL)
	{
		child->brother = father->child;
		father->child = child;
		father->row = child->row;
	}
}

/* print the grammar tree */
void print_tree(node* tnode, int count)
{
	if (tnode == NULL) return;
	
	/* it is a token */
	if (tnode->child == NULL)
	{
		int i = 0;
		for(; i < count; i ++) printf("  ");
		if (!strcmp(tnode->name, "TYPE")||!strcmp(tnode->name, "INT")||!strcmp(tnode->name, "FLOAT")||!strcmp(tnode->name, "ID")) 	
		{
			if (!strcmp(tnode->name, "INT"))
			{
				int tvalue;	
				if (strlen(tnode->value) > 1 && *(tnode->value) == '0' \
					&& (*(tnode->value + 1) == 'x' || *(tnode->value + 1) == 'X'))	
					sscanf(tnode->value, "%x", &tvalue);
				else
				if (*(tnode->value) == '0')
					sscanf(tnode->value, "%o", &tvalue);
				else 	sscanf(tnode->value, "%d", &tvalue);
				printf("%s: %d\n", tnode->name, tvalue);
			}
			if (!strcmp(tnode->name, "FLOAT"))
				printf("%s: %f\n", tnode->name, atof(tnode->value));
			if (!strcmp(tnode->name, "TYPE") || !strcmp(tnode->name, "ID"))
				printf("%s: %s\n", tnode->name, tnode->value);
		}
		else
		{
			printf("%s\n", tnode->name);
		}
	}
	/* it is a non-terminal */
	if (tnode->child != NULL)
	{
		int i = 0;
		for(; i < count; i ++) printf("  ");
		printf("%s (%d)\n", tnode->name, tnode->row);
		print_tree(tnode->child, count + 1);
	}
	if (tnode->brother != NULL)
	{
		print_tree(tnode->brother, count);
	}
}
