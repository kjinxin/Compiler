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
addi $sp, $sp, -816
li $t1, 1
move $t0, $t1
sw $t0, -4($fp)
li $t3, 3
move $t2, $t3
sw $t2, -8($fp)
li $t5, 13
move $t4, $t5
sw $t4, -12($fp)
lw $t0, -4($fp)
lw $t2, -8($fp)
add $t6, $t0, $t2
sw $t6, -16($fp)
lw $t0, -4($fp)
lw $t2, -8($fp)
add $t7, $t0, $t2
sw $t7, -20($fp)
lw $t7, -20($fp)
lw $t4, -12($fp)
add $s0, $t7, $t4
sw $s0, -24($fp)
lw $t0, -4($fp)
lw $t2, -8($fp)
add $s1, $t0, $t2
sw $s1, -28($fp)
lw $s1, -28($fp)
lw $t4, -12($fp)
add $s2, $s1, $t4
sw $s2, -32($fp)
li $s4, 42
move $s3, $s4
sw $s3, -36($fp)
li $s6, 0
move $s5, $s6
sw $s5, -40($fp)
lw $t0, -4($fp)
lw $t2, -8($fp)
add $s7, $t0, $t2
sw $s7, -44($fp)
lw $s7, -44($fp)
lw $t4, -12($fp)
add $t0, $s7, $t4
sw $t0, -48($fp)
lw $t0, -48($fp)
lw $t6, -16($fp)
sub $t1, $t0, $t6
sw $t1, -52($fp)
lw $t1, -52($fp)
lw $s0, -24($fp)
sub $t2, $t1, $s0
sw $t2, -56($fp)
lw $s2, -32($fp)
lw $t2, -56($fp)
lw $s2, -32($fp)
add $s2, $t2, $s2
sw $s2, -32($fp)
lw $s2, -32($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s2
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t4, -8($fp)
lw $t5, -4($fp)
sub $t3, $t4, $t5
sw $t3, -60($fp)
lw $t3, -60($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t3
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label1:
lw $t4, -8($fp)
lw $t5, -4($fp)
sub $t6, $t4, $t5
sw $t6, -64($fp)
lw $s2, -32($fp)
lw $t6, -64($fp)
bgt $s2, $t6, label2
j label3
label2:
lw $s2, -32($fp)
lw $t4, -8($fp)
sub $t7, $s2, $t4
sw $t7, -68($fp)
lw $t5, -4($fp)
li $s1, 2
mul $s0, $t5, $s1
sw $s0, -72($fp)
lw $t7, -68($fp)
lw $s0, -72($fp)
add $s2, $t7, $s0
sw $s2, -76($fp)
lw $s4, -12($fp)
lw $s5, -16($fp)
mul $s3, $s4, $s5
sw $s3, -80($fp)
lw $s2, -76($fp)
lw $s3, -80($fp)
add $s6, $s2, $s3
sw $s6, -84($fp)
lw $s6, -84($fp)
lw $t0, -32($fp)
sub $s7, $s6, $t0
sw $s7, -88($fp)
lw $s7, -88($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s7
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t2, -40($fp)
li $t3, 4
mul $t1, $t2, $t3
sw $t1, -92($fp)
lw $t5, -36($fp)
lw $t1, -92($fp)
add $t4, $t5, $t1
sw $t4, -96($fp)
lw $t4, -96($fp)
li $t7, 3
add $t6, $t4, $t7
sw $t6, -100($fp)
lw $t6, -100($fp)
li $s1, 4
add $s0, $t6, $s1
sw $s0, -104($fp)
lw $t5, -36($fp)
lw $s0, -104($fp)
li $s2, 5
add $t5, $s0, $s2
sw $t5, -36($fp)
lw $t2, -40($fp)
li $s4, 1
add $s3, $t2, $s4
sw $s3, -108($fp)
lw $t2, -40($fp)
lw $s3, -108($fp)
li $s5, 0
add $t2, $s3, $s5
sw $t2, -40($fp)
lw $t2, -40($fp)
li $s7, 3
div $t2, $s7
mflo $s6
sw $s6, -112($fp)
lw $s6, -112($fp)
li $t1, 3
mul $t0, $s6, $t1
sw $t0, -116($fp)
lw $t3, -40($fp)
lw $t0, -116($fp)
sub $t2, $t3, $t0
sw $t2, -120($fp)
lw $t5, -4($fp)
lw $t5, -4($fp)
sub $t4, $t5, $t5
sw $t4, -124($fp)
lw $t4, -124($fp)
lw $t7, -8($fp)
add $t6, $t4, $t7
sw $t6, -128($fp)
lw $t6, -128($fp)
lw $t7, -8($fp)
sub $s0, $t6, $t7
sw $s0, -132($fp)
lw $t2, -120($fp)
lw $s0, -132($fp)
beq $t2, $s0, label4
j label5
label4:
lw $s1, -32($fp)
lw $s1, -32($fp)
li $s2, 2
add $s1, $s1, $s2
sw $s1, -32($fp)
label5:
lw $s1, -32($fp)
lw $s1, -32($fp)
li $s3, 1
sub $s1, $s1, $s3
sw $s1, -32($fp)
j label1
label3:
lw $s4, -36($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s4
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t3, -40($fp)
lw $s4, -36($fp)
move $t3, $s4
sw $t3, -40($fp)
label6:
lw $s4, -36($fp)
li $s5, 1222
bge $s4, $s5, label7
j label8
label7:
lw $t3, -40($fp)
lw $s4, -36($fp)
li $s6, 1024
add $t3, $s4, $s6
sw $t3, -40($fp)
lw $s4, -36($fp)
lw $s4, -36($fp)
li $s7, 1
sub $s4, $s4, $s7
sw $s4, -36($fp)
lw $t3, -40($fp)
lw $s4, -36($fp)
move $t3, $s4
sw $t3, -40($fp)
j label6
label8:
lw $s4, -36($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s4
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t5, -4($fp)
lw $t5, -4($fp)
lw $t7, -8($fp)
add $t5, $t5, $t7
sw $t5, -4($fp)
lw $t7, -8($fp)
lw $t5, -4($fp)
lw $t7, -8($fp)
add $t7, $t5, $t7
sw $t7, -8($fp)
lw $t0, -12($fp)
lw $t5, -4($fp)
lw $t7, -8($fp)
add $t0, $t5, $t7
sw $t0, -12($fp)
lw $t0, -12($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t0
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t1, 0
move $v0, $t1
jr $ra
