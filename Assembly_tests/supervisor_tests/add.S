#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN


#Addition of immediate value to reg :-
li t1, 3
addi t0, t1, 8
li t2, 11
bne t0, t2, fail

RVTEST_PASS

#Addition of two words :-
li t0, 0x0014820429482947
li t1, 0x0000319504928495
addw t2, t0, t1
li t0, 0x001513993411442
bne t0, t2, fail

RVTEST_PASS


fail:
RVTEST_FAIL



RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
