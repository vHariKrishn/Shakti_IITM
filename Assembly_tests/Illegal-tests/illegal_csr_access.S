#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

#Trying to write to read-only CSRs to trigger illegal instruction exceptions

    #Setting up trap handler address
    la t0, trap_handler
    csrw mtvec, t0

    #Test 1:Trying to write to the read-only mhartid register
    li t1, 0x1234
    csrrw zero, mhartid, t1   
    #Test 2:Trying to write to the read-only mvendorid register
    li t1, 0x5678
    csrrw zero, mvendorid, t1    
    #Test 3:Trying to write to the read-only marchid register
    li t1, 0x9abc
    csrrw zero, marchid, t1     
    #Test 4:Trying to write to the read-only mimpid register
    li t1, 0xdef0
    csrrw zero, mimpid, t1      
    #Test 5:Trying to write to a reserved/unimplemented CSR (0x7FF)
    li t1, 0x1111
    csrrw zero, 0x7FF, t1   

    #Exit
    li a7, 93
    li a0, 0
    ecall

#Trap handler will run when an illegal instruction is executed
trap_handler:
    csrr t0, mcause
    li t1, 2  #Read mcause to check the exception type (2 means illegal instruction)
    bne t0, t1, trap_exit   #If not illegal instruction, exit

    #Skip the instruction that caused the exception
    csrr t2, mepc
    addi t2, t2, 4
    csrw mepc, t2

trap_exit:
    mret     #Return from trap, continuing execution

TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
