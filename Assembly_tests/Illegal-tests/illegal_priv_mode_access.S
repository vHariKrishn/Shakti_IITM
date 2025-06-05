#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

#Illegal Privilege Mode Access Test

    #Seting up trap handler
    la t0, trap_handler
    csrw mtvec, t0
    
    #Switching to user mode
    li t0, 0x1800         #MPP mask for RV64(setting bits [12:11] = 11)
    csrrc zero, mstatus, t0  #Set MPP=00 (User mode)
    la t0, user_code
    csrw mepc, t0
    mret       #Jump to user_code in User mode

user_code:
    #Test 1:Read machine-mode CSR
    csrr a0, mstatus      #Illegal in User mode
    #Test 2:Write machine-mode CSR
    li t0, 0x1000
    csrw mstatus, t0      #Illegal in User mode
    
    #Exit if no exceptions
    li a7, 93
    ecall

trap_handler:
    csrrw sp, mscratch, sp  #Using mscratch for temp storage
    addi sp, sp, -32
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw a0, 8(sp)
    
    #Verify exception cause (mcause=2 => illegal instruction)
    csrr t0, mcause
    li t1, 2
    bne t0, t1, handler_fail
    
    #Skiping faulting instruction
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0
    
handler_exit:
    #Restoring context
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 32
    csrrw sp, mscratch, sp
    mret

handler_fail:
    #Exit with error code
    li a0, 1
    li a7, 93
    ecall


TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
