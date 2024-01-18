%option noyywrap

%{
#include"microParser.h"
%}

letter	[A-Za-z_]
digit	[0-9]
integer	{digit}+
blank_str	[ \t]+
identifier	{letter}({letter}|{digit})*
strr	\"([^\"\n])*\"


%%
\n {}
{blank_str}	{}
[#]([^\n])* {}
[P][R][O][G][R][A][M] {return PROGRAM;}
[B][E][G][I][N] { return _BEGIN;}
[F][U][N][C][T][I][O][N] { return FUNCTION;}
[E][N][D] { return END;}
[R][E][A][D] { return READ;}
[W][R][I][T][E] { return WRITE;}
[I][F] { return IF;}
[E][L][S][E] { return ELSE;}
[F][I] { return FI;}
[F][O][R] { return FOR;}
[R][O][F] { return ROF;}
[R][E][T][U][R][N] { return RETURN;}
[I][N][T] { return INT_TYPE;}
[V][O][I][D] { return VOID;}
[S][T][R][I][N][G] {return STRING_TYPE;}
[F][L][O][A][T] { return FLOAT_TYPE;} 


{identifier} { yylval.idd=strdup(yytext); return IDENTIFIER;}

[+] {return PLUS;}
[-] {return MINUS;}
[*] {return MULI;}
[/] {return DIVI;}
[:][=] {return EQU;}
[!][=] {return NOTEQU;}
[(] {return SMLBR;}
[)] {return SMRBR;}
[>][=] {return GREQU;}
[<][=] {return LSEQU;}
[;] {return SEMI;}
[>] {return GR;}
[=] {return ONEEQU;}
[<] {return LS;}
[,] {return COMMA;}

{integer}[.]{integer} {yylval.ff=strdup(yytext); return FLOAT_LITERAL; }
[.]{integer} {return FLOAT_LITERAL;}
{integer} {yylval.ii=atoi(yytext); return INT_LITERAL;}
{strr} { yylval.stt=strdup(yytext); return STRING_LITERAL;}

%%

