%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int block = 0;
char err[100];
int flag = 0;
int count_table = -1;
int sc; 
int calll=0;
int condstmt=0;
int fi = -1;
int initstmtinit=0;
int infbody=0;
int argg=0;
int rw=0;
int funcar[100];
int funcar_t=-1;
int read=0;
int writ=0;
int forfor=0;
int param=0;
int lb=0;
int funfun=-1;
struct Node{
    char *id;
    char *type;
    char *val;
    char *reg;
};

int ife[10];
int iff=-1;

struct vec{
	char *val;
	char *type;
};

struct vec ap[100];

struct assm{
	char *val;
};

struct assm mm[1000];
int reg=0;
int mmp=-1;

int top=-1;
int rr=1;
struct Table{
    struct Node * tb;
    char *scope;
    int n_len;
    int arggs;
};
char t[] = "GLOBAL";
struct Table tk[100];
struct ASTNode{
	char *type;
	char *val;
	struct ASTNode *left;
	struct ASTNode * right;
};

void do_post(struct ASTNode * root)
{
	if(root!=NULL)
	{
		do_post(root->left);
		do_post(root->right);
//		printf("%s %s\n",root->val,root->type);
		top++;
		sprintf(ap[top].val,"%s",root->val);
		sprintf(ap[top].type,"%s",root->type);
		
		
	}

}

struct am{
	char * op;
	char *val1;
	char * val2;
	char *val3;

};
int asmp=-1;
struct am pp[1000];

void do_ir(struct ASTNode * root)
{


	int kk=-1;
	struct vec st[100];
	for(int l=0;l<100;l++)
	{
		st[l].val=(char *)malloc(sizeof(char)*100);
		st[l].type=(char *)malloc(sizeof(char)*100);
	}
	int i=0;
	while(i<=top)
	{
		struct vec temp=ap[i];
		if(strcmp("IDENTIFIER",temp.type)==0)
		{
			kk++;
			sprintf(st[kk].val,"%s",temp.val);
			
			for(int i=0;i<=count_table;i++)
			{
				for(int j=0;j<tk[i].n_len;j++)
				{
					if(strcmp(tk[i].tb[j].reg,temp.val)==0)
					sprintf(st[kk].type,"%s",tk[i].tb[j].type);
				}
			}

			
			i++;
		}
		else if(strcmp("INTEGER",temp.type)==0)
		{
			
			
			kk++;
			sprintf(st[kk].val,"$T%d",rr);
			sprintf(st[kk].type,"INTEGER");
			printf(";STOREI %s %s\n",temp.val,st[kk].val);	
			asmp++;
			sprintf(pp[asmp].op,"STOREI");
			sprintf(pp[asmp].val1,"%s",temp.val);
			sprintf(pp[asmp].val2,"%s",st[kk].val);
			rr++;
			i++;
		}
		else if(strcmp("FLOAT",temp.type)==0)
		{
			kk++;
			sprintf(st[kk].val,"$T%d",rr);
			sprintf(st[kk].type,"FLOAT");
			printf(";STOREF %s %s\n",temp.val,st[kk].val);	
			asmp++;
			sprintf(pp[asmp].op,"STOREF");
			sprintf(pp[asmp].val1,"%s",temp.val);
			sprintf(pp[asmp].val2,"%s",st[kk].val);
			rr++;
			i++;
		}
		else
		{
			struct vec k1=st[kk-1];
			struct vec k2=st[kk];
			kk=kk-2;
			if(strcmp(temp.type,"EQUAL")==0)
			{
				if(strcmp(k2.type,"INTEGER")==0)
				{
					printf(";STOREI %s %s\n",k2.val,k1.val);
					asmp++;
					sprintf(pp[asmp].op,"STOREI");
					sprintf(pp[asmp].val1,"%s",k2.val);
					sprintf(pp[asmp].val2,"%s",k1.val);
					
					
				}
				
				if(strcmp(k2.type,"FLOAT")==0)
				{
					printf(";STOREF %s %s\n",k2.val,k1.val);
					asmp++;
					sprintf(pp[asmp].op,"STOREF");
					sprintf(pp[asmp].val1,"%s",k2.val);
					sprintf(pp[asmp].val2,"%s",k1.val);
				}
			
			}
			if(strcmp(temp.type,"PLUS")==0)
			{
				if(strcmp(k1.type,"FLOAT")==0 || strcmp(k2.type,"FLOAT")==0)
				{
					printf(";ADDF %s %s $T%d\n",k1.val,k2.val,rr);
					asmp++;
					sprintf(pp[asmp].op,"ADDF");
					sprintf(pp[asmp].val1,"%s",k1.val);
					sprintf(pp[asmp].val2,"%s",k2.val);
					sprintf(pp[asmp].val3,"$T%d",rr);
				}
				else
				{
					printf(";ADDI %s %s $T%d\n",k1.val,k2.val,rr);
					asmp++;
					sprintf(pp[asmp].op,"ADDI");
					sprintf(pp[asmp].val1,"%s",k1.val);
					sprintf(pp[asmp].val2,"%s",k2.val);
					sprintf(pp[asmp].val3,"$T%d",rr);
				}
				
				kk++;
				sprintf(st[kk].val,"$T%d",rr);
				if(strcmp(k2.type,"FLOAT")==0 || strcmp(k1.type,"FLOAT")==0)
				{
					sprintf(st[kk].type,"FLOAT");
				}
				else{
					sprintf(st[kk].type,"INTEGER");
				}
				rr++;
			
			}
			if(strcmp(temp.type,"MINUS")==0)
			{
				if(strcmp(k1.type,"FLOAT")==0 || strcmp(k2.type,"FLOAT")==0)
				{
					printf(";SUBF %s %s $T%d\n",k1.val,k2.val,rr);
					asmp++;
					sprintf(pp[asmp].op,"SUBF");
					sprintf(pp[asmp].val1,"%s",k1.val);
					sprintf(pp[asmp].val2,"%s",k2.val);
					sprintf(pp[asmp].val3,"$T%d",rr);
				}
				else
				{
					printf(";SUBI %s %s $T%d\n",k1.val,k2.val,rr);
					asmp++;
					sprintf(pp[asmp].op,"SUBI");
					sprintf(pp[asmp].val1,"%s",k1.val);
					sprintf(pp[asmp].val2,"%s",k2.val);
					sprintf(pp[asmp].val3,"$T%d",rr);
				}
				kk++;
				sprintf(st[kk].val,"$T%d",rr);
				if(strcmp(k2.type,"FLOAT")==0 || strcmp(k1.type,"FLOAT")==0)
				{
					sprintf(st[kk].type,"FLOAT");
				}
				else{
					sprintf(st[kk].type,"INTEGER");
				}
				rr++;
			}
			if(strcmp(temp.type,"MUL")==0)
			{
				if(strcmp(k1.type,"FLOAT")==0 || strcmp(k2.type,"FLOAT")==0)
				{
					printf(";MULTF %s %s $T%d\n",k1.val,k2.val,rr);
					asmp++;
					sprintf(pp[asmp].op,"MULTF");
					sprintf(pp[asmp].val1,"%s",k1.val);
					sprintf(pp[asmp].val2,"%s",k2.val);
					sprintf(pp[asmp].val3,"$T%d",rr);
				}
				else
				{
					printf(";MULTI %s %s $T%d\n",k1.val,k2.val,rr);
					asmp++;
					sprintf(pp[asmp].op,"MULTI");
					sprintf(pp[asmp].val1,"%s",k1.val);
					sprintf(pp[asmp].val2,"%s",k2.val);
					sprintf(pp[asmp].val3,"$T%d",rr);
				}
				kk++;
				sprintf(st[kk].val,"$T%d",rr);
				if(strcmp(k2.type,"FLOAT")==0 || strcmp(k1.type,"FLOAT")==0)
				{
					sprintf(st[kk].type,"FLOAT");
				}
				else{
					sprintf(st[kk].type,"INTEGER");
				}
				rr++;
			}
			if(strcmp(temp.type,"DIV")==0)
			{
				if(strcmp(k1.type,"FLOAT")==0 || strcmp(k2.type,"FLOAT")==0)
				{
					printf(";DIVF %s %s $T%d\n",k1.val,k2.val,rr);
					asmp++;
					sprintf(pp[asmp].op,"DIVF");
					sprintf(pp[asmp].val1,"%s",k1.val);
					sprintf(pp[asmp].val2,"%s",k2.val);
					sprintf(pp[asmp].val3,"$T%d",rr);
				}
				else
				{
					printf(";DIVI %s %s $T%d\n",k1.val,k2.val,rr);
					asmp++;
					sprintf(pp[asmp].op,"DIVI");
					sprintf(pp[asmp].val1,"%s",k1.val);
					sprintf(pp[asmp].val2,"%s",k2.val);
					sprintf(pp[asmp].val3,"$T%d",rr);
				}
				kk++;
				sprintf(st[kk].val,"$T%d",rr);
				if(strcmp(k2.type,"FLOAT")==0 || strcmp(k1.type,"FLOAT")==0)
				{
					sprintf(st[kk].type,"FLOAT");
				}
				else{
					sprintf(st[kk].type,"INTEGER");
				}
				rr++;
			}	
			i++;
		}
	}

}


