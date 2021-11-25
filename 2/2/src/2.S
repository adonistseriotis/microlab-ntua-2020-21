# GPIO_SWs = 0x80001400
# GPIO_LEDs = 0x80001404
# GPIO_INOUT = 0x80001408

.globl main
.equ N, 16
main:
    li t0, 0x80001400  //base address of GPIO memory-mapped registers
    sw t1, 8(t0)
    li t2, N
    li t3, N
    loop1:  //loop N times
        li t4, 1 
        lw t5, 4(t0)    //load LEDs
        loop2:          //loop N-i times 
        or s1, t5, t4  //add slidding LED
        sw   s1, 4(t0)  //Store it
        slli t4, t4, 1  //Slide to the left!
        addi t3,t3,-1      //j--
        bne t3, zero, loop2 
    addi t2,t2,-1         //i--
    mv t3, t2
    bne t2, zero, loop1 //if t2>0 loop1

    li t2, N
    li t3, N
    
    loop3:  //loop N times
        li t4, 1
        slli t4,t4,15 
        lw t5, 4(t0)    //load LEDs
        loop4:  //loop N-i times 
        xor s1, t5, t4  //add slidding LED
        sw   s1, 4(t0)  //Store it
        srli t4, t4, 1  //Slide to the left!
        addi t3,t3,-1      //j--
        bne t3, zero, loop4
    addi t2,t2,-1         //i--
    mv t3, t2
    bne t2, zero, loop3

.end