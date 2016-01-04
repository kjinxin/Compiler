.data
_prompt: .asciiz "Enter an integer:"
_ret: .asciiz "\n"
.globl main
.text

read:
 li $v0, 4
 la $a0, _prompt
 syscall
 li $v0, 5
 syscall
 jr $ra

write:
 li $v0, 1
 syscall
 li $v0, 4
 la $a0, _ret
 syscall
 move $v0, $0
 jr $ra

crossProduct:
move $fp, $sp
addi $sp, $sp, -120
lw $t0, 8($fp)
sw $t0, -4($fp)
lw $t1, 12($fp)
sw $t1, -8($fp)
lw $t0, -4($fp)
li $t3, 0
add $t2, $t0, $t3
sw $t2, -12($fp)
lw $t1, -8($fp)
li $t5, 4
add $t4, $t1, $t5
sw $t4, -16($fp)
lw $t2, -12($fp)
lw $t7, 0($t2)
lw $t4, -16($fp)
lw $s0, 0($t4)
mul $t6, $t7, $s0
sw $t6, -20($fp)
lw $t0, -4($fp)
li $s2, 4
add $s1, $t0, $s2
sw $s1, -24($fp)
lw $t1, -8($fp)
li $s4, 0
add $s3, $t1, $s4
sw $s3, -28($fp)
lw $s1, -24($fp)
lw $s6, 0($s1)
lw $s3, -28($fp)
lw $s7, 0($s3)
mul $s5, $s6, $s7
sw $s5, -32($fp)
lw $t6, -20($fp)
lw $s5, -32($fp)
sub $t0, $t6, $s5
sw $t0, -36($fp)
lw $t0, -36($fp)
move $v0, $t0
jr $ra

main:
move $fp, $sp
addi $sp, $sp, -252
addi $t1, $fp, -8
move $t0, $t1
sw $t0, -20($fp)
lw $t0, -20($fp)
li $t3, 0
add $t2, $t0, $t3
sw $t2, -24($fp)
lw $t2, -24($fp)
li $t4, 1
sw $t4, 0($t2)
sw $t2, -24($fp)
addi $t6, $fp, -8
move $t5, $t6
sw $t5, -28($fp)
lw $t5, -28($fp)
li $s0, 4
add $t7, $t5, $s0
sw $t7, -32($fp)
lw $t7, -32($fp)
li $s1, 2
sw $s1, 0($t7)
sw $t7, -32($fp)
addi $s3, $fp, -16
move $s2, $s3
sw $s2, -36($fp)
lw $s2, -36($fp)
li $s5, 0
add $s4, $s2, $s5
sw $s4, -40($fp)
lw $s4, -40($fp)
li $s6, 3
sw $s6, 0($s4)
sw $s4, -40($fp)
addi $t0, $fp, -16
move $s7, $t0
sw $s7, -44($fp)
lw $s7, -44($fp)
li $t2, 4
add $t1, $s7, $t2
sw $t1, -48($fp)
lw $t1, -48($fp)
li $t3, 6
sw $t3, 0($t1)
sw $t1, -48($fp)
addi $t5, $fp, -8
move $t4, $t5
sw $t4, -52($fp)
addi $t7, $fp, -16
move $t6, $t7
sw $t6, -56($fp)
lw $t6, -56($fp)
addi $sp, $sp, -4
sw $t6, 0($sp)
lw $t4, -52($fp)
addi $sp, $sp, -4
sw $t4, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal crossProduct
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $s0, $v0
addi $sp, $sp, 8
sw $s0, -60($fp)
lw $s0, -60($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s0
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $s1, 0
move $v0, $s1
jr $ra
