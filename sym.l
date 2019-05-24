%{
#include <stdio.h>
#include <stdlib.h>
#include "sym_table.h"
int row=0,col=0;
int args=0;
int lb=0,rb=0,lc=0,rc=0;
char curfunc[10],type[10],curVariable[10],argslist[10];
int comment_depth=0,counttype=0;
void adjust();	
Node *n;
FILE* yyin;
%}
digit [0-9]
letter [a-zA-Z]
all [0-9a-zA-Z_]
ws [ \t\n]
asc_range ([01][0-9]{2}|2[0-4][0-9]|25[0-5])

%x STRING_S STRING_ML COMMENT
%%

<INITIAL>"\""   {adjust(); BEGIN(STRING_S);}

<INITIAL>"/*"   {adjust(); BEGIN(COMMENT);comment_depth++;}

<INITIAL>[ \t]  {adjust(); continue;}
<INITIAL>"\n"   {adjust(); col++; continue;}

<INITIAL>"("    {adjust();args=0;lb++; strcpy(argslist,"");}
<INITIAL>")"    {adjust();rb++; n=search(curfunc);if(args!=0) {args++,strcpy(n->alist,argslist);}n->num=args; }
<INITIAL>"["    {adjust(); }
<INITIAL>"]"    {adjust(); }
<INITIAL>"{"    {adjust(); lc++;}
<INITIAL>"}"    {adjust(); rc++;}
<INITIAL>":"    {adjust(); }
<INITIAL>"."    {adjust(); }
<INITIAL>","    {adjust();args++; strcat(argslist,",");}
<INITIAL>";"    {adjust(); }
<INITIAL>"*"    {adjust(); }
<INITIAL>"/"    {adjust(); }
<INITIAL>"+"    {adjust(); }
<INITIAL>"-"    {adjust(); }
<INITIAL>"="    {adjust(); }
<INITIAL>"<>"   {adjust(); }
<INITIAL>">"    {adjust(); }
<INITIAL>"<"    {adjust(); }
<INITIAL>">="   {adjust(); }
<INITIAL>"<="   {adjust(); }
<INITIAL>"&"    {adjust(); }
<INITIAL>"|"    {adjust(); }
<INITIAL>"->"   {adjust(); }

<INITIAL>"array"    {adjust(); }
<INITIAL>"break"	{adjust(); }
<INITIAL>"do"		{adjust(); }
<INITIAL>"else"     {adjust(); }
<INITIAL>"end"      {adjust(); }
<INITIAL>"function" {adjust(); }
<INITIAL>"for"		{adjust(); }
<INITIAL>"while"	{adjust(); }
<INITIAL>"to"		{adjust(); }
<INITIAL>"if"       {adjust(); }
<INITIAL>"in"       {adjust(); }
<INITIAL>"let"      {adjust(); }
<INITIAL>"nil"      {adjust(); }
<INITIAL>"of"       {adjust(); }
<INITIAL>"then"     {adjust(); }
<INITIAL>"type"     {adjust(); }
<INITIAL>"var"      {adjust(); }
<INITIAL>"int"		{adjust();counttype++;strcpy(type,"int");if((lb>rb)||lc>rc){n=search(curVariable);strcpy(n->dtype,"int");}else{n=search(curfunc);strcpy(n->rtype,"int");} }
<INITIAL>"string"	{adjust();counttype++;strcpy(type,"string");if((lb>rb)||lc>rc){n=search(curVariable);strcpy(n->dtype,"string");}else{n=search(curfunc);strcpy(n->rtype,"string");}  }

<INITIAL>{letter}{all}*/"(" {adjust(); strcpy(curfunc,yytext);printf("Hello"); n = (Node*) malloc(sizeof(Node));   n->type = 1;strcpy(n->name,yytext);strcpy(n->rtype,"void"); insert(n);}
<INITIAL>{letter}{all}* {adjust();strcpy(curVariable,yytext);printf("Hello"); n = (Node*) malloc(sizeof(Node)); strcpy(n->scope,"L");strcpy(n->dtype,"type");  n->type = 0;strcpy(n->name,yytext); insert(n);strcat(argslist,yytext);}
<INITIAL>{digit}+ {adjust(); }

<INITIAL>.                          {adjust();}

<STRING_ML>[ \t]  {adjust(); continue;}
<STRING_ML>"\n"   {adjust(); continue;}
<STRING_ML>\\     {adjust();  BEGIN(STRING_S);}
<STRING_ML>.      {adjust();  }

<STRING_S>"\""          {adjust();  BEGIN(INITIAL); }
<STRING_S>"\n"          {adjust(); BEGIN(INITIAL);  }
<STRING_S>"\\n"         {adjust();   continue;}
<STRING_S>"\\t"         {adjust();   continue;}
<STRING_S>"\\\\"        {adjust();   continue;}
<STRING_S>"\\\""        {adjust();   continue;}
<STRING_S>\\{asc_range} {adjust();   continue;}
<STRING_S>\\[ \t]+      {adjust();  BEGIN(STRING_ML);}
<STRING_S>\\\n          {adjust();  BEGIN(STRING_ML);}
<STRING_S>\\.           {adjust();  }
<STRING_S>.             {adjust();   continue;}


<COMMENT>.      {adjust();}
<COMMENT>"\n"   {adjust();}
<COMMENT>"/*"   {adjust();  comment_depth++;}
<COMMENT>"*/"   {adjust();  if (--comment_depth == 0) {BEGIN(INITIAL);}}

%%

int yywrap(void) {

  return 1;
}

void adjust(void)
{
  
  printf("%s\n",yytext);
  row+=yyleng;
}

int main(){
	yyin = fopen("input.c","r");
	yylex();
	display();
}