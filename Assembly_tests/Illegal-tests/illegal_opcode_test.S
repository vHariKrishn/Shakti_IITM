#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

    #Setting trap handler
    la t0, trap_handler
    csrw mtvec, t0

    #Test 1: Reserved opcode
    .word 0x0000007F  
    #Test 2: Custom opcode
    .word 0xABCD1234

    #Exit if no exceptions
    li a7, 93
    ecall

trap_handler:
    #Saving context using mscratch
    csrrw sp, mscratch, sp
    addi sp, sp, -32
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw a0, 8(sp)
    
    #Verify exception cause (mcause=2)
    csrr t0, mcause
    li t1, 2
    bne t0, t1, handler_error

    #Skipping faulting instruction
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0

handler_restore:
    #Restoring context
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 32
    csrrw sp, mscratch, sp
    mret

handler_error:
    #Error handling for unexpected traps
    li a0, 1
    li a7, 93
    ecall


TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
