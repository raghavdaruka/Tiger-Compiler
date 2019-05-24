%{
#include <stdio.h>
#include <stdlib.h>
#include "tig.tab.h"
int row=0,col=0;
int comment_depth=0;
void adjust(char *) ;	
%}
digit [0-9]
letter [a-zA-Z]
all [0-9a-zA-Z_]
ws [ \t\n]
asc_range ([01][0-9]{2}|2[0-4][0-9]|25[0-5])

%x STRING_S STRING_ML COMMENT
%%

<INITIAL>"\""   {; BEGIN(STRING_S);}

<INITIAL>"/*"   {; BEGIN(COMMENT);comment_depth++;}

<INITIAL>[ \t]  {; continue;}
<INITIAL>"\n"   {; row=0;col++; continue;}

<INITIAL>"("    {adjust("LPAREN"); return LPAREN;}
<INITIAL>")"    {adjust("RPAREN"); return RPAREN;}
<INITIAL>"["    {adjust("LBRACK"); return LBRACK;}
<INITIAL>"]"    {adjust("RBRACK"); return RBRACK;}
<INITIAL>"{"    {adjust("LBRACE"); return LBRACE;}
<INITIAL>"}"    {adjust("RBRACE"); return RBRACE;}
<INITIAL>":"    {adjust("COLON"); return COLON;}
<INITIAL>"."    {adjust("DOT"); return DOT;}
<INITIAL>","    {adjust("COMMA"); return COMMA;}
<INITIAL>";"    {adjust("SEMICOLON"); return SEMICOLON;}
<INITIAL>"*"    {; return INFIXOP;}
<INITIAL>"/"    {; return INFIXOP;}
<INITIAL>"+"    {; return INFIXOP;}
<INITIAL>"-"    {; return INFIXOP;}
<INITIAL>"="    {adjust("EQ"); return EQ;}
<INITIAL>"<>"   {; return INFIXOP;}
<INITIAL>">"    {; return INFIXOP;}
<INITIAL>"<"    {; return INFIXOP;}
<INITIAL>">="   {; return INFIXOP;}
<INITIAL>"<="   {; return INFIXOP;}
<INITIAL>"&"    {; return AND;}
<INITIAL>"|"    {; return OR;}
<INITIAL>"->"   {; return FUNC_RETURN;}

<INITIAL>"array"    {adjust("KEYWORD"); return ARRAY;}
<INITIAL>"break"	{adjust("KEYWORD"); return BREAK;}
<INITIAL>"do"		{adjust("KEYWORD"); return DO;}
<INITIAL>"else"     {adjust("KEYWORD"); return ELSE;}
<INITIAL>"end"      {adjust("KEYWORD"); return END;}
<INITIAL>"function" {adjust("KEYWORD"); return FUNCTION;}
<INITIAL>"for"		{adjust("KEYWORD"); return FOR;}
<INITIAL>"while"	{adjust("KEYWORD"); return WHILE;}
<INITIAL>"to"		{adjust("KEYWORD"); return TO;}
<INITIAL>"if"       {adjust("KEYWORD"); return IF;}
<INITIAL>"in"       {adjust("KEYWORD"); return IN;}
<INITIAL>"let"      {adjust("KEYWORD"); return LET;}
<INITIAL>"nil"      {adjust("KEYWORD"); return NIL;}
<INITIAL>"of"       {adjust("KEYWORD"); return OF;}
<INITIAL>"then"     {adjust("KEYWORD"); return THEN;}
<INITIAL>"type"     {adjust("KEYWORD"); return TYPE;;}
<INITIAL>"var"      {adjust("KEYWORD"); return VAR;}

<INITIAL>{letter}{all}* {adjust("ID"); return ID;}

<INITIAL>{digit}+ {adjust("LITERAL"); return INTLIT;}

<INITIAL>.                          {;}

<STRING_ML>[ \t]  { continue;}
<STRING_ML>"\n"   {; continue;}
<STRING_ML>\\     {;  BEGIN(STRING_S);}
<STRING_ML>.      {;  }

<STRING_S>"\""          {;  BEGIN(INITIAL); return STRINGLIT;}
<STRING_S>"\n"          {adjust("STRING"); BEGIN(INITIAL);  }
<STRING_S>"\\n"         {;   continue;}
<STRING_S>"\\t"         {;   continue;}
<STRING_S>"\\\\"        {;   continue;}
<STRING_S>"\\\""        {;   continue;}
<STRING_S>\\{asc_range} {;   continue;}
<STRING_S>\\[ \t]+      {;  BEGIN(STRING_ML);}
<STRING_S>\\\n          {;  BEGIN(STRING_ML);}
<STRING_S>\\.           {;  }
<STRING_S>.             {;   continue;}


<COMMENT>.      {;}
<COMMENT>"\n"   {col++;}
<COMMENT>"/*"   {;  comment_depth++;}
<COMMENT>"*/"   {;  if (--comment_depth == 0) {BEGIN(INITIAL);}}

%%

int yywrap(void) {
  //charPos=1;
  return 1;
}

void adjust(char * arr)
{
  //EM_tokPos=charPos;
  printf("<%s, %d, %d, %s>\n",yytext,row,col,arr);
  row+=yyleng;
}