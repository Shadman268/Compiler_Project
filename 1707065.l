
%{
	#include<stdio.h>
	#include <string.h>
	#include "1707065.tab.h"
	#include<stdlib.h>
	

%}

identifiers "variable_"[a-zA-Z]([a-zA-Z0-9])*
unary_operator "inc"|"dec"
single_line_comment [/][/].*
multiple_line_comment [ ]*[/]"cmnt"[/][a-zA-Z0-9!@#*(){}_+-,.:\|?><\n\t ]*[/]"cmnt"[/]

/*RE and Action*/

%%


{single_line_comment} {
	printf("single line comment\n");

}
{multiple_line_comment} {
	printf("multiple_line_comment");
}

{unary_operator}   {return inc;}
"sop"	 { return LB; }
"scp"	  { return RB; }
"brk"    {   return BREAK;     }
"check"      { return CASE;      }
"incident"      { return SWITCH;	}
"nop"     {  return DEFAULT; 	}
"wlp" { return WHILE;}
"in"	{ return INT; }
"flt"	{ return FLOAT; }
"ch"	{ return CHAR; }
[:]     { return COL;}
[0-9]+	{ 
		yylval.number = atoi(yytext);
		return NUM;
	}
"flp"   { return FOR;}	
"fop"	{ return LP; }
"fcp"	{ return RP; }
"$"	{ return CM; }
"#"	{ return SM; }
"addition"	{ return PLUS;}
"subtraction"	{ return MINUS; }
"multiplication"	{ return MULT; }
"division"	{ return DIV; }
"exponential"	{ return POW; }
[@]		{ return ASSIGN;  }
"grt"	{ return GT; }
"lrt"	{ return LT; }

{identifiers} {
	 yylval.string=strdup(yytext);
	 return VAR;
	}

"iff"		{ return IF;}
"oriff"	{ return ELIF; }
"or"		{ return ELSE;}

"mfun "[A-Za-z]+	{ return MAIN; }

[ \t\n]*	

.	{
		yyerror("Unknown Character.\n");
	}
%%

/* user subroutines */

int main()
{
	yyin = freopen("in.txt","r",stdin);
	yyout = freopen("out.txt","w",stdout);
	yyparse();
	
}