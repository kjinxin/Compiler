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

fib:
move $fp, $sp
addi $sp, $sp, -276
lw $t0, 8($fp)
sw $t0, -4($fp)
lw $t1, -4($fp)
li $t2, 0
beq $t1, $t2, label1
j label2
label1:
li $t3, 1
move $v0, $t3
jr $ra
j label3
label2:
lw $t4, -4($fp)
li $t5, 1
beq $t4, $t5, label4
j label5
label4:
li $t6, 1
move $v0, $t6
jr $ra
j label6
label5:
lw $s0, -4($fp)
li $s1, 1
sub $t7, $s0, $s1
sw $t7, -8($fp)
lw $s2, -8($fp)
addi $sp, $sp, -4
sw $s2, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal fib
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $s3, $v0
addi $sp, $sp, 4
sw $s3, -12($fp)
lw $s5, -4($fp)
li $s6, 2
sub $s4, $s5, $s6
sw $s4, -16($fp)
lw $s7, -16($fp)
addi $sp, $sp, -4
sw $s7, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal fib
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t0, $v0
addi $sp, $sp, 4
sw $t0, -20($fp)
lw $t2, -12($fp)
lw $t3, -20($fp)
add $t1, $t2, $t3
sw $t1, -24($fp)
lw $t4, -24($fp)
move $v0, $t4
jr $ra
label6:
label3:

main:
move $fp, $sp
addi $sp, $sp, -192
li $t0, 5
addi $sp, $sp, -4
sw $t0, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal fib
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t1, $v0
addi $sp, $sp, 4
sw $t1, -4($fp)
lw $t2, -4($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t2
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t3, 4
addi $sp, $sp, -4
sw $t3, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal fib
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t4, $v0
addi $sp, $sp, 4
sw $t4, -8($fp)
lw $t5, -8($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t5
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t6, 3
addi $sp, $sp, -4
sw $t6, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal fib
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t7, $v0
addi $sp, $sp, 4
sw $t7, -12($fp)
lw $s0, -12($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s0
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $s1, 2
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal fib
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $s2, $v0
addi $sp, $sp, 4
sw $s2, -16($fp)
lw $s3, -16($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s3
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $s4, 1
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal fib
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $s5, $v0
addi $sp, $sp, 4
sw $s5, -20($fp)
lw $s6, -20($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s6
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $s7, 0
move $v0, $s7
jr $ra
