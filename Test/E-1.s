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
addi $sp, $sp, -132
addi $t1, $fp, -8
move $t0, $t1
sw $t0, -12($fp)
lw $t0, -12($fp)
li $t3, 0
add $t2, $t0, $t3
sw $t2, -16($fp)
lw $t2, -16($fp)
li $t4, 2
sw $t4, 0($t2)
sw $t2, -16($fp)
addi $t6, $fp, -8
move $t5, $t6
sw $t5, -20($fp)
lw $t5, -20($fp)
li $s0, 4
add $t7, $t5, $s0
sw $t7, -24($fp)
lw $t7, -24($fp)
li $s1, 4
sw $s1, 0($t7)
sw $t7, -24($fp)
addi $s3, $fp, -8
move $s2, $s3
sw $s2, -28($fp)
lw $s2, -28($fp)
li $s5, 0
add $s4, $s2, $s5
sw $s4, -32($fp)
lw $s4, -32($fp)
lw $s6, 0($s4)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s6
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $s7, 0
move $v0, $s7
jr $ra
