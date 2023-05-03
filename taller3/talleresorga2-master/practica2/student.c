#include "student.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>


void printStudent(student_t *stud)
{
    /* Imprime por consola una estructura de tipo student_t
    */
    printf("Nombre: ");
    for(int i=0;i<sizeof(stud->name);i++) {
        printf("%c",stud->name[i]);
    }
    printf("\ndni: %d\n", stud->dni);
    printf("Calificaciones: ");
    for(int i=0;i<sizeof(stud->califications);i++) {
        printf("%d", stud->califications[i]);
        if(i<sizeof(stud->califications)-1)
            printf(", ");
    }
    printf("\nConcepto: %d\n", stud->concept);
    printf("---------\n");
}

void printStudentp(studentp_t *stud)
{
    /* Imprime por consola una estructura de tipo studentp_t
    */
    printf("Nombre: ");
    for(int i=0;i<sizeof(stud->name);i++) {
        printf("%c",stud->name[i]);
    }
    printf("\ndni: %d\n", stud->dni);
    printf("Calificaciones: ");
    for(int i=0;i<sizeof(stud->califications);i++) {
        printf("%d", stud->califications[i]);
        if(i<sizeof(stud->califications)-1)
            printf(", ");
    }
    printf("\nConcepto: %d\n", stud->concept);
    printf("---------\n");
}
