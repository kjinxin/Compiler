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
li $t1, 10
move $t0, $t1
sw $t0, -4($fp)
li $t3, 20
move $t2, $t3
sw $t2, -8($fp)
li $t5, 3
move $t4, $t5
sw $t4, -12($fp)
lw $t2, -8($fp)
lw $t4, -12($fp)
mul $t6, $t2, $t4
sw $t6, -16($fp)
lw $t0, -4($fp)
lw $t6, -16($fp)
add $t7, $t0, $t6
sw $t7, -20($fp)
lw $t7, -20($fp)
lw $t2, -8($fp)
sub $s0, $t7, $t2
sw $s0, -24($fp)
lw $s0, -24($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s0
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, -4($fp)
lw $t2, -8($fp)
add $s1, $t0, $t2
sw $s1, -28($fp)
lw $s0, -24($fp)
lw $s1, -28($fp)
lw $t4, -12($fp)
div $s1, $t4
mflo $s0
sw $s0, -24($fp)
lw $s0, -24($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s0
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, -4($fp)
lw $t0, -4($fp)
lw $t2, -8($fp)
add $t0, $t0, $t2
sw $t0, -4($fp)
lw $t2, -8($fp)
lw $t0, -4($fp)
lw $t2, -8($fp)
sub $t2, $t0, $t2
sw $t2, -8($fp)
lw $t0, -4($fp)
lw $t0, -4($fp)
lw $t2, -8($fp)
sub $t0, $t0, $t2
sw $t0, -4($fp)
lw $t0, -4($fp)
lw $t2, -8($fp)
sub $s2, $t0, $t2
sw $s2, -32($fp)
lw $s2, -32($fp)
li $s4, 2
div $s2, $s4
mflo $s3
sw $s3, -36($fp)
lw $t0, -4($fp)
lw $t2, -8($fp)
div $t0, $t2
mflo $s5
sw $s5, -40($fp)
lw $s5, -40($fp)
li $s7, 2
mul $s6, $s5, $s7
sw $s6, -44($fp)
lw $t2, -8($fp)
lw $s3, -36($fp)
lw $s6, -44($fp)
add $t2, $s3, $s6
sw $t2, -8($fp)
lw $t2, -8($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t2
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t0, 0
move $v0, $t0
jr $ra
