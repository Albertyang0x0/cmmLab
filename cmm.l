%{
# include <stdio.h>
# include <stdlib.h>
# include "cmm.h"
# include "cmm.tab.h"
%}

%option yylineno

 /*整型*/
INT8 0[0-7]*
INT10 [1-9][0-9]*
INT16 0[Xx][0-9a-fA-F]+
INT {INT8}|{INT10}|{INT16}
 /*浮点型*/
FLOAT ({INT10}\.[0-9]+)|({INT10}(\.[0-9]+)?)[Ee][+-]?{INT10}
 /*数字*/
NUMBER {INT}|{FLOAT}
 /*标识符*/
ID [a-zA-Z_][a-zA-Z0-9_]*
 /*标点*/
SEMI  ;
COMMA ,
ASSIGNOP =
ADD \+
SUB \-
MUL \*
DIV \/
AND &&
OR \|\|
DOT \.
NOT \!
LP \(
RP \)
LB \[
RB \]
LC \{
RC \}
RELOP >|<|>=|<=|==|!=
 /*关键字*/
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while
TYPE int|float
 /*空格*/
SPACE [ \n\r\t]+

COMMENT \/\*([^*]|\*[^/])*\*\/|\/\/[^\n]*

 /*错误*/
ERROR .|({INT10}\.[0-9]+)[Ee]



%%
{SPACE} {}

{TYPE} { yylval.type_node = newNode("TYPE", 0, yylineno, NULL); return TYPE;}
{STRUCT} {yylval.type_node = newNode("STRUCT", 0, yylineno, NULL); return STRUCT;}
{RETURN} {yylval.type_node = newNode("RETURN", 0, yylineno, NULL); return RETURN;}
{IF} {yylval.type_node = newNode("IF", 0, yylineno, NULL); return IF;}
{ELSE} {yylval.type_node = newNode("ELSE", 0, yylineno, NULL); return ELSE;}
{WHILE} {yylval.type_node = newNode("WHILE", 0, yylineno, NULL); return WHILE;}

{INT} {yylval.type_node = newNode("INT", 0, yylineno, NULL); return INT;}
{FLOAT} {yylval.type_node = newNode("FLOAT", 0, yylineno, NULL); return FLOAT;}

{SEMI} {yylval.type_node = newNode("SEMI", 0, yylineno, NULL); return SEMI;}
{COMMA} {yylval.type_node = newNode("COMMA", 0, yylineno, NULL); return COMMA;}
{ASSIGNOP} {yylval.type_node = newNode("ASSIGNOP", 0, yylineno, NULL); return ASSIGNOP;}
{ADD} {yylval.type_node = newNode("ADD", 0, yylineno, NULL); return ADD;}
{SUB} {yylval.type_node = newNode("SUB", 0, yylineno, NULL); return SUB;}
{MUL} {yylval.type_node = newNode("MUL", 0, yylineno, NULL); return MUL;}
{DIV} {yylval.type_node = newNode("DIV", 0, yylineno, NULL); return DIV;}
{AND} {yylval.type_node = newNode("AND", 0, yylineno, NULL); return AND;}
{DOT} {yylval.type_node = newNode("DOT", 0, yylineno, NULL); return DOT;}
{NOT} {yylval.type_node = newNode("NOT", 0, yylineno, NULL); return NOT;}
{LP} {yylval.type_node = newNode("LP", 0, yylineno, NULL); return LP;}
{RP} {yylval.type_node = newNode("RP", 0, yylineno, NULL); return RP;}
{LB} {yylval.type_node = newNode("LB", 0, yylineno, NULL); return LB;}
{RB} {yylval.type_node = newNode("RB", 0, yylineno, NULL); return RB;}
{LC} {yylval.type_node = newNode("LC", 0, yylineno, NULL); return LC;}
{RC} {yylval.type_node = newNode("RC", 0, yylineno, NULL); return RC;}
{RELOP} {yylval.type_node = newNode("RELOP", 0, yylineno, NULL); return RELOP;}
{COMMENT} {}

{ID} {yylval.type_node = newNode("ID", 0, yylineno, NULL); return ID;}

{ERROR} { 
    hasFault = 1;
    printf("error type A at line %d: mysterious character '%s'\n", yylineno, yytext);
}
%%
