.import ../read_matrix.s
.import ../write_matrix.s
.import ../matmul.s
.import ../dot.s
.import ../relu.s
.import ../argmax.s
.import ../utils.s

.data
output_step1: .asciiz "\n**Step 1: hidden_layer = matmul(m0, input)**\n"
output_step2: .asciiz "\n**Step 2: NONLINEAR LAYER: ReLU(hidden_layer)** \n"
output_step3: .asciiz "\n**Step 3: Linear layer = matmul(m1, relu)** \n"
output_step4: .asciiz "\n**Step 4: Argmax ** \n"
.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <INPUT_PATH> <M0_PATH> <M1_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args

    li t0 4
    bne a0 t0 mismatched_args # check later

    addi sp sp -32

    # lw t0 4(a1) # input path
    # lw t1 8(a1) # M0 path
    # lw t2 12(a1) # M1 path
    # lw t3 16(a1) # Output path
    mv s0 a1

	# =====================================
    # LOAD MATRICES
    # =====================================
    # READ MATRIX FUNCTION
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory

    # Load pretrained m0

    addi a0 x0 4
    jal malloc
    mv s1 a0

    # allocate space for col int ptr

    addi a0 x0 4
    jal malloc
    mv s2 a0

    lw a0 8(s0)
    mv a1 s1
    mv a2 s2

    jal read_matrix

    mv s7 a0 # value for first matrix

    # Load pretrained m1

    addi a0 x0 4
    jal malloc
    mv s3 a0

    # allocate space for col int ptr

    addi a0 x0 4
    jal malloc # allocate space for 4 bytes for size
    mv s4 a0 

    lw a0 12(s0)
    mv a1 s3
    mv a2 s4

    jal read_matrix

    mv s8 a0 # value for second matrix

    # Load input matrix

    addi a0 x0 4
    jal malloc
    mv s5 a0

    # allocate space for col int ptr

    addi a0 x0 4
    jal malloc # allocate space for 4 bytes for size
    mv s6 a0 

    lw a0 4(s0)
    mv a1 s5
    mv a2 s6

    jal read_matrix

    mv s9 a0 # value for input matrix

                   # MATMUL
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

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input

    
    lw a1 0(s1)
    lw a2 0(s6)
    
    mul a0 a1 a2
    slli a0 a0 2

    jal malloc
    mv a6 a0

    mv s10 a0

    mv a0 s7
    lw a1 0(s1)
    lw a2 0(s2)

    mv a3 s9
    lw a4 0(s5)
    lw a5 0(s6)

    jal matmul

 # a6 = m0 * input (pointer)
    # mv a0 s10
    # lw a1 0(s1)
    # lw a2 0(s6)
    # jal print_int_array

    # mv a1 a6 # Copy address for output?

    # Output of stage 1
    la a1, output_step1
    jal print_str

    ## FILL OUT
    mv a0 a6
    lw a1 0(s1)
    mv a2 a5
    jal print_int_array 

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
                   #RELU
    # Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
    mv a0 a6
    lw a1 0(s1)
    mul a1 a1 a5
    jal relu

    # Output of stage 1
    la a1, output_step2
    jal print_str

    ## FILL OUT
    mv a0 a6
    lw a1 0(s1)
    lw a2 0(s6)
    jal print_int_array 
# a0 = ReLU(m0 * input)

                   # MATMUL
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

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    
    mv a3 a6
    lw a4 0(s1)
    lw a5 0(s6)

    lw a1 0(s3)
    lw a2 0(s6)
    
    mul a0 a1 a2
    slli a0 a0 2

    jal malloc
    mv a6 a0

    mv a0 s8
    lw a1 0(s3)
    lw a2 0(s4)

    jal matmul

    # Output of stage 3
    la a1, output_step3
    jal print_str

    ## FILL OUT
     mv a0 a6
     lw a1 0(s3) # possibly wrong
     lw a2 0(s6) # possibly wrong
     jal print_int_array 


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0) # Load pointer to output filename



               # ARGMAX
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0 a6
    lw a1 0(s3)
    lw a2 0(s6)
    mul a1 a1 a2
    jal argmax

    mv a7 a0

    # Print classification

    # Output of stage 3
    la a1, output_step4
    jal print_str

    ## FILL OUT
     mv a1 a7
     jal print_int



    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit

    
    mismatched_args:
    li a1 2
    jal exit2
