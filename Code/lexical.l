%{
	#include <stdio.h>
	#include "syntax.tab.h"
	#include "node.h"
	int yycolumn = 1;
	int errorflag = 0;
	#define YY_USER_ACTION \
		yylloc.first_line = yylloc.last_line = yylineno; \
		yylloc.first_column = yycolumn; \
		yylloc.last_column = yycolumn + yyleng - 1; \
		yycolumn += yyleng;	

%}
%option yylineno
digit [0-9]
digit_ [1-9]
letter [a-zA-Z_]
relop >|<|>=|<=|==|!=
type int|float
int8 0[0-7]*
int16 ((0x)|(0X))[0-9a-fA-F]*
ilint8 0[0-9a-zA-Z]*[8-9a-zA-Z][0-9a-zA-Z]*
ilint16 ((0x)|(0X))[0-9a-zA-Z]*[g-zG-Z][0-9a-zA-Z]* 
integer {digit_}{digit}*|{int8}|{int16}|0
sfloat (({digit}+\.{digit}*)|({digit}*\.{digit}+))[Ee][+-]?{digit}+
float {sfloat}|({integer}\.{digit}+)
ws [ \t]+
id {letter}({letter}|{digit})*
%%
{integer}	{/*printf("integer\n");*/ 
			yylval.tnode = cre_node("INT", yytext); 
			//printf("%s\n", yytext); 
			return INT;}
{float}		{/*printf("float\n");*/ 
			yylval.tnode = cre_node("FLOAT", yytext); 
			//printf("%s\n", yytext); 
			return FLOAT;}
{ilint16}	{printf("Error type A at line %d: Illigal hexadecimal number \'%s\'\n", yylineno, yytext); 
			yylval.tnode = cre_node("INT", yytext);
			errorflag = 1;
                        return INT;}
{ilint8}	{printf("Error type A at Line %d: Illigal octal number \'%s\'\n", yylineno, yytext); 
			yylval.tnode = cre_node("INT", yytext); 
			errorflag = 1;
			return INT;}
";"		{/*printf("SEMI\n");*/ 
			yylval.tnode = cre_node("SEMI", yytext);
			return SEMI;}
","		{/*printf("COMMA\n");*/ 
			yylval.tnode = cre_node("COMMA", yytext);
			return COMMA;}
"="		{/*printf("ASSIGNOP\n");*/ 
			yylval.tnode = cre_node("ASSIGNOP", yytext);
			return ASSIGNOP;}
{relop}		{/*printf("RELOP\n");*/ 
			yylval.tnode = cre_node("RELOP", yytext);
			return RELOP;}
"+"		{/*printf("PLUS\n");*/ 
			yylval.tnode = cre_node("PLUS", yytext);
			return PLUS;}
"-"		{/*printf("MINUS\n");*/ 
			yylval.tnode = cre_node("MINUS", yytext); 
			return MINUS;}
"*"		{/*printf("STAR\n");*/ 
			yylval.tnode = cre_node("STAR", yytext);
			return STAR;}
"/"		{/*printf("DIV\n");*/ 
			yylval.tnode = cre_node("DIV", yytext);
			return DIV;}
"&&"		{/*printf("AND\n");*/ 
			yylval.tnode = cre_node("AND", yytext);
			return AND;}
"||"		{/*printf("OR\n");*/ 
			yylval.tnode = cre_node("OR", yytext);
			return OR;}
"."		{/*printf("DOT\n");*/ 
			yylval.tnode = cre_node("DOT", yytext);
			return DOT;}
"!"		{/*printf("NOT\n");*/ 
			yylval.tnode = cre_node("NOT", yytext);
			return NOT;}
{type}		{/*printf("TYPE\n");*/ 
			yylval.tnode = cre_node("TYPE", yytext);
			return TYPE;}
"("		{/*printf("LP\n");*/ 
			yylval.tnode = cre_node("LP", yytext);
			return LP;}
")"		{/*printf("RP\n");*/ 
			yylval.tnode = cre_node("RP", yytext);
			return RP;}
"["		{/*printf("LB\n");*/ 
			yylval.tnode = cre_node("LB", yytext);
			return LB;}
"]"		{/*printf("RB\n");*/ 
			yylval.tnode = cre_node("RB", yytext);
			return RB;}
"{"		{/*printf("LC\n");*/ 
			yylval.tnode = cre_node("LC", yytext);
			return LC;}
"}"		{/*printf("RC\n");*/ 
			yylval.tnode = cre_node("RC", yytext);
			return RC;}
struct		{/*printf("STRUCT\n");*/ 
			yylval.tnode = cre_node("STRUCT", yytext);
			return STRUCT;}
return		{/*printf("RETURN\n");*/ 
			yylval.tnode = cre_node("RETURN", yytext);	
			return RETURN;}
if		{/*printf("IF\n");*/ 
			yylval.tnode = cre_node("IF", yytext);
			return IF;}
else		{/*printf("ELSE\n");*/ 
			yylval.tnode = cre_node("ELSE", yytext);
			return ELSE;}
while		{/*printf("WHILE\n");*/ 
			yylval.tnode = cre_node("WHILE", yytext);
			return WHILE;}
\n|\r		{/*printf("new line\n");*/ yycolumn = 1;}
{id}		{/*printf("It is an id\n");*/ 
			yylval.tnode = cre_node("ID", yytext);
			return ID;}
{ws}		{/*printf("tap | blank\n");*/}
"//".*\n	{/*printf("So nice!\n");*/}
"/*" 	 	{/*printf("So perfect!\n");*/
			char c1 = input(), c2 = input();
			while (!(c1 == '*' && c2 =='/' ) && c2 != EOF)
			{
				c1 = c2; c2 = input();
				//printf("%c\n", c2);
			}	
		}
.		{printf("Error type A at Line %d: Mysterious characters \'%s\'\n", yylineno, yytext);
			errorflag = 1;}
%%
