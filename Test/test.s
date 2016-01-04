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
addi $sp, $sp, -192
li $t1, 0
move $t0, $t1
sw $t0, -4($fp)
li $t3, 1
move $t2, $t3
sw $t2, -8($fp)
li $t5, 0
move $t4, $t5
sw $t4, -12($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
move $t6, $v0
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t6, -16($fp)
label1:
lw $t7, -12($fp)
lw $s0, -16($fp)
blt $t7, $s0, label2
j label3
label2:
lw $s2, -4($fp)
lw $s3, -8($fp)
add $s1, $s2, $s3
sw $s1, -20($fp)
lw $s4, -8($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $s4
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s5, -4($fp)
lw $s6, -8($fp)
move $s5, $s6
sw $s5, -4($fp)
lw $s7, -8($fp)
lw $t0, -20($fp)
move $s7, $t0
sw $s7, -8($fp)
lw $t1, -12($fp)
lw $t2, -12($fp)
li $t3, 1
add $t1, $t2, $t3
sw $t1, -12($fp)
j label1
label3:
li $t4, 0
move $v0, $t4
jr $ra
