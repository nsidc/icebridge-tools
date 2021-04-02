# Makefile for testing only
CC=gcc

test: qi2txt.o
	$(CC) qi2txt.o -lm -o qi2txt
testo: qi2txt.c
	$(CC) -O -c qi2txt.c

clean:
	rm qi2txt
	rm qi2txt.o
