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
addi $sp, $sp, -564
li $t1, 0
move $t0, $t1
sw $t0, -44($fp)
li $t3, 10
move $t2, $t3
sw $t2, -48($fp)
li $t5, 0
move $t4, $t5
sw $t4, -52($fp)
label1:
lw $t6, -44($fp)
lw $t7, -48($fp)
blt $t6, $t7, label2
j label3
label2:
lw $s1, -44($fp)
li $s2, 1
add $s0, $s1, $s2
sw $s0, -56($fp)
lw $s4, -44($fp)
li $s5, 1
add $s3, $s4, $s5
sw $s3, -60($fp)
lw $s7, -56($fp)
lw $t0, -60($fp)
mul $s6, $s7, $t0
sw $s6, -64($fp)
lw $t2, -44($fp)
li $t3, 1
add $t1, $t2, $t3
sw $t1, -68($fp)
lw $t5, -64($fp)
lw $t6, -68($fp)
mul $t4, $t5, $t6
sw $t4, -72($fp)
addi $s0, $fp, -40
move $t7, $s0
sw $t7, -76($fp)
lw $s2, -44($fp)
li $s3, 4
mul $s1, $s2, $s3
sw $s1, -80($fp)
lw $s5, -76($fp)
lw $s6, -80($fp)
add $s4, $s5, $s6
sw $s4, -84($fp)
lw $t0, -72($fp)
lw $t1, -48($fp)
div $t0, $t1
mflo $s7
sw $s7, -88($fp)
lw $t3, -88($fp)
lw $t4, -48($fp)
mul $t2, $t3, $t4
sw $t2, -92($fp)
lw $t6, -72($fp)
lw $t7, -92($fp)
sub $t5, $t6, $t7
sw $t5, -96($fp)
lw $s0, -84($fp)
lw $s1, -96($fp)
sw $s1, 0($s0)
sw $s0, -84($fp)
lw $s2, -44($fp)
lw $s3, -44($fp)
li $s4, 1
add $s2, $s3, $s4
sw $s2, -44($fp)
j label1
label3:
lw $s5, -44($fp)
li $s6, 1
move $s5, $s6
sw $s5, -44($fp)
label4:
lw $s7, -44($fp)
lw $t0, -48($fp)
blt $s7, $t0, label5
j label6
label5:
addi $t2, $fp, -40
move $t1, $t2
sw $t1, -100($fp)
lw $t4, -44($fp)
li $t5, 4
mul $t3, $t4, $t5
sw $t3, -104($fp)
lw $t7, -100($fp)
lw $s0, -104($fp)
add $t6, $t7, $s0
sw $t6, -108($fp)
addi $s2, $fp, -40
move $s1, $s2
sw $s1, -112($fp)
lw $s4, -52($fp)
li $s5, 4
mul $s3, $s4, $s5
sw $s3, -116($fp)
lw $s7, -112($fp)
lw $t0, -116($fp)
add $s6, $s7, $t0
sw $s6, -120($fp)
lw $t1, -108($fp)
lw $t2, 0($t1)
lw $t3, -120($fp)
lw $t4, 0($t3)
blt $t2, $t4, label7
j label8
label7:
lw $t5, -52($fp)
lw $t6, -44($fp)
move $t5, $t6
sw $t5, -52($fp)
label8:
lw $t7, -44($fp)
lw $s0, -44($fp)
li $s1, 1
add $t7, $s0, $s1
sw $t7, -44($fp)
j label4
label6:
addi $s3, $fp, -40
move $s2, $s3
sw $s2, -124($fp)
lw $s5, -52($fp)
li $s6, 4
mul $s4, $s5, $s6
sw $s4, -128($fp)
lw $t0, -124($fp)
lw $t1, -128($fp)
add $s7, $t0, $t1
sw $s7, -132($fp)
lw $t2, -132($fp)
lw $t3, 0($t2)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t3
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t4, 0
move $v0, $t4
jr $ra
