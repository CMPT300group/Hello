.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:
    addi sp sp -4
    sw ra 0(sp)

loop_start:
    mv t1 x0
    mv t3 x0
    mv t5 x0
    
loop_continue:
    bge t1 a1 loop_end
    mv t2 t1
    slli t2 t2 2
    add t2 t2 a0
    lw t0 0(t2)
    mv t4 t1
    addi t1 t1 1
    bge t5 t0 loop_continue
    mv t3 t4
    mv t5 t0
    j loop_continue

loop_end:
    mv a0 t3
    lw ra 0(sp)
    addi sp sp 4
    ret
