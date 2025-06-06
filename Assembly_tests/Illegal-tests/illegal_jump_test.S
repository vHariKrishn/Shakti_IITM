#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

#Storing address of trap_handler into t0 and writing it to mtvec
la t0, trap_handler
csrw mtvec, t0

#Test 1: Jump to misaligned address
la t1, valid_label
addi t1, t1, 1
jalr zero, t1, 0

#Test 2: jump to invalid mem location
li t1, 0xFFFFFFFF
jalr zero, t1, 0

#Test 3: Return from trap with bad mepc
la t1, bad_mepc_test
csrw mepc, t1
mret

#Exiting if no exceptions
li a7, 93
ecall

valid_label:
nop

.section .misaligned
.align 2

bad_mepc_test:
.byte 0x01   #Creating misalignment
.byte 0x00
.byte 0x00
.byte 0x00

trap_handler:
csrrw sp, mscratch, sp     #Swapping mscratch with sp (Saving context)
addi sp, sp, -32
sw t0, 0(sp)
sw t1, 4(sp)
sw a0, 8(sp)

#Checking exception cause
csrr t0, mcause
li t1, 2
beq t0, t1, handler_fail

#Skipping faulting instr
csrr t0, mepc
addi t0, t0, 4
csrw mepc, t0

handler_restore:
lw t0, 0(sp)
lw t1, 4(sp)
lw a0, 8(sp)
addi sp, sp, 32
csrrw sp, mscratch, sp
mret

handler_fail:
csrr t0, mepc
addi t0, t0, 4
csrw mepc, t0
j handler_restore



TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END