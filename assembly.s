main: lui $t1, 5
 sw $t1, 4
 lui $t3, 6
 lui $t3, 7
 lw $10, 4
 lui $t3, 8
 lui $t3, 9
 beq $t2, $t1, success
 j failure
success:lui $v0, 1
failure:lui $v0, 2