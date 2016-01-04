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
addi $sp, $sp, -396
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
move $t0, $v0
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t0, -4($fp)
li $t2, 2
move $t1, $t2
sw $t1, -8($fp)
label1:
lw $t1, -8($fp)
lw $t0, -4($fp)
ble $t1, $t0, label2
j label3
label2:
li $t4, 2
move $t3, $t4
sw $t3, -12($fp)
lw $t1, -8($fp)
li $t6, 2
div $t1, $t6
mflo $t5
sw $t5, -16($fp)
li $s0, 1
move $t7, $s0
sw $t7, -20($fp)
label4:
lw $t3, -12($fp)
lw $t5, -16($fp)
ble $t3, $t5, label5
j label6
label5:
lw $t1, -8($fp)
lw $t3, -12($fp)
div $t1, $t3
mflo $s1
sw $s1, -24($fp)
lw $s1, -24($fp)
lw $t3, -12($fp)
mul $s2, $s1, $t3
sw $s2, -28($fp)
lw $t1, -8($fp)
lw $s2, -28($fp)
sub $s3, $t1, $s2
sw $s3, -32($fp)
lw $s3, -32($fp)
li $s4, 0
beq $s3, $s4, label7
j label8
label7:
lw $t7, -20($fp)
li $s5, 0
move $t7, $s5
sw $t7, -20($fp)
label8:
lw $t3, -12($fp)
lw $t3, -12($fp)
li $s6, 1
add $t3, $t3, $s6
sw $t3, -12($fp)
j label4
label6:
lw $t7, -20($fp)
li $s7, 1
beq $t7, $s7, label9
j label10
label9:
lw $t1, -8($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t1
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label10:
lw $t1, -8($fp)
lw $t1, -8($fp)
li $t0, 1
add $t1, $t1, $t0
sw $t1, -8($fp)
j label1
label3:
li $t1, 0
move $v0, $t1
jr $ra
