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

fact:
move $fp, $sp
addi $sp, $sp, -156
lw $t0, 8($fp)
sw $t0, -4($fp)
lw $t1, -4($fp)
li $t2, 1
beq $t1, $t2, label1
j label2
label1:
lw $t3, -4($fp)
move $v0, $t3
jr $ra
j label3
label2:
lw $t5, -4($fp)
li $t6, 1
sub $t4, $t5, $t6
sw $t4, -8($fp)
lw $t7, -8($fp)
addi $sp, $sp, -4
sw $t7, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal fact
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $s0, $v0
addi $sp, $sp, 4
sw $s0, -12($fp)
lw $s2, -4($fp)
lw $s3, -12($fp)
mul $s1, $s2, $s3
sw $s1, -16($fp)
lw $s4, -16($fp)
move $v0, $s4
jr $ra
label3:

main:
move $fp, $sp
addi $sp, $sp, -144
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
move $t0, $v0
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t0, -4($fp)
lw $t1, -4($fp)
li $t2, 1
bgt $t1, $t2, label4
j label5
label4:
lw $t3, -4($fp)
addi $sp, $sp, -4
sw $t3, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal fact
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t4, $v0
addi $sp, $sp, 4
sw $t4, -8($fp)
j label6
label5:
lw $t5, -8($fp)
li $t6, 1
move $t5, $t6
sw $t5, -8($fp)
label6:
lw $t7, -8($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t7
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $s0, 0
move $v0, $s0
jr $ra
