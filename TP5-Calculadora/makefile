test : scanner.o parser.o calc.o
	gcc scanner.o parser.o calc.o -o compilador -lfl -lm

parser.o : parser.c parser.h calc.h scanner.h
	gcc -c parser.c

scanner.o : scanner.c scanner.h calc.h parser.h
	gcc -c scanner.c

scanner.c scanner.h : scanner.l 
	flex scanner.l

parser.c parser.h : parser.y
	bison parser.y

clean : 
	rm parser.c parser.h parser.o scanner.c scanner.h scanner.o compilador