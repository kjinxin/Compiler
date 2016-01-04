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

power:
move $fp, $sp
addi $sp, $sp, -144
lw $t0, 8($fp)
sw $t0, -4($fp)
lw $t1, 12($fp)
sw $t1, -8($fp)
li $t3, 1
move $t2, $t3
sw $t2, -12($fp)
label1:
lw $t1, -8($fp)
li $t4, 0
bgt $t1, $t4, label2
j label3
label2:
lw $t2, -12($fp)
lw $t2, -12($fp)
lw $t0, -4($fp)
mul $t2, $t2, $t0
sw $t2, -12($fp)
lw $t1, -8($fp)
lw $t1, -8($fp)
li $t5, 1
sub $t1, $t1, $t5
sw $t1, -8($fp)
j label1
label3:
lw $t2, -12($fp)
move $v0, $t2
jr $ra

mod:
move $fp, $sp
addi $sp, $sp, -72
lw $t0, 8($fp)
sw $t0, -4($fp)
lw $t1, 12($fp)
sw $t1, -8($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
div $t0, $t1
mflo $t2
sw $t2, -12($fp)
lw $t2, -12($fp)
lw $t1, -8($fp)
mul $t3, $t2, $t1
sw $t3, -16($fp)
lw $t0, -4($fp)
lw $t3, -16($fp)
sub $t4, $t0, $t3
sw $t4, -20($fp)
lw $t4, -20($fp)
move $v0, $t4
jr $ra

getNumDigits:
move $fp, $sp
addi $sp, $sp, -192
lw $t0, 8($fp)
sw $t0, -4($fp)
li $t2, 0
move $t1, $t2
sw $t1, -8($fp)
lw $t0, -4($fp)
li $t3, 0
blt $t0, $t3, label4
j label5
label4:
li $t4, -1
move $v0, $t4
jr $ra
label5:
label6:
lw $t0, -4($fp)
li $t5, 0
bgt $t0, $t5, label7
j label8
label7:
lw $t0, -4($fp)
lw $t0, -4($fp)
li $t6, 10
div $t0, $t6
mflo $t0
sw $t0, -4($fp)
lw $t1, -8($fp)
lw $t1, -8($fp)
li $t7, 1
add $t1, $t1, $t7
sw $t1, -8($fp)
j label6
label8:
lw $t1, -8($fp)
move $v0, $t1
jr $ra

isNarcissistic:
move $fp, $sp
addi $sp, $sp, -336
lw $t0, 8($fp)
sw $t0, -4($fp)
lw $t0, -4($fp)
addi $sp, $sp, -4
sw $t0, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal getNumDigits
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t1, $v0
addi $sp, $sp, 4
sw $t1, -8($fp)
li $t3, 0
move $t2, $t3
sw $t2, -12($fp)
lw $t0, -4($fp)
move $t4, $t0
sw $t4, -16($fp)
label9:
lw $t4, -16($fp)
li $t5, 0
bgt $t4, $t5, label10
j label11
label10:
li $t6, 10
addi $sp, $sp, -4
sw $t6, 0($sp)
lw $t4, -16($fp)
addi $sp, $sp, -4
sw $t4, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal mod
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t7, $v0
addi $sp, $sp, 8
sw $t7, -20($fp)
lw $t4, -16($fp)
lw $t7, -20($fp)
sub $s0, $t4, $t7
sw $s0, -24($fp)
lw $t4, -16($fp)
lw $s0, -24($fp)
li $s1, 10
div $s0, $s1
mflo $t4
sw $t4, -16($fp)
lw $t1, -8($fp)
addi $sp, $sp, -4
sw $t1, 0($sp)
lw $t7, -20($fp)
addi $sp, $sp, -4
sw $t7, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal power
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $s2, $v0
addi $sp, $sp, 8
sw $s2, -28($fp)
lw $t2, -12($fp)
lw $t2, -12($fp)
lw $s2, -28($fp)
add $t2, $t2, $s2
sw $t2, -12($fp)
j label9
label11:
lw $t2, -12($fp)
lw $t0, -4($fp)
beq $t2, $t0, label12
j label13
label12:
li $s3, 1
move $v0, $s3
jr $ra
j label14
label13:
li $s4, 0
move $v0, $s4
jr $ra
label14:

printHexDigit:
move $fp, $sp
addi $sp, $sp, -132
lw $t0, 8($fp)
sw $t0, -4($fp)
lw $t0, -4($fp)
li $t1, 10
blt $t0, $t1, label15
j label16
label15:
lw $t0, -4($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t0
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
j label17
label16:
li $t3, 0
lw $t0, -4($fp)
sub $t2, $t3, $t0
sw $t2, -8($fp)
lw $t2, -8($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t2
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label17:
li $t4, 0
move $v0, $t4
jr $ra

printHex:
move $fp, $sp
addi $sp, $sp, -384
lw $t0, 8($fp)
sw $t0, -4($fp)
li $t2, 0
move $t1, $t2
sw $t1, -24($fp)
label18:
lw $t1, -24($fp)
li $t3, 4
blt $t1, $t3, label19
j label20
label19:
addi $t5, $fp, -20
move $t4, $t5
sw $t4, -28($fp)
lw $t1, -24($fp)
li $t7, 4
mul $t6, $t1, $t7
sw $t6, -32($fp)
lw $t4, -28($fp)
lw $t6, -32($fp)
add $s0, $t4, $t6
sw $s0, -36($fp)
li $s1, 16
addi $sp, $sp, -4
sw $s1, 0($sp)
lw $t0, -4($fp)
addi $sp, $sp, -4
sw $t0, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal mod
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $s2, $v0
addi $sp, $sp, 8
sw $s2, -40($fp)
lw $s0, -36($fp)
lw $s2, -40($fp)
sw $s2, 0($s0)
sw $s0, -36($fp)
lw $t0, -4($fp)
lw $t0, -4($fp)
li $s3, 16
div $t0, $s3
mflo $t0
sw $t0, -4($fp)
lw $t1, -24($fp)
lw $t1, -24($fp)
li $s4, 1
add $t1, $t1, $s4
sw $t1, -24($fp)
j label18
label20:
lw $t1, -24($fp)
li $s5, 3
move $t1, $s5
sw $t1, -24($fp)
label21:
lw $t1, -24($fp)
li $s6, 0
bge $t1, $s6, label22
j label23
label22:
addi $t0, $fp, -20
move $s7, $t0
sw $s7, -44($fp)
lw $t2, -24($fp)
li $t3, 4
mul $t1, $t2, $t3
sw $t1, -48($fp)
lw $s7, -44($fp)
lw $t1, -48($fp)
add $t4, $s7, $t1
sw $t4, -52($fp)
lw $t4, -52($fp)
lw $t5, 0($t4)
addi $sp, $sp, -4
sw $t5, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal printHexDigit
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t6, $v0
addi $sp, $sp, 4
sw $t6, -56($fp)
lw $t2, -24($fp)
lw $t2, -24($fp)
li $t7, 1
sub $t2, $t2, $t7
sw $t2, -24($fp)
j label21
label23:
li $s0, 0
move $v0, $s0
jr $ra

main:
move $fp, $sp
addi $sp, $sp, -228
li $t1, 0
move $t0, $t1
sw $t0, -4($fp)
li $t3, 9474
move $t2, $t3
sw $t2, -8($fp)
label24:
lw $t2, -8($fp)
li $t4, 9475
blt $t2, $t4, label25
j label26
label25:
lw $t2, -8($fp)
addi $sp, $sp, -4
sw $t2, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal isNarcissistic
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t5, $v0
addi $sp, $sp, 4
sw $t5, -12($fp)
lw $t5, -12($fp)
li $t6, 1
beq $t5, $t6, label27
j label28
label27:
lw $t2, -8($fp)
addi $sp, $sp, -4
sw $t2, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal printHex
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t7, $v0
addi $sp, $sp, 4
sw $t7, -16($fp)
lw $t0, -4($fp)
lw $t0, -4($fp)
li $s0, 1
add $t0, $t0, $s0
sw $t0, -4($fp)
label28:
lw $t2, -8($fp)
lw $t2, -8($fp)
li $s1, 1
add $t2, $t2, $s1
sw $t2, -8($fp)
j label24
label26:
lw $t0, -4($fp)
move $v0, $t0
jr $ra
