%{
#include <stdio.h>
#include "tokens.h"
%}

%option yylineno
%option noinput
%option nounput
%option header-file="archivo.h"
%option outfile="flex.c"

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

%%

var return VAR;
cte return CONSTANTE;
salir return SALIR;
{constante} return NUMERO;
{funcion} return FUNCION;
{identificador} return IDENTIFICADOR;
({digitoNoCero}({digito}|{identificador_noDigito})*)|({constante_fraccionaria}{inval}+({constante_fraccionaria}|{identificador_noDigito})*) printf("Error léxico NUMERO INVALIDO inválido: %s\n", yytext);
{identificador_noDigito}({identificador_noDigito}|{caracter_invalido})+ printf("Error léxico IDENTIFICADOR INVALIDO inválido: %s\n", yytext);
({identificador_noDigito}|{caracter_invalido})({identificador_noDigito}|{caracter_invalido}|{constante})* printf("Error léxico CADENA DESCONOCIDA inválido: %s\n", yytext);
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
"\n" {printf("Token: 'NL'\n");}
. ; 

%%