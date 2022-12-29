%code top{
#include <stdio.h>
#include <math.h>
#include "archivo.h"
#include "calc.h"
}

%code provides{
void yyerror(const char *);
extern int yylexerrs;

symrec *aux;

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

%precedence '=' 
%right "+=" "-=" "*=" "/="
%left '+' '-'
%left '*' '/'
%precedence NEG
%right '^'



%%

programa		: lista-de-sentencias { if (yynerrs || yylexerrs) YYABORT; else YYACCEPT; }
			;
lista-de-sentencias	: lista-de-sentencias sentencia
			| %empty
			;
sentencia 		: declaracion 
			| definicion 
			| expresion 
			| SALIR 
			| error 
			;
declaracion		: CONSTANTE IDENTIFICADOR '=' expresion  { aux=getsym($2); if (aux) { printf("Es una constante, no se puede redeclarar") ;} else { printf("Se declara una nueva variable con nombre %s y se inicializa en %f \n",$2,$4); aux=putsym(strdup($2),TYP_CTE); $$=(aux->valor.nro)=$4 ;} }
			| VAR IDENTIFICADOR 		   	 { aux=getsym($2); if (aux) { printf("Se esta redeclarando la variable") ;} else { printf("La variable %s no esta declarada, se considera que posee valor cero \n",$2); $$=0; } }
			| VAR IDENTIFICADOR '=' expresion 	 { aux=getsym($2); if (aux) { printf("Se esta redeclarando la variable") ;} else { printf("Se declara una nueva variable con nombre %s y se inicializa en %f \n",$2,$4); aux=putsym(strdup($2),TYP_VAR); $$=(aux->valor.nro)=$4 ;} }
			;


			// Gramatica Achatada //
expresion		: expresion '+' expresion 		{ $$ = $1 + $3;                    }
			| expresion '-' expresion 		{ $$ = $1 - $3;                    }
			| expresion '*' expresion 		{ $$ = $1 * $3;                    }
			| expresion '/' expresion 		{ $$ = $1 / $3;                    }
			| expresion '^' expresion 		{ $$ = pow ($1, $3);               }
			| '-' expresion %prec NEG 		{ $$ = -$2;                        }
			| '(' expresion ')' 	  		{ $$ = $2;                         }
			| FUNCION '(' expresion ')'		{ $$ = $1->valor.func($3);         }
			| IDENTIFICADOR 	  		{ aux=getsym($1); if (aux) { $$ = (aux->nro)    ;} else {printf("error no esta declarado\n> "); yyerror;}}
			| NUMERO 		  		{ $$ = $1; }
			;
			
definicion		: IDENTIFICADOR {if ($1->tipo != VAR) {printf("error\n> "); YYERROR;}} '=' definicion  	
								{$1->valor.nro = $4; $$ = $1->valor.nro;}
			| IDENTIFICADOR {if ($1->tipo != VAR) {printf("error\n> "); YYERROR;}} ASIGMAS definicion	
								{$1->valor.nro += $4; $$ = $1->valor.nro;}
			| IDENTIFICADOR {if ($1->tipo != VAR) {printf("error\n> "); YYERROR;}} ASIGMENOS definicion	
								{$1->valor.nro -= $4; $$ = $1->valor.nro;}
			| IDENTIFICADOR {if ($1->tipo != VAR) {printf("error\n> "); YYERROR;}} ASIGPOR definicion	
								{$1->valor.nro *= $4; $$ = $1->valor.nro;}
			| IDENTIFICADOR {if ($1->tipo != VAR) {printf("error\n> "); YYERROR;}} ASIGDIV definicion	
								{$1->valor.nro /= $4; $$ = $1->valor.nro;}
			| expresion  				
			;

%%
