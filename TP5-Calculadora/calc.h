#include <stdbool.h>

#ifndef CALC_H
#define CALC_H

#define TYP_VAR 0
#define TYP_FNCT 1
#define TYP_CTE 2

typedef double (*func) (double);

typedef struct symrec
{
  char *nombre;
  int tipo; 
  bool existe;
  union
  {
    double nro;  
    double (*func) (double); 
  } valor;
  struct symrec *next; 
} symrec;

symrec *putsym (char const *, int, double);

symrec *getsym (char const *);

#endif