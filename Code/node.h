#ifndef __NODE__
#define __NODE__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node{
	int row;
	char name[30];
	char value[32];
	struct node* child;
	struct node* brother;
}node;

node* cre_node(char* name, char* value);
void add_child(node* father, node* child);
void print_tree(node* tnode, int count);

#endif
