SHELL := /bin/bash
#/************ Argument ***************
CC= gcc
LEX= flex
OPTION= -lfl
ARG=

SOC= lex.yy.c hash.c
PRJ= B035020026.l
#************ Argument ***************/

all: clean lex scanner

test:
	@clear
	@./scanner.out < Test.java > result
	@cat result | less -d
	
lex: ${PRJ}
	${LEX} ${PRJ}

scanner: ${SOC}
	${CC} ${SOC} ${OPTION} -o $@.out

debug: clean lex ${SOC}
	${CC} -g ${SOC} ${OPTION}
	gdb -q a.out

*.o: *.c
	${CC} $^ ${OPTION} -o $@

clean:
	@rm -rf lex.yy.c *.o *.out result

help:
	clear
	@cat help.txt
