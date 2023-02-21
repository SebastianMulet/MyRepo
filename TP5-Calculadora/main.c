#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "parser.h"
#include "calc.h"



extern symrec *sym_table;

struct init
{
  char const *nombre;
  double (*func) (double);
};


struct init const arith_fncts[] =
{
  { "atan", atan },
  { "acos", acos },
  { "asin", asin },
  { "cos",  cos  },
  { "tan",  tan  },
  { "ln",   log  },
  { "sin",  sin  },
  { "sqrt", sqrt },
  { 0, 0 },
};


static void init_table(){
  int i;
  for (i = 0; arith_fncts[i].nombre != 0; i++)
    {
      symrec *ptr = putsym (arith_fncts[i].nombre, TYP_FNCT, 0);
      ptr->valor.func = arith_fncts[i].func;
    }
	putsym("pi", 2, M_PI);
	putsym("e", 2, M_E);
}


int main (int argc, char const* argv[])
{
    init_table ();
    return yyparse ();
}