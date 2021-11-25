.globl main

.equ N,10       // Set N = 10

A: .word 0,1,2,7,-8,4,5,-12,11,-2       // Define A[N]
B: .word 0,1,2,7,-8,4,5,12,-11,-2       // Define B[N]

.bss
C: .space 4*N                           // Allocate N words for C[N]

.text                                   //Start machine code

main:   
    la t0, A                            //Load in t0 start address of A
    la t1, B                            //Load in t1 start address of B
    la t2, C                            //Load in t2 start address of C
    add t1, t1, 4*(N-1)                 //Move t1 in end address of B 
    li t3, N                            //t3 = N (t3 = i)

loopa:
    lw t4,0(t0)                         //Load in t4 A[N-i]
    lw t5,0(t1)                         //Load in t5 B[i-1]
    add t4,t4,t5                        //t4=A[N-i] + B[i-1]
    bge t4,zero,skip                    //if t4 >=0 skip next instruction
    neg t4,t4                           //t4 = |A[N-i] + B[i-1]

skip:
    sw t4,4(t2)                         //Store t4 in C[N-i]
    addi t0, t0, 4                      //Move t0 in A[N-i+1]
    addi t1, t1, -4                     //Move t1 in B[i-1-1]
    addi t2, t2, 4                      //Move t2 in C[N-i+1]
    addi t3, t3, -1                     //i--
    bne t3,zero,loopa                   //if i>0 loop

.end