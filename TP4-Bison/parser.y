%code top{
#include <stdio.h>
#include <math.h>
#include "archivo.h"
}

%code provides{
void yyerror(const char *);
extern int yylexerrs;
}

%defines "parser.h"
%output "parser.c"
%define api.value.type {char *}
%define parse.error verbose
%start programa

%token NUMERO IDENTIFICADOR FUNCION

%token VAR CONSTANTE SALIR

%token ASIGMAS "+="
%token ASIGMENOS "-="
%token ASIGPOR "*="
%token ASIGDIV "/="

%right '=' "+=" "-=" "*=" "/="
%left '+' '-'
%left '*' '/'
%right '^'
%precedence NEG


%%

programa		: lista-de-sentencias { if (yynerrs || yylexerrs) YYABORT; else YYACCEPT; }
			;
lista-de-sentencias	: lista-de-sentencias sentencia
			| %empty
			;
sentencia 		: declaracion
			| definicion 
			| expresion {printf("Expresion EXPRESION\n");}
			| SALIR
			| error
			;
declaracion		: CONSTANTE IDENTIFICADOR inicializacion {printf("Define ID como Constante\n");}
			| VAR IDENTIFICADOR 		   {printf("Define ID como Variable\n");}
			| VAR IDENTIFICADOR inicializacion {printf("Define ID como Variable con valor inicial\n");}
			;
inicializacion		: '=' expresion 
			;

			// Gramatica Achatada //
expresion		: expresion '+' expresion 		{printf("Suma\n");}
			| expresion '-' expresion 		{printf("Resta\n");}
			| expresion '*' expresion 		{printf("Multiplicacion\n");}
			| expresion '/' expresion 		{printf("Division\n");}
			| expresion '^' expresion 		{printf("Potenciacion\n");}
			| '-' expresion %prec NEG 		{printf("Cambio Signo\n");}
			| '(' expresion ')' 	  		{printf("Cierra Parentesis\n");}
			| FUNCION '(' expresion ')'		{printf("Funcion\n");}
			| IDENTIFICADOR 	  		{printf("ID\n");}
			| NUMERO 		  		{printf("Numero\n");}
			;
			
definicion		: IDENTIFICADOR '=' definicion  	{printf("Asignacion\n");}
			| IDENTIFICADOR ASIGMAS definicion	{printf("Asignacion con Suma\n");}
			| IDENTIFICADOR ASIGMENOS definicion	{printf("Asignacion con Resta\n");}
			| IDENTIFICADOR ASIGPOR definicion	{printf("Asignacion con Mult\n");}
			| IDENTIFICADOR ASIGDIV definicion	{printf("Asignacion con Div\n");}
			| expresion  				{printf("Expresion DEFINICION\n");}
			;

%%
/* Informar ocurrencia de un error */
void yyerror(const char *s){ // si no hubiese estado definido, directamente el yyerror imprimiría: "syntax error" solamente
    printf("Línea #%d: %s\n", yylineno, s);
    return;
}