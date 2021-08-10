%{
	#include<stdio.h>
	#include <math.h>
	int cnt=1,cntt=0,val,track=0;
	typedef struct entry {
    	char *str;
    	int n;
	}store;
	store st[1000],sym[1000];
	void ins(store *p, char *s, int n);
	int cnt2=1; 
	
	
%}
%union 
{
        int number;
        char *string;
}
/* BISON Declarations */

%token<number> NUM
%token<string> VAR 
%token<string> IF ELIF ELSE MAIN INT FLOAT DOUBLE CHAR LP RP LB RB CM SM PLUS MINUS MULT DIV POW ASSIGN FOR COL WHILE BREAK DEFAULT CASE SWITCH inc
%type <string> statement
%type <number> expression
%type <number> switch_expression
%nonassoc ELIF
%nonassoc ELSE
%left LT GT
%left PLUS MINUS
%left MULT DIV
%left POW

/* Simple grammar rules */

%%

program: MAIN LP RP LB cstatement RB { printf("\nSuccessful compilation\n"); }
	 ;

cstatement: /* empty */

	| cstatement statement
	
	| cdeclaration
	;

cdeclaration:	TYPE ID1 SM	{ printf("\nvalid declaration\n"); }

TYPE : INT

     | FLOAT

     | CHAR
     ;

ID1  : ID1 CM VAR	{
						if(look_for_key($3))
						{
							printf("%s is already declared\n", $3 );
						}
						else
						{
							ins(&st[cnt],$3, cnt);
							cnt++;
							
						}
			}

     |VAR	{
				if(look_for_key($1))
				{
					printf("%s is already declared\n", $1 );
				}
				else
				{
					ins(&st[cnt],$1, cnt);
					cnt++;
				}
			}
     ;


statement: SM
	| SWITCH LP switch_expression RP LB BASE RB    {printf("SWITCH case.\n");val=$3;} 

	| expression SM 			{ printf("\nvalue of expression: %d\n", ($1)); }

       

	| IF LP expression RP LB statement RB {
								if($3)
								{
									printf("\nWe are  in IF and the value is: %d\n",($6));
								}
								else
								{
									printf("\ncondition value zero in IF block\n");
								}
							}

	| IF LP expression RP LB statement RB ELSE LB statement RB {
								 	if($3)
									{
										printf("\nWe are in IF: %d\n",$6);
									}
									else
									{
										printf("\nWe are in ELSE and the value is : %d\n",$10);
									}
								   }													   
	| FOR LP NUM COL NUM RP LB expression RB     {
	   printf("For Loop :\n");
	   int i;
	   for(i=$3;i<$5;i++){
	   printf("Step : %d and value of expression : %d\n",i,$8);
	   }
	}
	/*while loop starts*/

	| WHILE LP NUM LT NUM RP LB expression RB   {
								int i = $5,j=0;
								printf("While LOOP:\n");
								while($3 < i)
								{
									printf("step: %d value of expression :%d \n" ,j, $8);
									i--;
									j++;
								}
								printf("\n");
								
										

						}
	;
	
	|WHILE LP NUM GT NUM RP LB expression RB   {
								int i = $5,j=0;
								printf("While LOOP:\n");
								while($3 > i)
								{
									printf("step: %d value of expression :%d \n" ,j, $8);
									i++;
									j++;
								}
								printf("\n");
								
										

						}
	;
///////////////////////
	
			BASE : Bas   
				 | Bas Dflt 
				 ;

			Bas   : /*NULL*/
				 | Bas Cs     
				 ;

			Cs    : CASE NUM COL expression SM   {
						
						if(val==$2){
							  track=1;
							  printf("\nCase No : %d  and Result :  %d\n",$2,$4);
						}
					}
				 ;

			Dflt    : DEFAULT COL expression SM    {
						if(track!=1){
							printf("\nResult in default Value is :  %d\n",$3);
						}
						track=0;
					}
				 ;    
	/////////////////////////////
	
	
expression: NUM				{ $$ = $1; 	}

	| expression PLUS expression	{ $$ = $1 + $3; }

	| expression MINUS expression	{ $$ = $1 - $3; }

	| expression MULT expression	{ $$ = $1 * $3; }

	| expression DIV expression	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    	}
	| expression POW expression { $$ = pow($1,$3); }


	| expression LT expression	{ $$ = $1 < $3; }

	| expression GT expression	{ $$ = $1 > $3; }

	| LP expression RP		{ $$ = $2;	}
	
	| inc expression inc         { $$=$2+1; printf("inc: %d\n",$$);}

	
	;
	///////////////////////////////////////
	switch_expression: NUM				{ $$ = $1; val = $$;	}

	| switch_expression PLUS switch_expression	{ $$ = $1 + $3; val = $$; }

	| switch_expression MINUS switch_expression	{ $$ = $1 - $3; val = $$; }

	| switch_expression MULT switch_expression	{ $$ = $1 * $3;  val = $$;}

	| switch_expression DIV switch_expression	{ 	if($3) 
				  		{
				     			$$ = $1 / $3; val = $$;
				  		}
				  		else
				  		{
							$$ = 0;
							 val = $$;
				  		} 	
				    	}
	| switch_expression POW switch_expression { $$ = pow($1,$3);  val = $$;}

	
	;
%%
//////////////////////////
void ins(store *p, char *s, int n)
{
  p->str = s;
  p->n = n;
}

int look_for_key(char *key)
{
    int i = 1;
    char *name = st[i].str;
    while (name) {
        if (strcmp(name, key) == 0)
            return st[i].n;
        name = st[++i].str;
    }
    return 0;
}
/////////////////////////


///////////////////////////


int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}