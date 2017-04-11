SHELL := /bin/bash
#/************ Argument ***************
CC= gcc
LEX= flex
OPTION= -lfl
ARG=

SOC= lex.yy.c
PRJ= B035020026.l
TEST_PATH= TestFile_Lab1_2017/
#************ Argument ***************/

all: clean lex scanner

test:
	./scanner.out < ${TEST_PATH}Test1.java | more -d
	@echo Press "ENTER" to continue.
	@read
	./scanner.out < ${TEST_ PATH}Test2.java | more -d
	@echo Press "ENTER" to continue.
	@read
	./scanner.out < ${TEST_PATH}Test3.java | more -d
	

lex: ${PRJ}
	${LEX} ${PRJ}

scanner: ${SOC}
	${CC} ${SOC} ${OPTION} -o $@.out

*.o: *.c
	${CC} $^ ${OPTION} -o $@

clean:
	@rm -rf lex.yy.c *.o *.out