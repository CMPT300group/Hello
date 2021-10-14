.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_files/test_input.bin"

.text
main:
    # Read matrix into memory

    li a0 4
    jal malloc
    mv s0 a0
    li a0 4
    jal malloc
    mv s1 a0
    la a0 file_path
    mv a1 s0
    mv a2 s1
    jal read_matrix

    # Print out elements of matrix

    lw a1 0(s0)
    lw a2 0(s1)
    jal print_int_array

    # Terminate the program

    addi a0, x0, 10
    ecall