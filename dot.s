.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
    addi sp sp -32
    sw ra 0(sp)
    sw t0 4(sp)
    sw t1 8(sp)
    sw t2 12(sp)
    sw t3 16(sp)
    sw t4 20(sp)
    sw t5 24(sp)
    sw t6 28(sp)

loop_start:
    mv t1 x0
    mv t6 x0
    mv t2 x0
    mv t3 x0
    mv s11 a0
    mv s10 a1

loop_continue:
    bge t1 a2 loop_end
    mv t2 t1
    mv t3 t1   
    slli t2 t2 2
    slli t3 t3 2
    mul t2 t2 a3
    mul t3 t3 a4
    add t2 t2 s11
    add t3 t3 s10
    lw t0 0(t2)
    lw t5 0(t3)
    mul t0 t0 t5
    add t6 t6 t0 
    addi t1 t1 1

    jal loop_continue

loop_end:
    mv a0 t6
    lw ra 0(sp)
    lw t0 0(sp)
    lw t1 8(sp)
    lw t2 12(sp)
    lw t3 16(sp)
    lw t4 20(sp)
    lw t5 24(sp)
    lw t6 28(sp)
    addi sp sp 32
    ret
