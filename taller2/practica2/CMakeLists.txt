cmake_minimum_required(VERSION 3.25)
project(practica2 C)

set(CMAKE_C_STANDARD 11)

include_directories(.)

add_executable(practica2
        main.c
        stack.c
        stack.h
        student.c
        student.h
        teacher.h)
