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

main:
move $fp, $sp
addi $sp, $sp, -240
addi $t1, $fp, -12
move $t0, $t1
sw $t0, -16($fp)
lw $t0, -16($fp)
li $t3, 0
add $t2, $t0, $t3
sw $t2, -20($fp)
lw $t2, -20($fp)
li $t4, 5
sw $t4, 0($t2)
sw $t2, -20($fp)
addi $t6, $fp, -12
move $t5, $t6
sw $t5, -24($fp)
lw $t5, -24($fp)
li $s0, 4
add $t7, $t5, $s0
sw $t7, -28($fp)
lw $t7, -28($fp)
li $s1, 8
sw $s1, 0($t7)
sw $t7, -28($fp)
addi $s3, $fp, -12
move $s2, $s3
sw $s2, -32($fp)
lw $s2, -32($fp)
li $s5, 8
add $s4, $s2, $s5
sw $s4, -36($fp)
lw $s4, -36($fp)
li $s6, 6
sw $s6, 0($s4)
sw $s4, -36($fp)
addi $t0, $fp, -12
move $s7, $t0
sw $s7, -40($fp)
lw $s7, -40($fp)
li $t2, 0
add $t1, $s7, $t2
sw $t1, -44($fp)
addi $t4, $fp, -12
move $t3, $t4
sw $t3, -48($fp)
lw $t3, -48($fp)
li $t6, 4
add $t5, $t3, $t6
sw $t5, -52($fp)
lw $t1, -44($fp)
lw $s0, 0($t1)
lw $t5, -52($fp)
lw $s1, 0($t5)
add $t7, $s0, $s1
sw $t7, -56($fp)
addi $s3, $fp, -12
move $s2, $s3
sw $s2, -60($fp)
lw $s2, -60($fp)
li $s5, 8
add $s4, $s2, $s5
sw $s4, -64($fp)
lw $t7, -56($fp)
lw $s4, -64($fp)
lw $s7, 0($s4)
add $s6, $t7, $s7
sw $s6, -68($fp)
lw $s6, -68($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s6
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t0, 0
move $v0, $t0
jr $ra
