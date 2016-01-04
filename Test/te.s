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
addi $sp, $sp, -96
li $t1, 20
move $t0, $t1
sw $t0, -4($fp)
li $t3, 0
move $t2, $t3
sw $t2, -8($fp)
li $t5, 3
move $t4, $t5
sw $t4, -12($fp)
lw $t0, -4($fp)
lw $t4, -12($fp)
div $t0, $t4
mflo $t6
sw $t6, -16($fp)
lw $t6, -16($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t6
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t4, -12($fp)
lw $t0, -4($fp)
div $t4, $t0
mflo $t7
sw $t7, -20($fp)
lw $t7, -20($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t7
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $s0, 0
move $v0, $s0
jr $ra
