#include<stdio.h>
#include<stdlib.h>
#include "microParser.h"

int yyparse();
int yylex();
extern FILE *yyin;
void yyerror(char const *s);

void yyerror(char const *s)
{
    printf("Not accepted\n");
}

int main(int argc, char **argv)
{
	yyin = fopen(argv[1],"r");
    if(yyparse()==0)
    {
        // printf("Accepted\n");
    }

}
