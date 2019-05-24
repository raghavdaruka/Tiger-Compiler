%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
extern int col;

%}
/*%union{
struct ast *a;
double d;
}
*/
/*declaring tokens*/

%token TYID ID INTLIT STRINGLIT INFIXOP 

%token 
  COMMA COLON SEMICOLON LPAREN RPAREN LBRACK RBRACK 
  LBRACE RBRACE DOT EQ
  PLUS MINUS TIMES DIVIDE NEQ LT LE GT GE
  AND OR ASSIGN
  ARRAY BREAK DO FOR TO WHILE IF THEN ELSE LET IN END OF 
  NIL
  FUNCTION VAR TYPE FUNC_RETURN 

%start program


%%

program: exp {printf("Parsing sucessful"); exit(0);};


dec: tyDec                      
    |   varDec                      
    |   funDec

tyDec: TYPE ID EQ ty

ty: ID
	| arrTy
	| recTy
arrTy: ARRAY OF ID

recTy: LBRACE fieldDecs RBRACE

fieldDecs: fieldDec
	| epsa 
	| fieldDec COMMA fieldDecs

epsa: /*empty*/;	

fieldDec: ID COLON ID

funDec:   FUNCTION ID LPAREN fieldDecs RPAREN EQ exp             
	| FUNCTION ID LPAREN fieldDecs RPAREN COLON ID EQ exp

varDec: VAR ID COLON EQ exp
	| VAR ID COLON ID COLON EQ exp

lValue: ID 
	| subscript 
	| fieldExp

subscript: lValue LBRACK exp RBRACK   

fieldExp: lValue DOT ID

exp: lValue
	|NIL
	|INTLIT
	|STRINGLIT
	|seqExp
	|negation
	|callExp
	|infixExp
	|arrCreate
	|recCreate
	|assignment
	|ifThenElse
	|ifThen
	|whileExp
	|forExp
	|BREAK
	|letExp



seqExp: LPAREN expd RPAREN

expd: exp
	|epsa
	|exp SEMICOLON expd

negation: MINUS exp

callExp: ID LPAREN exps RPAREN

exps: exp
	|epsa
	|exp COMMA exps

infixExp: exp INFIXOP exp 

arrCreate: ID LBRACK exp RBRACK OF exp

recCreate: ID LBRACE fieldCreates RBRACE

fieldCreates: fieldCreate
	|epsa
	| fieldCreate COMMA fieldCreates

fieldCreate: ID EQ exp

assignment: lValue COLON EQ exp

ifThenElse: IF exp THEN exp ELSE exp

ifThen: IF exp THEN exp

whileExp: WHILE exp DO exp

forExp: FOR ID COLON EQ exp TO exp DO exp

letExp: LET decs IN expd END

decs: dec
	|dec decs
	;
%%


int yyerror(char *msg)
{
printf("Invalid Expression.Error in row:%d",col);
exit(0);
}


void main ()
{
	yyin = fopen("input.c", "r");
	yyparse();
}
