%locations	
%{
	#include <stdio.h>
	#include "node.h"
	#include "lex.yy.c"
	node* root;
	extern int errorflag;
%}
/* types */
%union {
	int type_int;
	float type_float;
	char* type_str;
	node* tnode;
};
/* declared tokens */
%define parse.error verbose

%token <tnode> INT FLOAT ID TYPE
%token <tnode> SEMI COMMA ASSIGNOP RELOP
%token <tnode> PLUS MINUS STAR DIV
%token <tnode> AND OR DOT NOT
%token <tnode> LP RP LB RB LC RC
%token <tnode> STRUCT RETURN
%token <tnode> IF ELSE WHILE

%nonassoc LOWER_THEN_ELSE
%nonassoc ELSE

%right ASSIGNOP NOT
%left OR 
%left AND 
%left RELOP
%left PLUS MINUS 
%left STAR DIV
%left LP RP LB RB LC RC DOT

%nonassoc STRUCT RETURN WHILE IF

/* non-terminal */
%type <tnode> Program ExtDefList ExtDef ExtDecList Specifier
%type <tnode> StructSpecifier OptTag Tag VarDec FunDec VarList
%type <tnode> ParamDec CompSt StmtList Stmt DefList Def DecList
%type <tnode> Dec Exp Args

%%
/* High-level Definition */
Program		:	ExtDefList			{$$ = cre_node("Program", ""); add_child($$, $1); root = $$;}
        	;
ExtDefList	:	ExtDef	ExtDefList		{$$ = cre_node("ExtDefList", ""); add_child($$, $2); add_child($$, $1);}
  		|					{$$ = NULL;}
		;
