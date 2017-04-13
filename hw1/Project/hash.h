#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#define TABLE_SIZE 65536

typedef struct Hash {
    char key[256];
    char *value;
    struct Hash *next;
}Hash;

void create();
int lookup(char*);
int Insert(char*);
void dump();
int hashcode(char*);