%code top{
#include <stdio.h>
#include <math.h>
#include "scanner.h"
#include "calc.h"

symrec *aux;

}

%code provides{
void yyerror(const char *);
//extern int yylexerrs;

struct YYSTYPE{
	double dval;
	struct symrec *idval;
};

}

%defines "parser.h"
%output "parser.c"
%define api.value.type {struct YYSTYPE}
%define parse.error verbose
%start programa

%token NL
%token <dval> NUMERO 
%token <idval> IDENTIFICADOR 
%token <idval> FUNCION
%nterm <dval> expresion
%nterm <dval> declaracion

%token VAR CONSTANTE SALIR

%token ASIGMAS "+="
%token ASIGMENOS "-="
%token ASIGPOR "*="
%token ASIGDIV "/="


%right '=' "+=" "-=" "*=" "/="
%left '+' '-'
%left '*' '/'
%precedence NEG
%right '^'



%%

programa		: lista-de-sentencias //{ if (yynerrs || yylexerrs) YYABORT; else YYACCEPT; }
			;
lista-de-sentencias	: lista-de-sentencias sentencia
			| %empty
			;
sentencia 		: NL
			| declaracion NL 
			| expresion NL { printf("\t%g\n", $1) ;}
			| error NL
			| SALIR NL { return 0; }
			;
declaracion		: CONSTANTE IDENTIFICADOR '=' expresion  {if ($2->existe) { printf("Se esta redeclarando la constante\n"); YYERROR;} else { printf("%s: %f\n", $2->nombre, $4); putsym($2->nombre, 2, $4) ; $$=$2->valor.nro = $4; } }
			| VAR IDENTIFICADOR 		   	 {if ($2->existe) { printf("Se esta redeclarando la variable\n"); YYERROR;} else { printf("%s: 0\n", $2->nombre); putsym($2->nombre, 0, 0) ; $$=0; } }
			| VAR IDENTIFICADOR '=' expresion 	 {if ($2->existe) { printf("Se esta redeclarando la variable\n"); YYERROR;} else { printf("%s: %f\n", $2->nombre, $4); putsym($2->nombre, 0, $4); $$=$4; } }
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
			| IDENTIFICADOR 	  		{ if ($1->existe) { $$ = $1->valor.nro ;} else {printf("Error %s no esta declarado\n", $1->nombre); YYERROR;}}
			| NUMERO 		  		{ $$ = $1; }
			| IDENTIFICADOR '=' expresion  		{if (! $1->existe) {printf("El identificador no esta declarado\n> "); YYERROR;} if (! $1->tipo) $$ = $1->valor.nro = $3; else { printf("Es una constante, no se puede asignar el valor\n"); YYERROR;} }
			| IDENTIFICADOR ASIGMAS expresion	{if (! $1->existe) {printf("El identificador no esta declarado\n> "); YYERROR;} if (! $1->tipo) $$ = $1->valor.nro = $1->valor.nro + $3; else { printf("Es una constante, no se puede asignar el valor\n"); YYERROR;} }
			| IDENTIFICADOR ASIGMENOS expresion	{if (! $1->existe) {printf("El identificador no esta declarado\n> "); YYERROR;} if (! $1->tipo) $$ = $1->valor.nro = $1->valor.nro - $3; else { printf("Es una constante, no se puede asignar el valor\n"); YYERROR;} }
			| IDENTIFICADOR ASIGPOR expresion	{if (! $1->existe) {printf("El identificador no esta declarado\n> "); YYERROR;} if (! $1->tipo) $$ = $1->valor.nro = $1->valor.nro * $3; else { printf("Es una constante, no se puede asignar el valor\n"); YYERROR;} }
			| IDENTIFICADOR ASIGDIV expresion	{if (! $1->existe) {printf("El identificador no esta declarado\n> "); YYERROR;} if (! $1->tipo) $$ = $1->valor.nro = $1->valor.nro / $3; else { printf("Es una constante, no se puede asignar el valor\n"); YYERROR;} }
			;

%%