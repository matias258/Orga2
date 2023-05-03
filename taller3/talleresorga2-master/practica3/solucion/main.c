#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "checkpoints.h"

int main (void) {
    char* a = "testeo esto";
    char* ans = strClone(a);
    printf("ANS: %s\n", ans);
	return 0;
}
