.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    addi sp sp -16
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
loop_start:
    li s0 0

loop_continue:
    bge s0 a1 loop_end
    mv s2 s0
    slli s2 s2 2
    add s2 s2 a0
    lw s1 0(s2)
    addi s0 s0 1

    bge s1 x0 loop_continue
    sw x0 0(s2)
    j loop_continue

loop_end:
    lw ra 0(sp)
	lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    addi sp sp 16
    ret
