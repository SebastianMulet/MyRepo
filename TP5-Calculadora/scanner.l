%{
#include <stdio.h>
#include <strings.h>
#include "calc.h"
#include "parser.h"
char msg[120];
%}

%option yylineno
%option noinput
%option nounput
%option header-file="scanner.h"
%option outfile="scanner.c"

identificador {identificador_noDigito}({digito}|{identificador_noDigito})*
digito [0-9]
identificador_noDigito [a-zA-Z]
digitoNoCero [1-9]
funcion sin|cos|tan|asin|acos|atan|sqrt|log
constante {constante_decimal}|{constante_real}
constante_decimal {digitoNoCero}({digito})*
constante_real {constante_fraccionaria}{parte_exponencial}?|{constante_entera}{parte_exponencial}
constante_fraccionaria {constante_entera}?\.{constante_entera}|{constante_entera}\.
parte_exponencial e[+-]?{constante_entera}|E[+-]?{constante_entera}
constante_entera {digito}+
operador_asignacion ({operador_aditivo}|{operador_multiplicativo})?=
operador_aditivo [+-]
operador_multiplicativo [*/]
caracter_invalido [@#$%;]
inval   [0-9.]
espacio [[:space:]]

%%

var return VAR;
cte return CONSTANTE;
salir return SALIR;
{constante} {yylval.dval = atof(yytext); return NUMERO;}
{funcion} {yylval.idval = getsym(yytext); return FUNCION;}
{identificador} {yylval.idval = getsym(yytext); return IDENTIFICADOR;}
({digitoNoCero}({digito}|{identificador_noDigito})*)|({constante_fraccionaria}{inval}+({constante_fraccionaria}|{identificador_noDigito})*) { sprintf(msg, "Error léxico: constante inválida: %s", yytext); yyerror(msg);}
{identificador_noDigito}({identificador_noDigito}|{caracter_invalido})+ { sprintf(msg, "Error léxico: identificador inválido: %s", yytext); yyerror(msg);}
({identificador_noDigito}|{caracter_invalido})({identificador_noDigito}|{caracter_invalido}|{constante})* { sprintf(msg, "Error léxico: cadena desconocida: %s", yytext); yyerror(msg);}
"("															return '(';
")"															return ')';
"+"															return '+';
"-"															return '-';
"*"															return '*';
"/"															return '/';
"^"															return '^';
"="	return '=';
"+="	return ASIGMAS;
"-="	return ASIGMENOS;
"*="	return ASIGPOR;
"/="	return ASIGDIV;
\n      {printf("\n"); return NL;}
. ; 

%%

void yyerror (char const *s)
{
    fprintf (stderr, "%s\n", s);
}