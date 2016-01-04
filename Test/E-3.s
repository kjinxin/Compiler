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
addi $sp, $sp, -408
addi $t1, $fp, -16
move $t0, $t1
sw $t0, -20($fp)
lw $t0, -20($fp)
li $t3, 0
add $t2, $t0, $t3
sw $t2, -24($fp)
lw $t2, -24($fp)
li $t5, 0
add $t4, $t2, $t5
sw $t4, -28($fp)
lw $t4, -28($fp)
li $t6, 0
sw $t6, 0($t4)
sw $t4, -28($fp)
addi $s0, $fp, -16
move $t7, $s0
sw $t7, -32($fp)
lw $t7, -32($fp)
li $s2, 0
add $s1, $t7, $s2
sw $s1, -36($fp)
lw $s1, -36($fp)
li $s4, 4
add $s3, $s1, $s4
sw $s3, -40($fp)
lw $s3, -40($fp)
li $s5, 2
sw $s5, 0($s3)
sw $s3, -40($fp)
addi $s7, $fp, -16
move $s6, $s7
sw $s6, -44($fp)
lw $s6, -44($fp)
li $t1, 8
add $t0, $s6, $t1
sw $t0, -48($fp)
lw $t0, -48($fp)
li $t3, 0
add $t2, $t0, $t3
sw $t2, -52($fp)
lw $t2, -52($fp)
li $t4, 2
sw $t4, 0($t2)
sw $t2, -52($fp)
addi $t6, $fp, -16
move $t5, $t6
sw $t5, -56($fp)
lw $t5, -56($fp)
li $s0, 8
add $t7, $t5, $s0
sw $t7, -60($fp)
lw $t7, -60($fp)
li $s2, 4
add $s1, $t7, $s2
sw $s1, -64($fp)
lw $s1, -64($fp)
li $s3, 0
sw $s3, 0($s1)
sw $s1, -64($fp)
addi $s5, $fp, -16
move $s4, $s5
sw $s4, -68($fp)
lw $s4, -68($fp)
li $s7, 0
add $s6, $s4, $s7
sw $s6, -72($fp)
lw $s6, -72($fp)
li $t1, 0
add $t0, $s6, $t1
sw $t0, -76($fp)
addi $t3, $fp, -16
move $t2, $t3
sw $t2, -80($fp)
lw $t2, -80($fp)
li $t5, 0
add $t4, $t2, $t5
sw $t4, -84($fp)
lw $t4, -84($fp)
li $t7, 4
add $t6, $t4, $t7
sw $t6, -88($fp)
lw $t0, -76($fp)
lw $s1, 0($t0)
lw $t6, -88($fp)
lw $s2, 0($t6)
add $s0, $s1, $s2
sw $s0, -92($fp)
addi $s4, $fp, -16
move $s3, $s4
sw $s3, -96($fp)
lw $s3, -96($fp)
li $s6, 8
add $s5, $s3, $s6
sw $s5, -100($fp)
lw $s5, -100($fp)
li $t0, 0
add $s7, $s5, $t0
sw $s7, -104($fp)
lw $s0, -92($fp)
lw $s7, -104($fp)
lw $t2, 0($s7)
sub $t1, $s0, $t2
sw $t1, -108($fp)
addi $t4, $fp, -16
move $t3, $t4
sw $t3, -112($fp)
lw $t3, -112($fp)
li $t6, 8
add $t5, $t3, $t6
sw $t5, -116($fp)
lw $t5, -116($fp)
li $s0, 4
add $t7, $t5, $s0
sw $t7, -120($fp)
lw $t1, -108($fp)
lw $t7, -120($fp)
lw $s2, 0($t7)
sub $s1, $t1, $s2
sw $s1, -124($fp)
lw $s1, -124($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s1
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $s3, 0
move $v0, $s3
jr $ra
