.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    addi sp sp -16
    sw ra 0(sp)
    sw a0 4(sp)
    sw a1 8(sp)
    sw a2 12(sp)

    mv a1 a0
    mv a2 x0
    jal fopen 

    mv a1 a0
    addi a3 x0 4
    lw a2 8(sp)
    jal fread # reading first 4 bytes to get row #

    lw t0 0(a2) # total # rows


    blt a3 a0 eof_or_error

    lw a2 12(sp)
    jal fread # reading second 4 bytes to get column #

    lw t1 0(a2) # total num columns
    blt a3 a0 eof_or_error
    mul t2 t1 t0 # calculating total # memory
    slli t2 t2 2 
    mv a0 t2
    mv t5 a1
    jal malloc
    mv a1 t5
    mv t3 a0 # storing address into t3
    mv t6 a0
    mv t4 x0 # index
    mul t2 t1 t0 

loop_beginning:

    bge t4 t2 loop_ending
    mv a2 t3
    jal fread
    blt a3 a0 eof_or_error
    addi t3 t3 4
    addi t4 t4 1
    jal loop_beginning

loop_ending:
 
    lw ra 0(sp)
    lw a0 4(sp)
    lw a1 8(sp)
    lw a2 12(sp)
    addi sp sp 16
    mv a0 t6

    ret

eof_or_error:
    li a1 1
    jal exit2