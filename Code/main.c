#include <stdio.h>
#include "node.h"
#include "semantic.h"
#include "intercode.h"
#include "objectcode.h"
extern int errorflag; 
extern node* root;
extern yylineno;
int yyerror(char* msg)
{
	errorflag = 1;
	printf("Error type B at line %d: with %s\n", yylineno, msg);
}
int main(int argc, char** argv)
{
	if (argc <=1) return 1;
	FILE* f = fopen(argv[1], "r");
	if (!f)
	{
		perror(argv[1]);
		return 1;
	}
	yylineno = 1;
	yyrestart(f);
	yyparse();
	//if (!errorflag) print_tree(root, 0);	
	Program(root);
	printCode(argv[2]);
	printObjectCode(argv[2]);
	return 0;
}