ExtDef		:	Specifier ExtDecList SEMI	{$$ = cre_node("ExtDef", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
       		|	Specifier SEMI			{$$ = cre_node("ExtDef", ""); add_child($$, $2); add_child($$, $1);}
		|	Specifier FunDec CompSt		{$$ = cre_node("ExtDef", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
                |       Specifier FunDec SEMI           {$$ = cre_node("ExtDef", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
                |       Specifier ExtDecList error      {}
                |       Specifier error                 {}
                ;
ExtDecList	:	VarDec				{$$ = cre_node("ExtDecList", ""); add_child($$, $1);}
	   	|	VarDec COMMA ExtDecList		{$$ = cre_node("ExtDecList", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
                |       VarDec error ExtDecList
		;


/* Specifiers */
Specifier	:	TYPE				{$$ = cre_node("Specifier", ""); add_child($$, $1);}
	  	|	StructSpecifier			{$$ = cre_node("Specifier", ""); add_child($$, $1);}
		;
StructSpecifier	:	STRUCT OptTag LC DefList RC	{$$ = cre_node("StructSpecifier", ""); add_child($$, $5); add_child($$, $4); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	STRUCT Tag			{$$ = cre_node("StructSpecifier", ""); add_child($$, $2); add_child($$, $1);}
                |       STRUCT OptTag LC DefList error  {/*printf("Missing \"}\"\n");*/}
                |       STRUCT OptTag error DefList RC  {/*printf("Missing \"{\"\n");*/}
		;
OptTag		:	ID				{$$ = cre_node("OptTag", ""); add_child($$, $1);}
		|					{$$ = NULL;}
		;
Tag		: 	ID				{$$ = cre_node("Tag", ""); add_child($$, $1);}
     		;


/* Declarators */
VarDec		:	ID				{$$ = cre_node("VarDec", ""); add_child($$, $1);}
		|	VarDec LB INT RB		{$$ = cre_node("VarDec", ""); add_child($$, $4); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
                |       VarDec LB INT error             {/*printf("Missing \")\"\n");*/}
		;
FunDec 		:	ID LP VarList RP		{$$ = cre_node("FunDec", ""); add_child($$, $4); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
	 	|	ID LP RP			{$$ = cre_node("FunDec", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		| 	ID LP VarList error		{/*printf("Missing \")\"\n");*/}
                |       ID LP error                     {/*printf("Missing \")\"\n");*/}
                |       ID error RP                     {}
                |       ID error                        {}
		;
VarList		: 	ParamDec COMMA VarList		{$$ = cre_node("VarList", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
	 	|	ParamDec			{$$ = cre_node("VarList", ""); add_child($$, $1);}
		;
ParamDec	:	Specifier VarDec		{$$ = cre_node("ParamDec", ""); add_child($$, $2); add_child($$, $1);}
	 	;


/* Statements */
CompSt		:	LC DefList StmtList RC		{$$ = cre_node("CompSt", ""); add_child($$, $4); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
	        |       LC DefList StmtList error       {/*printf("Missing \"}\"\n");*/}
		;
StmtList	:	Stmt StmtList			{$$ = cre_node("StmtList", ""); add_child($$, $2); add_child($$, $1);}
	 	|					{$$ = NULL;}
		;
Stmt		:	Exp SEMI			{$$ = cre_node("Stmt", ""); add_child($$, $2); add_child($$, $1);}
      		|	CompSt				{$$ = cre_node("Stmt", ""); add_child($$, $1);}
		|	RETURN Exp SEMI	        	{$$ = cre_node("Stmt", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	IF LP Exp RP Stmt %prec LOWER_THEN_ELSE	{$$ = cre_node("Stmt", ""); add_child($$, $5); add_child($$, $4); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	IF LP Exp RP Stmt ELSE Stmt	{$$ = cre_node("Stmt", ""); add_child($$, $7); add_child($$, $6); add_child($$, $5); add_child($$, $4); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	WHILE LP Exp RP Stmt		{$$ = cre_node("Stmt", ""); add_child($$, $5); add_child($$, $4); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	Exp error			{/*printf("Missing \";\"\n");*/}
		|       RETURN Exp error                {/*printf("Missing \";\"\n");*/}
                ;


/* Local Definitions */
DefList		:	Def DefList			{$$ = cre_node("DefList", ""); add_child($$, $2); add_child($$, $1);}
	 	|					{$$ = NULL;}
		;
Def		:	Specifier DecList SEMI		{$$ = cre_node("Def", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
     		|	Specifier DecList error		{/*printf("Missing \";\"\n");*/}
     		;
DecList		:	Dec				{$$ = cre_node("DecList", ""); add_child($$, $1);}
	 	|	Dec COMMA DecList		{$$ = cre_node("DecList", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		;
Dec		:	VarDec				{$$ = cre_node("Dec", ""); add_child($$, $1);}
     		|	VarDec	ASSIGNOP Exp		{$$ = cre_node("Dec", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
                |       error                           {} 
		;


/* Expressions */
Exp		:	Exp ASSIGNOP Exp		{$$ = cre_node("Exp", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
     		|	Exp OR Exp			{$$ = cre_node("Exp", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	Exp AND Exp			{$$ = cre_node("Exp", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	Exp RELOP Exp			{$$ = cre_node("Exp", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	Exp PLUS Exp			{$$ = cre_node("Exp", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	Exp MINUS Exp			{$$ = cre_node("Exp", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	Exp STAR Exp			{$$ = cre_node("Exp", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		| 	Exp DIV Exp			{$$ = cre_node("Exp", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		| 	LP Exp RP			{$$ = cre_node("Exp", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	MINUS Exp			{$$ = cre_node("Exp", ""); add_child($$, $2); add_child($$, $1);}
		|	NOT Exp				{$$ = cre_node("Exp", ""); add_child($$, $2); add_child($$, $1);}
		|	ID LP Args RP			{$$ = cre_node("Exp", ""); add_child($$, $4); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		| 	ID LP RP			{$$ = cre_node("Exp", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}			
		|	Exp LB Exp RB			{$$ = cre_node("Exp", ""); add_child($$, $4); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	Exp DOT ID			{$$ = cre_node("Exp", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
		|	ID				{$$ = cre_node("Exp", ""); add_child($$, $1);}
		|	INT				{$$ = cre_node("Exp", ""); add_child($$, $1);}
		|	FLOAT				{$$ = cre_node("Exp", ""); add_child($$, $1);}
		|	error				{}
		;
Args 		:	Exp COMMA Args			{$$ = cre_node("Args", ""); add_child($$, $3); add_child($$, $2); add_child($$, $1);}
       		|	Exp				{$$ = cre_node("Args", ""); add_child($$, $1);}
		;
