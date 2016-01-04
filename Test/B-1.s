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
addi $sp, $sp, -480
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
move $t0, $v0
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t0, -4($fp)
lw $t0, -4($fp)
li $t1, 0
ble $t0, $t1, label1
j label2
label1:
li $t2, -1
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t2
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
j label3
label2:
lw $t0, -4($fp)
li $t4, 4
div $t0, $t4
mflo $t3
sw $t3, -8($fp)
lw $t3, -8($fp)
li $t6, 4
mul $t5, $t3, $t6
sw $t5, -12($fp)
lw $t0, -4($fp)
lw $t5, -12($fp)
sub $t7, $t0, $t5
sw $t7, -16($fp)
lw $t0, -4($fp)
li $s1, 100
div $t0, $s1
mflo $s0
sw $s0, -20($fp)
lw $s0, -20($fp)
li $s3, 100
mul $s2, $s0, $s3
sw $s2, -24($fp)
lw $t0, -4($fp)
lw $s2, -24($fp)
sub $s4, $t0, $s2
sw $s4, -28($fp)
lw $t0, -4($fp)
li $s6, 400
div $t0, $s6
mflo $s5
sw $s5, -32($fp)
lw $s5, -32($fp)
li $t0, 400
mul $s7, $s5, $t0
sw $s7, -36($fp)
lw $t2, -4($fp)
lw $s7, -36($fp)
sub $t1, $t2, $s7
sw $t1, -40($fp)
lw $t7, -16($fp)
li $t3, 0
bne $t7, $t3, label4
j label5
label4:
li $t4, 0
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t4
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
j label6
label5:
lw $t1, -40($fp)
li $t5, 0
beq $t1, $t5, label7
j label8
label7:
li $t6, 1
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t6
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
j label9
label8:
lw $s4, -28($fp)
li $t7, 0
beq $s4, $t7, label10
j label11
label10:
li $s0, 0
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s0
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
j label12
label11:
li $s1, 1
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s1
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label12:
label9:
label6:
label3:
li $s2, 0
move $v0, $s2
jr $ra
