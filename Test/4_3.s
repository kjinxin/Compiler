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

func:
move $fp, $sp
addi $sp, $sp, -120
lw $t0, 8($fp)
sw $t0, -4($fp)
lw $t1, 12($fp)
sw $t1, -8($fp)
lw $t2, 16($fp)
sw $t2, -12($fp)
lw $t3, 20($fp)
sw $t3, -16($fp)
lw $t4, 24($fp)
sw $t4, -20($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
add $t5, $t0, $t1
sw $t5, -24($fp)
lw $t5, -24($fp)
lw $t2, -12($fp)
add $t6, $t5, $t2
sw $t6, -28($fp)
lw $t6, -28($fp)
lw $t3, -16($fp)
add $t7, $t6, $t3
sw $t7, -32($fp)
lw $t7, -32($fp)
lw $t4, -20($fp)
add $s0, $t7, $t4
sw $s0, -36($fp)
lw $s0, -36($fp)
move $v0, $s0
jr $ra

main:
move $fp, $sp
addi $sp, $sp, -300
li $t1, 0
move $t0, $t1
sw $t0, -4($fp)
li $t3, 1
move $t2, $t3
sw $t2, -8($fp)
li $t5, 2
move $t4, $t5
sw $t4, -12($fp)
li $t7, 3
move $t6, $t7
sw $t6, -16($fp)
li $s1, 4
move $s0, $s1
sw $s0, -20($fp)
addi $s3, $fp, -60
move $s2, $s3
sw $s2, -64($fp)
lw $s2, -64($fp)
li $s5, 20
add $s4, $s2, $s5
sw $s4, -68($fp)
lw $s4, -68($fp)
li $s6, 5
sw $s6, 0($s4)
sw $s4, -68($fp)
addi $t0, $fp, -60
move $s7, $t0
sw $s7, -72($fp)
lw $s7, -72($fp)
li $t2, 12
add $t1, $s7, $t2
sw $t1, -76($fp)
lw $s0, -20($fp)
addi $sp, $sp, -4
sw $s0, 0($sp)
lw $t6, -16($fp)
addi $sp, $sp, -4
sw $t6, 0($sp)
lw $t4, -12($fp)
addi $sp, $sp, -4
sw $t4, 0($sp)
lw $t3, -8($fp)
addi $sp, $sp, -4
sw $t3, 0($sp)
lw $t4, -4($fp)
addi $sp, $sp, -4
sw $t4, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal func
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t5, $v0
addi $sp, $sp, 20
sw $t5, -80($fp)
lw $t1, -76($fp)
lw $t5, -80($fp)
sw $t5, 0($t1)
sw $t1, -76($fp)
addi $t7, $fp, -60
move $t6, $t7
sw $t6, -84($fp)
lw $t6, -84($fp)
li $s1, 12
add $s0, $t6, $s1
sw $s0, -88($fp)
lw $s0, -88($fp)
lw $s2, 0($s0)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s2
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t4, -4($fp)
lw $t3, -8($fp)
add $s3, $t4, $t3
sw $s3, -92($fp)
lw $s3, -92($fp)
lw $s5, -12($fp)
add $s4, $s3, $s5
sw $s4, -96($fp)
lw $s4, -96($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s4
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $s6, 0
move $v0, $s6
jr $ra
