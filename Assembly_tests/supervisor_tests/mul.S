#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN


#Multiplication of two signed numbers :-
li t0, 3
li t1, 5
mul t2, t1, t0
li t0, 15
bne t0, t2, fail

RVTEST_PASS

#Multiplication of two words where only MS 32 bits are considered :-
li t0, 0x10000000FFFFFFFF
li t1, 0x00000001FFFFFFFF
mulh t2, t0, t1
li t0, 0x10000000FFFFFFFF
bne t0, t2, fail

RVTEST_PASS


fail:
RVTEST_FAIL



RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