int yylex();
void yyerror(char const *s);

%}



%token <idd> IDENTIFIER
%token <stt> STRING_LITERAL
%token <ii> INT_LITERAL
%token <ff> FLOAT_LITERAL
%token PROGRAM _BEGIN END FUNCTION READ WRITE IF ELSE FI FOR ROF RETURN VOID INT_TYPE STRING_TYPE FLOAT_TYPE PLUS MINUS MULI DIVI EQU NOTEQU SMLBR SMRBR GREQU LSEQU SEMI GR ONEEQU LS COMMA

%union{
	int ii;
	char * ff;
	char * idd;
	char * stt;
	struct Table * ttl;
	struct ASTNode * tthj;
	char tpt;
}

%type <stt> str
%type <idd> id
%type <tthj> expr
%type <tthj> factor
%type <tthj> primary
%type <tthj> postfix_expr
%type <tthj> addop
%type <tthj> expr_prefix
%type <tthj> mulop
%type <tthj> factor_prefix
%type <tpt> compop
%type <tthj> cond
%type <tthj> assign_expr
%type <tthj> incr_stmt


%%
program:	PROGRAM id _BEGIN 
			{
				printf(";IR code\n");
				sc=0;
				count_table ++;
				for(int i=0;i<100;i++)
				{
					tk[i].tb = (struct Node *) malloc (100* sizeof(struct Node));
					tk[i].scope = (char *) malloc (100*sizeof(char));
					strcpy(tk[i].scope,"GLOBAL");
					tk[i].n_len=0;
				}
				for(int i=0;i<100;i++)
				{
					ap[i].val=(char *)malloc(sizeof(char)*100);
					ap[i].type=(char *)malloc(sizeof(char)*100);
				}
				for(int i=0;i<1000;i++)
				{
					pp[i].op=(char *)malloc(sizeof(char)*100);
					pp[i].val1=(char *)malloc(sizeof(char)*100);
					pp[i].val2=(char *)malloc(sizeof(char)*100);
					pp[i].val3=(char *)malloc(sizeof(char)*100);
				}
				for(int i=0;i<1000;i++)
				{
					mm[i].val=(char*)malloc(sizeof(char)*100);
				}
			}
			pgm_body END {
				printf(";tiny code\n");
				for(int i=0;i<=count_table;i++)
				{
					if(strcmp(tk[i].scope,"GLOBAL")==0)
					{
						for(int j=0;j<tk[i].n_len;j++)
						{
							if(strcmp(tk[i].tb[j].type,"INTEGER")==0 || strcmp(tk[i].tb[j].type,"FLOAT")==0)
							{
								printf("var %s\n",tk[i].tb[j].id);
							}
							else
							printf("str %s %s\n",tk[i].tb[j].id,tk[i].tb[j].val);
						}			
					}

				}
				printf("push\n");
				printf("push r0\n");
				printf("push r1\n");
				printf("push r2\n");
				printf("push r3\n");
				printf("jsr main\n");
				printf("sys halt\n");
				

			

				int reg=0;
				for(int i=0;i<=asmp;i++)
				{
					struct am temp=pp[i];
					if(strcmp(temp.op,"STOREI")==0 || strcmp(temp.op,"STOREF")==0)
					{
					
						if(temp.val1[0]=='$')
						{
							
							char dig[10];
							for(int i=0;i<10;i++)
							dig[i]=temp.val1[i+2];
							int rrr=atoi(dig);
							printf("move r%d %s\n",rrr-1,temp.val2);


						}
						else
						{
							char dig[10];
							for(int i=0;i<10;i++)
							dig[i]=temp.val2[i+2];
							int rrr=atoi(dig);
							printf("move %s r%d\n",temp.val1,rrr-1);

						}
					}
					if(strcmp(temp.op,"GE")==0)
					{

							char dig[10];
							for(int i=0;i<10;i++)
							dig[i]=temp.val2[i+2];
							int rrr=atoi(dig);
							printf("cmpi %s r%d\n",temp.val1,rrr-1);
							printf("jge %s\n",temp.val3);
					}
					if(strcmp(temp.op,"LT")==0)
					{
							char dig[10];
							for(int i=0;i<10;i++)
							dig[i]=temp.val2[i+2];
							int rrr=atoi(dig);
							printf("cmpi %s r%d\n",temp.val1,rrr-1);
							printf("jlt %s\n",temp.val3);
					}
					if(strcmp(temp.op,"NE")==0)
					{
							char dig[10];
							for(int i=0;i<10;i++)
							dig[i]=temp.val2[i+2];
							int rrr=atoi(dig);
							printf("cmpi %s r%d\n",temp.val1,rrr-1);
							printf("jne %s\n",temp.val3);
					}		
					if(strcmp(temp.op,"LE")==0)
					{
							char dig[10];
							for(int i=0;i<10;i++)
							dig[i]=temp.val2[i+2];
							int rrr=atoi(dig);
							printf("cmpi %s r%d\n",temp.val1,rrr-1);
							printf("jle %s\n",temp.val3);
					}	
					if(strcmp(temp.op,"EQ")==0)
					{
							char dig[10];
							for(int i=0;i<10;i++)
							dig[i]=temp.val2[i+2];
							int rrr=atoi(dig);
							printf("cmpi %s r%d\n",temp.val1,rrr-1);
							printf("jeq %s\n",temp.val3);
					}
					if(strcmp(temp.op,"GT")==0)
					{
							char dig[10];
							for(int i=0;i<10;i++)
							dig[i]=temp.val2[i+2];
							int rrr=atoi(dig);
							printf("cmpi %s r%d\n",temp.val1,rrr-1);
							printf("jgt %s\n",temp.val3);
					}
					if(strcmp(temp.op,"JUMP")==0)
					{
							printf("jmp %s\n",temp.val1);
					}
					if(strcmp(temp.op,"LABEL")==0)
					{
							printf("label %s\n",temp.val1);
							for(int i=0;i<=count_table;i++)
							{
								if(strcmp(tk[i].scope,temp.val1)==0)
								{
									printf("link %d\n",tk[i].n_len-tk[i].arggs);
									break;
								}
							}
					}
					if(strcmp(temp.op,"JSR")==0)
					{
							printf("jsr %s\n",temp.val1);
					}
					if(strcmp(temp.op,"CMPI")==0)
					{
							printf("cmpi %s %s\n",temp.val1,temp.val2);
					}
					if(strcmp(temp.op,"JEQ")==0)
					{
							printf("jeq %s\n",temp.val1);
					}
					if(strcmp(temp.op,"PUSH")==0)
					{
							printf("push %s\n",temp.val1);
					}
					if(strcmp(temp.op,"POP")==0)
					{
							printf("pop %s\n",temp.val1);
					}
					if(strcmp(temp.op,"MOVE")==0)
					{
							printf("move %s %s\n",temp.val1,temp.val2);
					}
					if(strcmp(temp.op,"RET")==0)
					{
							printf("ret\n");
					}
					if(strcmp(temp.op,"UNLNK")==0)
					{
							printf("unlnk\n");
					}
					if(strcmp(temp.op,"READI")==0)
					{
						printf("sys readi %s\n",temp.val1);
					}
					if(strcmp(temp.op,"WRITEI")==0)
					{
						printf("sys writei %s\n",temp.val1);
					}
					if(strcmp(temp.op,"READF")==0)
					{
						printf("sys readr %s\n",temp.val1);
					}
					if(strcmp(temp.op,"WRITEF")==0)
					{
						printf("sys writer %s\n",temp.val1);
					}
					if(strcmp(temp.op,"READS")==0)
					{
						printf("sys reads %s\n",temp.val1);
					}
					if(strcmp(temp.op,"WRITES")==0)
					{
						printf("sys writes %s\n",temp.val1);
					}
					if(strcmp(temp.op,"ADDI")==0)
					{
						char *v1;
						v1=(char *)malloc(sizeof(char)*100);
						char *v2;
						v2=(char *)malloc(sizeof(char)*100);
						char dig[10];
						for(int i=0;i<10;i++)
						dig[i]=temp.val3[i+2];
						int rrr=atoi(dig);
						if(temp.val1[0]=='$' && temp.val2[0]=='$')
						{
							if(temp.val1[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						else
						{
							if(temp.val1[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						printf("move %s r%d\n",v1,rrr-1);
						printf("addi %s r%d\n",v2,rrr-1);
						
						
					}
					if(strcmp(temp.op,"SUBI")==0)
					{
						char *v1;
						v1=(char *)malloc(sizeof(char)*100);
						char *v2;
						v2=(char *)malloc(sizeof(char)*100);
						char dig[10];
						for(int i=0;i<10;i++)
						dig[i]=temp.val3[i+2];
						int rrr=atoi(dig);
						if(temp.val1[0]=='$' && temp.val2[0]=='$')
						{
							if(temp.val1[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						else
						{
							if(temp.val1[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						
						printf("move %s r%d\n",v1,rrr-1);
						printf("subi %s r%d\n",v2,rrr-1);
						
					}
					if(strcmp(temp.op,"MULTI")==0)
					{
						char *v1;
						v1=(char *)malloc(sizeof(char)*100);
						char *v2;
						v2=(char *)malloc(sizeof(char)*100);
						char dig[10];
						for(int i=0;i<10;i++)
						dig[i]=temp.val3[i+2];
						int rrr=atoi(dig);
						if(temp.val1[0]=='$' && temp.val2[0]=='$')
						{
							if(temp.val1[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						else
						{
							if(temp.val1[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						
						printf("move %s r%d\n",v1,rrr-1);
						printf("muli %s r%d\n",v2,rrr-1);
						
					}
					if(strcmp(temp.op,"DIVI")==0)
					{
						char *v1;
						v1=(char *)malloc(sizeof(char)*100);
						char *v2;
						v2=(char *)malloc(sizeof(char)*100);
						char dig[10];
						for(int i=0;i<10;i++)
						dig[i]=temp.val3[i+2];
						int rrr=atoi(dig);
						if(temp.val1[0]=='$' && temp.val2[0]=='$')
						{
							if(temp.val1[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						else
						{
							if(temp.val1[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						
						printf("move %s r%d\n",v1,rrr-1);
						printf("divi %s r%d\n",v2,rrr-1);
						
					}
					if(strcmp(temp.op,"ADDF")==0)
					{
						char *v1;
						v1=(char *)malloc(sizeof(char)*100);
						char *v2;
						v2=(char *)malloc(sizeof(char)*100);
						char dig[10];
						for(int i=0;i<10;i++)
						dig[i]=temp.val3[i+2];
						int rrr=atoi(dig);
						if(temp.val1[0]=='$' && temp.val2[0]=='$')
						{
							if(temp.val1[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						else
						{
							if(temp.val1[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						
						printf("move %s r%d\n",v1,rrr-1);
						printf("addr %s r%d\n",v2,rrr-1);
						
					}
					if(strcmp(temp.op,"SUBF")==0)
					{
						char *v1;
						v1=(char *)malloc(sizeof(char)*100);
						char *v2;
						v2=(char *)malloc(sizeof(char)*100);
						char dig[10];
						for(int i=0;i<10;i++)
						dig[i]=temp.val3[i+2];
						int rrr=atoi(dig);
						if(temp.val1[0]=='$' && temp.val2[0]=='$')
						{
							if(temp.val1[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						else
						{
							if(temp.val1[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						
						printf("move %s r%d\n",v1,rrr-1);
						printf("subr %s r%d\n",v2,rrr-1);
						
					}
					if(strcmp(temp.op,"MULTF")==0)
					{
						char *v1;
						v1=(char *)malloc(sizeof(char)*100);
						char *v2;
						v2=(char *)malloc(sizeof(char)*100);
						char dig[10];
						for(int i=0;i<10;i++)
						dig[i]=temp.val3[i+2];
						int rrr=atoi(dig);
						if(temp.val1[0]=='$' && temp.val2[0]=='$')
						{
							if(temp.val1[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						else
						{
							if(temp.val1[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						
						printf("move %s r%d\n",v1,rrr-1);
						printf("mulr %s r%d\n",v2,rrr-1);
						
					}
					if(strcmp(temp.op,"DIVF")==0)
					{
						char *v1;
						v1=(char *)malloc(sizeof(char)*100);
						char *v2;
						v2=(char *)malloc(sizeof(char)*100);
						char dig[10];
						for(int i=0;i<10;i++)
						dig[i]=temp.val3[i+2];
						int rrr=atoi(dig);
						if(temp.val1[0]=='$' && temp.val2[0]=='$')
						{
							if(temp.val1[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[1]=='T')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						else
						{
							if(temp.val1[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val1[i+2];
								int rrr1=atoi(dig1);
								sprintf(v1,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v1,"%s",temp.val1);
							}
						
							if(temp.val2[0]=='$')
							{
								char dig1[10];
								for(int i=0;i<10;i++)
								dig1[i]=temp.val2[i+2];
								int rrr1=atoi(dig1);
								sprintf(v2,"r%d",rrr1-1);
							}
							else
							{
								sprintf(v2,"%s",temp.val2);
							}
						}
						
						printf("move %s r%d\n",v1,rrr-1);
						printf("divr %s r%d\n",v2,rrr-1);
						
					}
				}
				printf("end\n");

			}
;
id:			IDENTIFIER {$$ = $1;}
;
pgm_body: decl func_declarations
;
decl:	string_decl decl
	| var_decl decl
	|	
;
string_decl:	STRING_TYPE id EQU str SEMI {
	int nn = tk[count_table].n_len;
	tk[count_table].tb[nn].id = (char *) malloc (100*sizeof(char));
	tk[count_table].tb[nn].type = (char *) malloc (100*sizeof(char));
	tk[count_table].tb[nn].val = (char *) malloc (100*sizeof(char));		
	tk[count_table].tb[nn].reg = (char *) malloc (100*sizeof(char));	
	int kkl = 0;
	for(int i=0;i<nn;i++)
	{
		if(strcmp($2,tk[count_table].tb[i].id)==0)
		{
			kkl=1;
			break;
		}
	}
	if(kkl==1)
	{
		if(flag==0);
		printf("DECLARATION ERROR %s\n",$2);
		flag=1;
	}
	else{
		sprintf(tk[count_table].tb[nn].reg,"$%d",funfun);
		funfun--;
		strcpy(tk[count_table].tb[nn].id, $2);
		strcpy(tk[count_table].tb[nn].val, $4);
		strcpy(tk[count_table].tb[nn].type, "STRING");
		tk[count_table].n_len++;
	}

}
;
str:	STRING_LITERAL { $$ = $1;}
;
var_decl:	var_type id_list SEMI
;
var_type:	FLOAT_TYPE	{ fi = 2;}
	|	INT_TYPE	{ fi = 1;}
;
any_type:	var_type
		|	VOID
;
id_list:	id {
	if(rw==0)
	{
		int nn = tk[count_table].n_len;
		tk[count_table].tb[nn].id = (char *) malloc (100*sizeof(char));
		tk[count_table].tb[nn].type = (char *) malloc (100*sizeof(char));
		tk[count_table].tb[nn].val = (char *) malloc (100*sizeof(char));
		tk[count_table].tb[nn].reg = (char *) malloc (100*sizeof(char));	
		int kkl = 0;
		for(int i=0;i<nn;i++)
		{
			if(strcmp($1,tk[count_table].tb[i].id)==0)
			{
				kkl=1;
				break;
			}
		}
		if(kkl==1)
		{
			if(flag==0)
			printf("DECLARATION ERROR %s\n",$1);
			flag=1;
		}
		else{
			sprintf(tk[count_table].tb[nn].reg,"$%d",funfun);
			funfun--;
			strcpy(tk[count_table].tb[nn].id, $1);
			if(fi==1)
			strcpy(tk[count_table].tb[nn].type, "INTEGER");
			else
			strcpy(tk[count_table].tb[nn].type,"FLOAT");
			tk[count_table].n_len++;
		}
	}
	else
	{

		for(int i=0;i<=count_table;i++)
		{
			for(int j=0;j<tk[i].n_len;j++)
			{
				if(infbody==1)
				{
					if(i!=0 && i!=count_table && i!=(count_table-1))
					break;
					if(strcmp(tk[i].tb[j].id,$1)==0)
					{
						if(strcmp(tk[i].tb[j].type,"INTEGER")==0)
						{
							if(read==1)
							{
								printf(";READI %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"READI");
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
							}
							if(writ==1)
							{
								printf(";WRITEI %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"WRITEI");
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);

							}
						}
						if(strcmp(tk[i].tb[j].type,"FLOAT")==0)
						{
							if(read==1)
							{
								printf(";READF %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"READF");
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
							}
							if(writ==1)
							{
								printf(";WRITEF %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"WRITEF");
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
							}
						}
						if(strcmp(tk[i].tb[j].type,"STRING")==0)
						{
							if(read==1)
							{
								printf(";READS %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"READS");
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
							}
							if(writ==1)
							{
								printf(";WRITES %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"WRITES");
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
							}
						}
					}
				}
				else
				{
					if(strcmp(tk[i].tb[j].id,$1)==0 && (i==0 || i==count_table))
					{
						if(strcmp(tk[i].tb[j].type,"INTEGER")==0)
						{
							if(read==1)
							{
								printf(";READI %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"READI");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
							if(writ==1)
							{
								printf(";WRITEI %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"WRITEI");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
						}
						if(strcmp(tk[i].tb[j].type,"FLOAT")==0)
						{
							if(read==1)
							{
								printf(";READF %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"READF");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
							if(writ==1)
							{
								printf(";WRITEF %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"WRITEF");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
						}
						if(strcmp(tk[i].tb[j].type,"STRING")==0)
						{
							if(read==1)
							{
								printf(";READS %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"READS");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
							if(writ==1)
							{
								printf(";WRITES %s\n",$1);
								asmp++;
								sprintf(pp[asmp].op,"WRITES");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
						}
					}
				}
			}
		}
	}


}
		id_tail
;
id_tail:	|	COMMA id{
	if(rw==0)
	{
		int nn = tk[count_table].n_len;
		tk[count_table].tb[nn].id = (char *) malloc (100*sizeof(char));
		tk[count_table].tb[nn].type = (char *) malloc (100*sizeof(char));
		tk[count_table].tb[nn].val = (char *) malloc (100*sizeof(char));
		tk[count_table].tb[nn].reg = (char *) malloc (100*sizeof(char));
		int kkl = 0;
		for(int i=0;i<nn;i++)
		{
			if(strcmp($2,tk[count_table].tb[i].id)==0)
			{
				kkl=1;
				break;
			}
		}
		if(kkl==1)
		{
			if(flag==0);
			printf("DECLARATION ERROR %s\n",$2);
			flag=1;
		}
		else{
			sprintf(tk[count_table].tb[nn].reg,"$%d",funfun);
			funfun--;
			strcpy(tk[count_table].tb[nn].id, $2);
			if(fi==1)
			strcpy(tk[count_table].tb[nn].type, "INTEGER");
			else
			strcpy(tk[count_table].tb[nn].type,"FLOAT");
			tk[count_table].n_len++;
		}
	}
	else
	{
		for(int i=0;i<=count_table;i++)
		{
			for(int j=0;j<tk[i].n_len;j++)
			{
				if(infbody==1)
				{
					if(i!=0 && i!=count_table && i!=(count_table-1))
					break;
					if(strcmp(tk[i].tb[j].id,$2)==0)
					{
						if(strcmp(tk[i].tb[j].type,"INTEGER")==0)
						{
							if(read==1)
							{
								printf(";READI %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"READI");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
							if(writ==1)
							{
								printf(";WRITEI %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"WRITEI");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
						}
						if(strcmp(tk[i].tb[j].type,"FLOAT")==0)
						{
							if(read==1)
							{
								printf(";READF %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"READF");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
							if(writ==1)
							{
								printf(";WRITEF %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"WRITEF");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
						}
						if(strcmp(tk[i].tb[j].type,"STRING")==0)
						{
							if(read==1)
							{
								printf(";READS %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"READS");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
							if(writ==1)
							{
								printf(";WRITES %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"WRITES");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
						}
					}
				}
				else
				{
					if(strcmp(tk[i].tb[j].id,$2)==0 && (i==0 || i==count_table))
					{
						if(strcmp(tk[i].tb[j].type,"INTEGER")==0)
						{
							if(read==1)
							{
								printf(";READI %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"READI");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
							if(writ==1)
							{
								printf(";WRITEI %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"WRITEI");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
						}
						if(strcmp(tk[i].tb[j].type,"FLOAT")==0)
						{
							if(read==1)
							{
								printf(";READF %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"READF");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
							if(writ==1)
							{
								printf(";WRITEF %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"WRITEF");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
						}
						if(strcmp(tk[i].tb[j].type,"STRING")==0)
						{
							if(read==1)
							{
								printf(";READS %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"READS");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
							if(writ==1)
							{
								printf(";WRITES %s\n",$2);
								asmp++;
								sprintf(pp[asmp].op,"WRITES");
								if(count_table==i)
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].reg);
								else
								sprintf(pp[asmp].val1,"%s",tk[i].tb[j].id);
							}
						}
					}
				}
			}
		}
	}

}
			id_tail
;
param_decl_list:	param_decl param_decl_tail 
				|	
;
param_decl:	var_type id{
	argg++;
	int nn = tk[count_table].n_len;
	tk[count_table].tb[nn].id = (char *) malloc (100*sizeof(char));
	tk[count_table].tb[nn].type = (char *) malloc (100*sizeof(char));
	tk[count_table].tb[nn].val = (char *) malloc (100*sizeof(char));	
	tk[count_table].tb[nn].reg = (char *) malloc (100*sizeof(char));
	int kkl = 0;
	for(int i=0;i<nn;i++)
	{
		if(strcmp($2,tk[count_table].tb[i].id)==0)
		{
			kkl=1;
			break;
		}
	}
	if(kkl==1)
	{
		if(flag==0);
		printf("DECLARATION ERROR %s\n",$2);
		flag=1;
	}
	else{
		
		strcpy(tk[count_table].tb[nn].id, $2);
		if(fi==1)
		strcpy(tk[count_table].tb[nn].type, "INT");
		else
		strcpy(tk[count_table].tb[nn].type,"FLOAT");
		
		tk[count_table].n_len++;
	}	
}
;
param_decl_tail:	COMMA param_decl param_decl_tail 
				|	
;
func_declarations:	func_decl func_declarations 
	|	
;
func_decl:	FUNCTION any_type id {
				rr=1;
				argg=0;
				printf(";LABEL %s\n",$3);
				sc=1;
				count_table++;
				strcpy(tk[count_table].scope,$3);
				tk[count_table].arggs=0;
				asmp++;
				sprintf(pp[asmp].op,"LABEL");
				sprintf(pp[asmp].val1,"%s",$3);
				funfun=-1;
				param=1;
			}
			SMLBR param_decl_list{
				int kkll=5+argg;
				for(int i=0;i<tk[count_table].n_len;i++)
				{
					sprintf(tk[count_table].tb[i].reg,"$%d",kkll);
					kkll--;
				}
			} SMRBR{
			tk[count_table].arggs=argg;
			argg=0;	
			} _BEGIN func_body END {
			printf(";RET\n");
	
}
;
func_body:	decl stmt_list
;
stmt_list:	stmt stmt_list
	|
;
stmt:	base_stmt
	| if_stmt 
	| for_stmt
;
base_stmt:	assign_stmt
	| read_stmt
	| write_stmt
	| return_stmt
;
assign_stmt:	assign_expr SEMI {}
;
assign_expr:	id EQU expr{

	if(calll==1)
	{
		asmp++;
		sprintf(pp[asmp].op,"POP");
		sprintf(pp[asmp].val1,"r%d",rr-1);
		asmp++;
		sprintf(pp[asmp].op,"MOVE");
		sprintf(pp[asmp].val1,"r%d",rr-1);
		if(infbody==1)
		{
			for(int i=0;i<tk[count_table].n_len;i++)
			{
				if(strcmp(tk[count_table].tb[i].id,$1)==0)
				{
				if(strcmp(tk[count_table].tb[i].reg,"")!=0)
				sprintf(pp[asmp].val2,"%s",tk[count_table].tb[i].reg);
				else
				sprintf(pp[asmp].val2,"%s",$1);
				break;
				}
			}
			
			for(int i=0;i<tk[count_table-1].n_len;i++)
			{
				if(strcmp(tk[count_table-1].tb[i].id,$1)==0)
				{
				if(strcmp(tk[count_table-1].tb[i].reg,"")!=0)
				sprintf(pp[asmp].val2,"%s",tk[count_table-1].tb[i].reg);
				else
				sprintf(pp[asmp].val2,"%s",$1);
				break;
				}
			}
			
		}
		else
		{
			for(int i=0;i<tk[count_table].n_len;i++)
			{
				if(strcmp(tk[count_table].tb[i].id,$1)==0)
				{
				if(strcmp(tk[count_table].tb[i].reg,"")!=0)
				sprintf(pp[asmp].val2,"%s",tk[count_table].tb[i].reg);
				else
				sprintf(pp[asmp].val2,"%s",$1);
				break;
				}
			}
		}

		rr++;
	}
	else
	{
		top=-1;
		struct ASTNode * nod;
		nod = (struct ASTNode *)malloc(sizeof(struct ASTNode));
		nod->left=NULL;
		nod->right=NULL;
		nod->val = (char *)malloc(sizeof(char)*100);
		nod->type = (char *)malloc(sizeof(char)*100);
		sprintf(nod->val,"=");
		sprintf(nod->type,"EQUAL");
	
		struct ASTNode * ik;
		ik = (struct ASTNode *)malloc(sizeof(struct ASTNode));
		ik->left=NULL;
		ik->right=NULL;
		ik->val = (char *)malloc(sizeof(char)*100);
		ik->type = (char *)malloc(sizeof(char)*100);
		
		if(initstmtinit==1)
		{
			for(int i=0;i<tk[count_table-1].n_len;i++)
			{
				if(strcmp(tk[count_table-1].tb[i].id,$1)==0)
				{
					if(strcmp(tk[count_table-1].tb[i].reg,"")!=0)
					sprintf(ik->val,"%s",tk[count_table-1].tb[i].reg);
					else
					sprintf(ik->val,"%s",$1);
					break;
				}
			}
			initstmtinit=0;
		}
		else
		{
			if(forfor==1)
			{
				for(int i=0;i<tk[count_table-1].n_len;i++)
				{
					if(strcmp(tk[count_table-1].tb[i].id,$1)==0)
					{
						if(strcmp(tk[count_table-1].tb[i].reg,"")!=0)
						sprintf(ik->val,"%s",tk[count_table-1].tb[i].reg);
						else
						sprintf(ik->val,"%s",$1);
						break;
					}
				}
			}
	
			for(int i=0;i<tk[count_table].n_len;i++)
			{
				if(strcmp(tk[count_table].tb[i].id,$1)==0)
				{
					if(strcmp(tk[count_table].tb[i].reg,"")!=0)
					sprintf(ik->val,"%s",tk[count_table].tb[i].reg);
					else
					sprintf(ik->val,"%s",$1);
					break;
				}
			}
		}
		sprintf(ik->type,"IDENTIFIER");

		nod->left=ik;
		nod->right=$3;
		if(forfor==0)
		{
			do_post(nod);	
			do_ir(nod);	
		}
		$$=nod;
	}
	calll=0;

}
;
read_stmt:	READ{rw=1;read=1;} SMLBR id_list SMRBR SEMI {rw=0;read=0;}
;
write_stmt:	WRITE{rw=1;writ=1;} SMLBR id_list SMRBR SEMI{rw=0;writ=0;}
;
return_stmt:	RETURN expr SEMI{
	if(strcmp($2->type,"IDENTIFIER")==0)
	{
		asmp++;
		sprintf(pp[asmp].op,"MOVE");
		sprintf(pp[asmp].val1,"%s",$2->val);
		sprintf(pp[asmp].val2,"r%d",rr-1);
		
		asmp++;
		sprintf(pp[asmp].op,"MOVE");
		sprintf(pp[asmp].val1,"r%d",rr-1);
		sprintf(pp[asmp].val2,"$%d",tk[count_table].arggs+6);
		rr++;

	asmp++;
	sprintf(pp[asmp].op,"UNLNK");
	asmp++;
	sprintf(pp[asmp].op,"RET");

	}
	else
	{
		top=-1;
		do_post($2);
		do_ir($2);
		asmp++;
		sprintf(pp[asmp].op,"MOVE");
		sprintf(pp[asmp].val1,"r%d",rr-2);
		sprintf(pp[asmp].val2,"$%d",tk[count_table].arggs+6);
		
	asmp++;
	sprintf(pp[asmp].op,"UNLNK");
	asmp++;
	sprintf(pp[asmp].op,"RET");
	}
}
;

expr:	expr_prefix factor {
	if($1==NULL)
	{
		$$=$2;
	}
	else
	{
		struct ASTNode*tt;
		tt=$1;
		while(tt->right!=NULL)
		tt=tt->right;
		tt->right=$2;
		$$=$1;
	}
}
;
expr_prefix:	expr_prefix factor addop{
	if($1==NULL)
	{
		$3->left=$2;
		$$=$3;
	}
	else{
		$1->right=$2;
		$3->left=$1;
		$$=$3;
	}
}
	|{$$=NULL;}
;
factor:	factor_prefix postfix_expr {
	if($1==NULL)
	{
		$$=$2;
	}
	else
	{
		struct ASTNode*tt;
		tt=$1;
		while(tt->right!=NULL)
		tt=tt->right;
		tt->right=$2;
		$$=$1;
	}
}
;
factor_prefix:	factor_prefix postfix_expr mulop{
	if($1==NULL)
	{
		$3->left=$2;
		$$=$3;
	}
	else{

		$3->left=$2;
		struct ASTNode * tt;
		tt=$1;
		while(tt->right!=NULL)
		tt=tt->right;
		tt->right=$3;
		$$=$1;
	}	
}
	|{$$=NULL;}
;
postfix_expr:	primary {$$=$1;}
	| call_expr {$$=NULL;}
;
call_expr:	id SMLBR{
	argg=0;
	asmp++;
	sprintf(pp[asmp].op,"PUSH");
	sprintf(pp[asmp].val1," ");
} expr_list SMRBR{
	for(int i=0;i<=3;i++)
	{
		asmp++;
		sprintf(pp[asmp].op,"PUSH");
		sprintf(pp[asmp].val1,"r%d",i);
	}
	asmp++;
	sprintf(pp[asmp].op,"JSR");
	sprintf(pp[asmp].val1,"%s",$1);
	
	for(int i=3;i>=0;i--)
	{
		asmp++;
		sprintf(pp[asmp].op,"POP");
		sprintf(pp[asmp].val1,"r%d",i);
	}
	for(int i=0;i<argg;i++)
	{
		asmp++;
		sprintf(pp[asmp].op,"POP");
		sprintf(pp[asmp].val1," ");
		
	}
	argg=0;
	calll=1;

}
;
expr_list:	expr {
	if(strcmp($1->type,"IDENTIFIER")==0)
	{
		argg++;
		asmp++;
		sprintf(pp[asmp].op,"PUSH");
		sprintf(pp[asmp].val1,"%s",$1->val);

	}
	else
	{
		argg++;
		top=-1;
		do_post($1);
		do_ir($1);
		asmp++;
		sprintf(pp[asmp].op,"PUSH");
		sprintf(pp[asmp].val1,"r%d",rr-2);
	}
}expr_list_tail 
	|
;
expr_list_tail:	COMMA expr{
	if(strcmp($2->type,"IDENTIFIER")==0)
	{
		argg++;
		asmp++;
		sprintf(pp[asmp].op,"PUSH");
		sprintf(pp[asmp].val1,"%s",$2->val);

	}
} expr_list_tail
	|
;
primary:	SMLBR expr SMRBR {$$=$2;}
	| id {
	struct ASTNode * nod;
	nod = (struct ASTNode *)malloc(sizeof(struct ASTNode));
	nod->left=NULL;
	nod->right=NULL;
	nod->val = (char *)malloc(sizeof(char)*100);
	nod->type = (char *)malloc(sizeof(char)*100);
	if(condstmt==1)
	{
		for(int i=0;i<tk[count_table-1].n_len;i++)
		{
			if(strcmp(tk[count_table-1].tb[i].id,$1)==0)
			{
				if(strcmp(tk[count_table-1].tb[i].reg,"")!=0)
				sprintf(nod->val,"%s",tk[count_table-1].tb[i].reg);
				else
				sprintf(nod->val,"%s",$1);
				break;
			}
		}
	}
	else
	{
		if(infbody==1)
		{
			for(int i=0;i<tk[count_table].n_len;i++)
			{
				if(strcmp(tk[count_table].tb[i].id,$1)==0)
				{
					if(strcmp(tk[count_table].tb[i].reg,"")!=0)
					sprintf(nod->val,"%s",tk[count_table].tb[i].reg);
					else
					sprintf(nod->val,"%s",$1);
					break;
				}
			}
			
			for(int i=0;i<tk[count_table-1].n_len;i++)
			{
				if(strcmp(tk[count_table-1].tb[i].id,$1)==0)
				{
					if(strcmp(tk[count_table-1].tb[i].reg,"")!=0)
					sprintf(nod->val,"%s",tk[count_table-1].tb[i].reg);
					else
					sprintf(nod->val,"%s",$1);
					break;
				}
			}
			
		}
		else
		{
			for(int i=0;i<tk[count_table].n_len;i++)
			{
				if(strcmp(tk[count_table].tb[i].id,$1)==0)
				{
					if(strcmp(tk[count_table].tb[i].reg,"")!=0)
					sprintf(nod->val,"%s",tk[count_table].tb[i].reg);
					else
					sprintf(nod->val,"%s",$1);
					break;
				}
			}
		}
		
	}
	sprintf(nod->type,"IDENTIFIER");
	$$=nod;
	}	
	| INT_LITERAL{
	struct ASTNode * nod;
	nod = (struct ASTNode *)malloc(sizeof(struct ASTNode));
	nod->left=NULL;
	nod->right=NULL;
	nod->val = (char *)malloc(sizeof(char)*100);
	nod->type = (char *)malloc(sizeof(char)*100);
	sprintf(nod->val,"%d",$1);
	sprintf(nod->type,"INTEGER");
	$$=nod;
	}
	| FLOAT_LITERAL{
	struct ASTNode * nod;
	nod = (struct ASTNode *)malloc(sizeof(struct ASTNode));
	nod->left=NULL;
	nod->right=NULL;
	nod->val = (char *)malloc(sizeof(char)*100);
	nod->type = (char *)malloc(sizeof(char)*100);
	sprintf(nod->val,"%s",$1);
	sprintf(nod->type,"FLOAT");
	$$=nod;
	}
;
addop:	PLUS{
	struct ASTNode * nod;
	nod = (struct ASTNode *)malloc(sizeof(struct ASTNode));
	nod->left=NULL;
	nod->right=NULL;
	nod->val = (char *)malloc(sizeof(char)*100);
	nod->type = (char *)malloc(sizeof(char)*100);	
	sprintf(nod->val,"+");
	sprintf(nod->type,"PLUS");
	$$=nod;
}
	|	MINUS{
	struct ASTNode * nod;
	nod = (struct ASTNode *)malloc(sizeof(struct ASTNode));
	nod->left=NULL;
	nod->right=NULL;
	nod->val = (char *)malloc(sizeof(char)*100);
	nod->type = (char *)malloc(sizeof(char)*100);	
	sprintf(nod->val,"-");
	sprintf(nod->type,"MINUS");
	$$=nod;
	}
;
mulop:	MULI{
	struct ASTNode * nod;
	nod = (struct ASTNode *)malloc(sizeof(struct ASTNode));
	nod->left=NULL;
	nod->right=NULL;
	nod->val = (char *)malloc(sizeof(char)*100);
	nod->type = (char *)malloc(sizeof(char)*100);	
	sprintf(nod->val,"*");
	sprintf(nod->type,"MUL");
	$$=nod;
}
	|	DIVI{
	struct ASTNode * nod;
	nod = (struct ASTNode *)malloc(sizeof(struct ASTNode));
	nod->left=NULL;
	nod->right=NULL;
	nod->val = (char *)malloc(sizeof(char)*100);
	nod->type = (char *)malloc(sizeof(char)*100);	
	sprintf(nod->val,"/");
	sprintf(nod->type,"DIV");
	$$=nod;
	}
;
if_stmt:	IF SMLBR cond SMRBR{
	lb++;
	iff++;
	ife[iff]=lb;
	if(strcmp($3->val,"<")==0)
	{
		printf(";STOREI %s $T%d\n",$3->right->val,rr);
		printf(";GE %s $T%d label%d\n",$3->left->val,rr,lb);

		asmp++;
		sprintf(pp[asmp].op,"STOREI");
		sprintf(pp[asmp].val1,"%s",$3->right->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"GE");
		sprintf(pp[asmp].val1,"%s",$3->left->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		sprintf(pp[asmp].val3,"label%d",lb);
		rr++;
	}
	if (strcmp($3->val,"#")==0){
		printf(";STOREI %s $T%d\n",$3->right->val,rr);
		printf(";LT %s $T%d label%d\n",$3->left->val,rr,lb);
		asmp++;
		sprintf(pp[asmp].op,"STOREI");
		sprintf(pp[asmp].val1,"%s",$3->right->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"LT");
		sprintf(pp[asmp].val1,"%s",$3->left->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		sprintf(pp[asmp].val3,"label%d",lb);
		rr++;
	}
	if (strcmp($3->val,"=")==0){
		printf(";STOREI %s $T%d\n",$3->right->val,rr);
		printf(";NE %s $T%d label%d\n",$3->left->val,rr,lb);
		asmp++;
		sprintf(pp[asmp].op,"STOREI");
		sprintf(pp[asmp].val1,"%s",$3->right->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"NE");
		sprintf(pp[asmp].val1,"%s",$3->left->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		sprintf(pp[asmp].val3,"label%d",lb);
		rr++;
	}
	if (strcmp($3->val,">")==0){
		printf(";STOREI %s $T%d\n",$3->right->val,rr);
		printf(";LE %s $T%d label%d\n",$3->left->val,rr,lb);
		asmp++;
		sprintf(pp[asmp].op,"STOREI");
		sprintf(pp[asmp].val1,"%s",$3->right->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"LE");
		sprintf(pp[asmp].val1,"%s",$3->left->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		sprintf(pp[asmp].val3,"label%d",lb);
		rr++;
	}
	if (strcmp($3->val,"!")==0){
		printf(";STOREI %s $T%d\n",$3->right->val,rr);
		printf(";EQ %s $T%d label%d\n",$3->left->val,rr,lb);
		asmp++;
		sprintf(pp[asmp].op,"STOREI");
		sprintf(pp[asmp].val1,"%s",$3->right->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"EQ");
		sprintf(pp[asmp].val1,"%s",$3->left->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		sprintf(pp[asmp].val3,"label%d",lb);
		rr++;
	}
	if (strcmp($3->val,"@")==0){
		printf(";STOREI %s $T%d\n",$3->right->val,rr);
		printf(";GT %s $T%d label%d\n",$3->left->val,rr,lb);
		asmp++;
		sprintf(pp[asmp].op,"STOREI");
		sprintf(pp[asmp].val1,"%s",$3->right->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"GT");
		sprintf(pp[asmp].val1,"%s",$3->left->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		sprintf(pp[asmp].val3,"label%d",lb);
		rr++;
	}

	block++;
	count_table++;
	strcpy(tk[count_table].scope,"BLOCK ");
	char rel[10];
	sprintf(rel,"%d",block);
	strcat(tk[count_table].scope,rel);
	for(int i=0;i<tk[count_table-1].n_len;i++)
	{
		tk[count_table].tb[i].id = (char *) malloc (100*sizeof(char));
		tk[count_table].tb[i].type = (char *) malloc (100*sizeof(char));
		tk[count_table].tb[i].val = (char *) malloc (100*sizeof(char));	
		tk[count_table].tb[i].reg = (char *) malloc (100*sizeof(char));
		sprintf(tk[count_table].tb[i].id,"%s",tk[count_table-1].tb[i].id);
		sprintf(tk[count_table].tb[i].val,"%s",tk[count_table-1].tb[i].val);
		sprintf(tk[count_table].tb[i].type,"%s",tk[count_table-1].tb[i].type);
		sprintf(tk[count_table].tb[i].reg,"%s",tk[count_table-1].tb[i].reg);
		tk[count_table].n_len++;
	}
	tk[count_table].arggs=tk[count_table-1].arggs;
} decl stmt_list{
	lb++;
	for(int i=iff;i>=0;i--)
	{
		ife[i+1]=ife[i];
	}
	ife[0]=lb;
	iff++;
	printf(";JUMP label%d\n",lb);
	asmp++;
	sprintf(pp[asmp].op,"JUMP");
	sprintf(pp[asmp].val1,"label%d",lb);
	
	
	printf(";LABEL label%d\n",ife[iff]);
	asmp++;
	sprintf(pp[asmp].op,"LABEL");
	sprintf(pp[asmp].val1,"label%d",ife[iff]);
	iff--;

} else_part FI{
	printf(";LAEBL label%d\n",ife[0]);
	asmp++;
	sprintf(pp[asmp].op,"LABEL");
	sprintf(pp[asmp].val1,"label%d",ife[0]);
	for(int i=0;i<iff;i++)
	ife[i]=ife[i+1];
	iff--;
}
;
else_part:	ELSE{

	block++;
	count_table++;
	strcpy(tk[count_table].scope,"BLOCK ");
	char rel[10];
	sprintf(rel,"%d",block);
	strcat(tk[count_table].scope,rel);
	for(int i=0;i<tk[count_table-2].n_len;i++)
	{
		tk[count_table].tb[i].id = (char *) malloc (100*sizeof(char));
		tk[count_table].tb[i].type = (char *) malloc (100*sizeof(char));
		tk[count_table].tb[i].val = (char *) malloc (100*sizeof(char));	
		tk[count_table].tb[i].reg = (char *) malloc (100*sizeof(char));
		sprintf(tk[count_table].tb[i].id,"%s",tk[count_table-2].tb[i].id);
		sprintf(tk[count_table].tb[i].val,"%s",tk[count_table-2].tb[i].val);
		sprintf(tk[count_table].tb[i].type,"%s",tk[count_table-2].tb[i].type);
		sprintf(tk[count_table].tb[i].reg,"%s",tk[count_table-2].tb[i].reg);
		tk[count_table].n_len++;
	}
	tk[count_table].arggs=tk[count_table-2].arggs;

} decl stmt_list
	| 
;
cond:	expr compop expr{
	struct ASTNode * nod;
	nod = (struct ASTNode *)malloc(sizeof(struct ASTNode));
	nod->left=NULL;
	nod->right=NULL;
	nod->val = (char *)malloc(sizeof(char)*100);
	nod->type = (char *)malloc(sizeof(char)*100);	
	sprintf(nod->val,"%c",$2);
	sprintf(nod->type,"COMP");
	nod->left=$1;
	nod->right=$3;
	$$=nod;
	if(condstmt==1)
	condstmt=0;
}
;
compop:	LS {$$='<';}
	|	GR {$$='>';}
	|	ONEEQU {$$='=';}
	|	NOTEQU {$$='!';}
	|	LSEQU {$$='@';}
	|	GREQU {$$ ='#';}
;
init_stmt:	assign_expr 
	|
;
incr_stmt:	assign_expr {$$=$1;}
	|{$$=NULL;}
;
for_stmt:	FOR SMLBR{
	block++;
	count_table++;
	strcpy(tk[count_table].scope,"BLOCK ");
	initstmtinit=1;
	char rel[10];
	sprintf(rel,"%d",block);
	strcat(tk[count_table].scope,rel);
	condstmt=1;
} init_stmt SEMI cond SEMI{
	lb++;
	iff++;
	ife[iff]=lb;
	printf(";LABEL label%d\n",lb);
	asmp++;
	sprintf(pp[asmp].op,"LABEL");
	sprintf(pp[asmp].val1,"label%d",lb);
	
	
	lb++;
	for(int i=iff;i>=0;i--)
	ife[i+1]=ife[i];
	ife[0]=lb;
	iff++;
	if(strcmp($6->val,"<")==0)
	{
		printf(";STOREI %s $T%d\n",$6->right->val,rr);
		printf(";GE %s $T%d label%d\n",$6->left->val,rr,lb);

		asmp++;
		sprintf(pp[asmp].op,"STOREI");
		sprintf(pp[asmp].val1,"%s",$6->right->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"GE");
		sprintf(pp[asmp].val1,"%s",$6->left->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		sprintf(pp[asmp].val3,"label%d",lb);
		rr++;
	}
	if (strcmp($6->val,"#")==0){
		printf(";STOREI %s $T%d\n",$6->right->val,rr);
		printf(";LT %s $T%d label%d\n",$6->left->val,rr,lb);
		asmp++;
		sprintf(pp[asmp].op,"STOREI");
		sprintf(pp[asmp].val1,"%s",$6->right->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"LT");
		sprintf(pp[asmp].val1,"%s",$6->left->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		sprintf(pp[asmp].val3,"label%d",lb);
		rr++;
	}
	if (strcmp($6->val,"=")==0){
		printf(";STOREI %s $T%d\n",$6->right->val,rr);
		printf(";NE %s $T%d label%d\n",$6->left->val,rr,lb);
		asmp++;
		sprintf(pp[asmp].op,"STOREI");
		sprintf(pp[asmp].val1,"%s",$6->right->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"NE");
		sprintf(pp[asmp].val1,"%s",$6->left->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		sprintf(pp[asmp].val3,"label%d",lb);
		rr++;
	}
	if (strcmp($6->val,">")==0){
		printf(";STOREI %s $T%d\n",$6->right->val,rr);
		printf(";LE %s $T%d label%d\n",$6->left->val,rr,lb);
		asmp++;
		sprintf(pp[asmp].op,"STOREI");
		sprintf(pp[asmp].val1,"%s",$6->right->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"LE");
		sprintf(pp[asmp].val1,"%s",$6->left->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		sprintf(pp[asmp].val3,"label%d",lb);
		rr++;
	}
	if (strcmp($6->val,"!")==0){
		printf(";STOREI %s $T%d\n",$6->right->val,rr);
		printf(";EQ %s $T%d label%d\n",$6->left->val,rr,lb);
		
		asmp++;
		sprintf(pp[asmp].op,"MOVE");
		sprintf(pp[asmp].val1,"%s",$6->right->val);
		sprintf(pp[asmp].val2,"r%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"CMPI");
		sprintf(pp[asmp].val1,"%s",$6->left->val);
		sprintf(pp[asmp].val2,"r%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"JEQ");
		sprintf(pp[asmp].val1,"label%d",lb);
		rr++;
		
	}
	if (strcmp($6->val,"@")==0){
		printf(";STOREI %s $T%d\n",$6->right->val,rr);
		printf(";GT %s $T%d label%d\n",$6->left->val,rr,lb);
		asmp++;
		sprintf(pp[asmp].op,"STOREI");
		sprintf(pp[asmp].val1,"%s",$6->right->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		
		asmp++;
		sprintf(pp[asmp].op,"GT");
		sprintf(pp[asmp].val1,"%s",$6->left->val);
		sprintf(pp[asmp].val2,"$T%d",rr);
		sprintf(pp[asmp].val3,"label%d",lb);
		rr++;
	}
	forfor=1;
	infbody=1;
	
	
	
} incr_stmt{
	forfor=0;
} SMRBR decl stmt_list ROF{
	do_post($9);
	do_ir($9);
	printf(";JUMP label%d\n",ife[iff]);
	asmp++;
	sprintf(pp[asmp].op,"JUMP");
	sprintf(pp[asmp].val1,"label%d",ife[iff]);
	iff--;
	
	printf(";LABEL label%d\n",ife[0]);
	asmp++;
	sprintf(pp[asmp].op,"LABEL");
	sprintf(pp[asmp].val1,"label%d",ife[0]);
	for(int i=0;i<iff;i++)
	ife[i]=ife[i-1];
	iff--;
	infbody=0;
	
}
;

%%

