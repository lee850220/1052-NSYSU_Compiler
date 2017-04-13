#include "hash.h"

Hash *table;
int Top = 0, Tail = 0;

void create() {
//create symbol table
    Top = 0;
    Tail = 0;
    table = (Hash*)malloc(sizeof(Hash)*TABLE_SIZE);
}

int lookup(char* s) {
//return the index of string s
    int cur = hashcode(s), found = 0;
    while (strcmp(table[cur].key, "")) {
        if (!strcmp(table[cur].key, s)) {
            found = 1;
            break;
        }
        cur++;
        cur %= 65536;
    }

    if (found) return cur;
    else return -1;
}

int insert(char* s) {
//add string s into table and return the index
    int hc = hashcode(s);

    while(strcmp(table[hc].key, "")) {
        if (!strcmp(table[hc].key, s)) {
            return hc;
        }
        hc++;
        hc %= 65536;
    }

    strcpy(table[hc].key, s);
    if (Top == Tail && Tail == 0) {
        Top = Tail = hc;
    } else {
        table[Tail].next = table + hc;
        Tail = hc;
    }

    return hc;
}

void dump() {
//print out the symbol table
    Hash *cur = table + Top;
    printf("The symbol table contains:\n");
    while (1) {
        printf("%s\n", cur -> key);
        if (cur == table + Tail) break;
        cur = cur -> next;
    }
}

int hashcode(char *s) {
    int res = 0, i = 0;
    for (i; i < strlen(s); i++) {
        res += (int)s[i];
        res %= 65536;
    }
    return res;
}