#include "runtime.h"

#include <stdio.h>
#include <stdlib.h>

int rt_readln_int(void) {
    int value = 0;
    if (scanf("%d", &value) != 1) {
        fprintf(stderr, "runtime error: expected integer input\n");
        exit(1);
    }
    return value;
}

void rt_writeln_int(int value) {
    printf("%d\n", value);
}

void rt_writeln_str(const char *value) {
    printf("%s\n", value);
}
