#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN


#Division of two unsigned numbers :-
li t0, -6
li t1, -4
divu t2, t1, t0
li t0, 1
bne t0, t2, fail


RVTEST_PASS

#Division of two words where only LS 32 bits are considered :-
li t0, 0xFFFFFFFF10000000
li t1, 0xFFFFFFFF00000001
divuw t2, t0, t1
li t0, 0xFFFFFFFF10000000
bne t0, t2, fail

RVTEST_PASS


fail:
RVTEST_FAIL



RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
