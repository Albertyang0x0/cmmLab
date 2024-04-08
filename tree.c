# include "cmm.h"
#include <stdlib.h>
extern int yylineno;
extern int yyparse();
extern void yyrestart(FILE *);

int hasFault = 0;
int nodeNum = 0;
treeNode nodeList[1000];
int nodeIsChild[1000];


int tonumber(char * p){
    //16
    if (p[0] == '0' && (p[1] == 'x' || p[1] == 'X')){
        return strtoll(p, NULL, 16);
    }
    // 10
    else if (p[0] != '0' || (p[0] == '0' && p[1] == '\0')){
       return strtoll(p, NULL, 10);
    }
    // 8
    else {
        return strtoll(p, NULL, 8); 
    }
}

void setChildTag (treeNode node){
    for (int i=0; i<nodeNum; i++){
        if (nodeList[i] == node)
            nodeIsChild[i] = 1;
    }
}

treeNode newNode(char *name, int num, int yyline, treeNode childList[]){
	/*if(childList==NULL){
	
		printf("%s\t%s\n", name, yytext);
	}*/
    treeNode father = (treeNode)malloc(sizeof(struct TREE));
    if (!father){
        yyerror("create treenode error\n");
        exit(0);
    }
    father -> name = name;
    father -> n = num;
    // 有子节点，不是终结符
    if (num > 0){
        father -> line = childList[0] -> line;
        for (int i=0; i<num; i++){
            setChildTag(childList[i]);
            father -> child[i] = childList[i];
        }
    }
    // 终结符、空的语法单元，空单元行号为-1
    else{
        father -> line = yyline;
        //printf("the child is %d\n", father->n);
        if ((!strcmp(name, "ID"))) {
            //printf("u have enter %s into it\n", yytext);
            char *str = (char *)malloc(sizeof (char) * (strlen(yytext) + 1));
            strcpy(str, yytext);
            father->ID = str;
        }
        else if ((!strcmp(name, "TYPE"))) {
            //printf("u have enter %s into it\n", yytext);
            char *str;
            str = (char *)malloc(sizeof (char) * (strlen(yytext) + 1));
            strcpy(str, yytext);
            father->ID = str;
        }        
        else if (!strcmp(name, "INT")){
            father -> INT = tonumber(yytext);
            //printf("%d\n", father -> INT);
        }
        else if (!strcmp(name, "FLOAT")){
            father -> FLOAT = strtof(yytext, NULL);
        }
    }
    return father;
}

void preOrder(treeNode t, int level){
    if (t != NULL && t -> line != -1){
        for (int i=0; i<level; i++)
            printf("  ");
        printf("%s", t->name);
        if (!strcmp(t->name, "ID")){
            printf(": %s", t->ID);
        }
        else if (!strcmp(t->name, "TYPE"))
            printf(": %s", t->ID);
        else if (!strcmp(t->name, "INT")){
            printf(": %d", t->INT);
        }
        else if (!strcmp(t->name, "FLOAT"))
            printf(": %f", t->FLOAT);
        // 非叶节点，打印行号
        else if (t->n != 0)
            printf(" (%d)", t->line);
        printf("\n");
        for (int i=0; i<t->n; i++){
            preOrder(t->child[i], level+1);
        }
    }
}

void yyerror(char *msg){//bison requset
    hasFault = 1;
    fprintf(stderr, "Error type B at Line %d: %s.\n", yylineno, msg);
}

void printTree(){
    if (!hasFault)
        for (int j=0; j<nodeNum; j++){
            if (nodeIsChild[j] != 1)
                preOrder(nodeList[j], 0);
        }
}

int main(int argc, char **argv){
    if (argc < 2){
        return 1;
    }
    //for (int i=1; i<argc; i++){
    hasFault = 0;
    nodeNum = 0;
    memset(nodeList, 0, sizeof(treeNode)*1000);
    memset(nodeIsChild, 0, sizeof(int)*1000);

    FILE *f = fopen(argv[1], "r");
    if (!f){
        perror(argv[1]);
        return 1;
    }
    yyrestart(f);//default:yacc read from stdin
    yyparse();
    fclose(f);
    //if (hasFault)
        //continue;

    //}
}



