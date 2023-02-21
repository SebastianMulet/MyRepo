#include "calc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

symrec *sym_table = NULL;

symrec *putsym (char const *sym_name, int sym_type, double numero)
{
  symrec *ptr = (symrec *) malloc (sizeof (symrec));
  ptr->nombre = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->nombre,sym_name);
  ptr->tipo = sym_type;
  ptr->valor.nro = numero;
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}


symrec *getsym (char const *sym_name)
{
  symrec *ptr;
  symrec *aux = (symrec *) malloc (sizeof (symrec));
  aux->existe = false;
  aux->nombre = (char *) malloc (strlen (sym_name) + 1);
  strcpy (aux->nombre,sym_name);
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->nombre, sym_name) == 0) 
    	{  ptr->existe = true;
      	return ptr;
      }
  return aux;
}


symrec *findsym (char const *sym_name, symrec *sym_table) {
	symrec *aux = sym_table; 
	while (aux && strcmp(aux->nombre, sym_name)){
		aux = aux->next;
	}
	if(aux){
		return aux;
	}
	else
		return 0;
}