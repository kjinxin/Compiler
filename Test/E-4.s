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

min:
move $fp, $sp
addi $sp, $sp, -288
lw $t0, 8($fp)
sw $t0, -4($fp)
lw $t1, 12($fp)
sw $t1, -8($fp)
li $t3, 1
move $t2, $t3
sw $t2, -12($fp)
lw $t5, -8($fp)
move $t4, $t5
sw $t4, -16($fp)
li $t7, 0
move $t6, $t7
sw $t6, -20($fp)
label1:
lw $s0, -12($fp)
lw $s1, -16($fp)
blt $s0, $s1, label2
j label3
label2:
lw $s3, -12($fp)
li $s4, 4
mul $s2, $s3, $s4
sw $s2, -24($fp)
lw $s6, -4($fp)
lw $s7, -24($fp)
add $s5, $s6, $s7
sw $s5, -28($fp)
lw $t1, -20($fp)
li $t2, 4
mul $t0, $t1, $t2
sw $t0, -32($fp)
lw $t4, -4($fp)
lw $t5, -32($fp)
add $t3, $t4, $t5
sw $t3, -36($fp)
lw $t6, -28($fp)
lw $t7, 0($t6)
lw $s0, -36($fp)
lw $s1, 0($s0)
blt $t7, $s1, label4
j label5
label4:
lw $s2, -20($fp)
lw $s3, -12($fp)
move $s2, $s3
sw $s2, -20($fp)
label5:
lw $s4, -12($fp)
lw $s5, -12($fp)
li $s6, 1
add $s4, $s5, $s6
sw $s4, -12($fp)
j label1
label3:
lw $t0, -20($fp)
li $t1, 4
mul $s7, $t0, $t1
sw $s7, -40($fp)
lw $t3, -4($fp)
lw $t4, -40($fp)
add $t2, $t3, $t4
sw $t2, -44($fp)
lw $t5, -44($fp)
lw $t6, 0($t5)
move $v0, $t6
jr $ra

main:
move $fp, $sp
addi $sp, $sp, -288
li $t1, 0
move $t0, $t1
sw $t0, -44($fp)
li $t3, 10
move $t2, $t3
sw $t2, -48($fp)
label6:
lw $t4, -44($fp)
lw $t5, -48($fp)
blt $t4, $t5, label7
j label8
label7:
lw $t7, -44($fp)
lw $s0, -44($fp)
mul $t6, $t7, $s0
sw $t6, -52($fp)
lw $s2, -52($fp)
lw $s3, -44($fp)
mul $s1, $s2, $s3
sw $s1, -56($fp)
addi $s5, $fp, -40
move $s4, $s5
sw $s4, -60($fp)
lw $s7, -44($fp)
li $t0, 4
mul $s6, $s7, $t0
sw $s6, -64($fp)
lw $t2, -60($fp)
lw $t3, -64($fp)
add $t1, $t2, $t3
sw $t1, -68($fp)
lw $t5, -56($fp)
lw $t6, -48($fp)
div $t5, $t6
mflo $t4
sw $t4, -72($fp)
lw $s0, -72($fp)
lw $s1, -48($fp)
mul $t7, $s0, $s1
sw $t7, -76($fp)
lw $s3, -56($fp)
lw $s4, -76($fp)
sub $s2, $s3, $s4
sw $s2, -80($fp)
lw $s5, -68($fp)
lw $s6, -80($fp)
sw $s6, 0($s5)
sw $s5, -68($fp)
lw $s7, -44($fp)
lw $t0, -44($fp)
li $t1, 1
add $s7, $t0, $t1
sw $s7, -44($fp)
j label6
label8:
addi $t3, $fp, -40
move $t2, $t3
sw $t2, -84($fp)
lw $t4, -48($fp)
addi $sp, $sp, -4
sw $t4, 0($sp)
lw $t5, -84($fp)
addi $sp, $sp, -4
sw $t5, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal min
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t6, $v0
addi $sp, $sp, 8
sw $t6, -88($fp)
lw $t7, -88($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t7
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
