#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "checkpoints.h"

extern uint8_t checksum_asm(void* array, uint32_t n);

int main (void) {
    data_t* test_data = (data_t*) malloc(sizeof(data_t)*1);
    for (int k = 0; k < 8; k++){
        test_data[0].a[k] = k+1;
        test_data[0].b[k] = k+1+8;
        test_data[0].c[k] = (k+1+k+1+8)*8;
    }

    //test_data[0].c[2] = 5;

    uint8_t ans = checksum_asm(test_data, 1);
    printf("ANS = %d\n", ans);
	return 0;
}
