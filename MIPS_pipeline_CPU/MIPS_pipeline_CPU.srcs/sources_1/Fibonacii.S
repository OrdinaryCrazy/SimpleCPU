j _start
# 计算斐波那契数列的前 20 项并保存在 memory 
.data
    .space 200
.text
_start:
    addi    $t0, $0, 1              # 200 20080001
    addi    $t1, $0, 1              # 204 20090001
    addi    $t2, $0, 20             # 208 200a0014
    addi    $t3, $0, 0              # 212 200b0000

_fibonacii:
    sw      $t0, ($t3)              # 216 ad680000
    add     $t4, $t0, $t1           # 220 01096020
    addi    $t0, $t1, 0             # 224 21280000
    addi    $t1, $t4, 0             # 228 21890000
    addi	$t2, $t2, -1            # 232 214affff
    addi    $t3, $t3, 4             # 236 216b0004
    bne     $t2, $0 , _fibonacii    # 240 1540fff9


