.global _start

_start:
    addi x1, x0, 0x10   #1
    li   x2, -1         #2
    nop                 #3
    li   x3, 16         #4

    bge x2, x3, error    #5
    bge x3, x2, first_branch    #6
    j error                         #7

first_branch:
    blt x3, x2, error   #8                  //Working
    blt x2, x3, second_branch   #9
    j error                     #a

second_branch:
    blt x1, x3, error           #b          //working
    bge x1, x3, third_branch    #c

error:
    j error                     #d

third_branch:
    bne x1, x3, error           #e          //working
    bne x1, x2, test2           #f
    j error                     #10
test2:
    bne x2, x1, fourth_branch   #11         //Wokring
    j error                     #12

fourth_branch:
    beq x1, x2, error           #13         //working
    beq x1, x3, fifth_branch     #14
    j error                     #15

fifth_branch:
    bltu x2, x1, error          #16         //working
    bltu x1, x2, sixth_branch   #17         
    j error                     #18

sixth_branch:
    bgeu x1, x2, error          #19         //working
    bgeu x2, x1, seventh_branch #1a
    j error                     #1b

seventh_branch:
    bltu x1, x3, error          #1c         //working
    bgeu x1, x3, factorial_init #1d
    j error                     #1e

factorial_init:
    li a0, 5                    #1f         //working
    li sp, 0x100                #20
    jal ra, factorial           #21
    sw a0, 0x0C(x0)              #22
    j end                       #23
    nop                         #24

factorial:
    addi sp, sp, -4             #25
    sw   s0, 0x0(sp)            #26
    
    li s0, 1                    #27

    j factorial_conditional     #28

factorial_end:
    lw  s0, 0x0(sp)             #29
    addi sp, sp, 4              #2a
    ret                         #2b

factorial_conditional:
    bge a0, s0, recursive_function  #continue if n >= 2     #2c
    li a0, 0                                                #2d //What to do at bottom most case
    ret                                                     #2e

recursive_function:
    #otherwise add again
    addi sp, sp, -8                                         #2f
    sw   a0, 4(sp)                                          #30
    sw   ra, 0(sp)                                          #31

    addi a0, a0, -1                                         #32
    jal ra, factorial_conditional                           #33 //Traveling to the bottom

    lw t0, 4(sp)                                            #34 //Doing the work to complete the function
    lw ra, 0(sp)                                            #35

    addi sp, sp, 8                                          #36

    add a0, a0, t0 #in replacement of multiply              #37

    ret                                                     #38
    
end:
    nop                                                     #39
