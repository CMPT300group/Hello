.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
# for (i = 0; i<n;i++)
#   for(j = 0; j<k; j++)
#     row_address = A+i*m*sizeof(int)
#     col_address = B+j*sizeof(int)
#     c[i][j] = dot_product(row_address,1,col_address,m,m)

matmul:

    # Error if mismatched dimensions
    bne a2 a4 mismatched_dimensions
    addi sp sp -32
    sw ra 0(sp)
    
    # Prologue
    mv t0 x0 # i
    mv t1 x0 # j
    mv t4 x0 # d index

outer_loop_start:

   bge t0 a1 outer_loop_end

inner_loop_start:

    bge t1 a5 inner_loop_end
    
    mv t2 t0 # 
    mv t3 t1 #
    slli t2 t2 2
    mul t2 t2 a2
    slli t3 t3 2
    add t2 t2 a0
    add t3 t3 a3

   # Call dot function
    sw a0 4(sp)
    sw a1 8(sp)
    sw a3 12(sp)
    sw a4 16(sp)
    sw t0 20(sp)
    sw t1 24(sp)
    sw t4 28(sp)

    mv a0 t2
    mv a1 t3
    li a3 1
    mv a4 a5

    jal dot

    lw t0 20(sp)
    lw t1 24(sp)
    lw t4 28(sp)

    mul t4 t0 a5
    add t4 t4 t1
    slli t4 t4 2
    add t4 t4 a6
    sw a0 0(t4) 

    lw a0 4(sp)
    lw a1 8(sp)
    lw a3 12(sp)
    lw a4 16(sp)

    addi t1 t1 1

    jal inner_loop_start

inner_loop_end:

    addi t0 t0 1
    mv t1 x0
    jal outer_loop_start

outer_loop_end:
    # Epilogue
    lw ra 0(sp)
    addi sp sp 32

    ret


mismatched_dimensions:
    li a1 2
    jal exit2