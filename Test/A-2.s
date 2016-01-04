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
addi $sp, $sp, -144
li $t1, 0
move $t0, $t1
sw $t0, -4($fp)
li $t3, 1
move $t2, $t3
sw $t2, -8($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
move $t4, $v0
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t4, -12($fp)
lw $t4, -12($fp)
li $t5, 5
blt $t4, $t5, label1
j label2
label1:
lw $t0, -4($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t0
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
j label3
label2:
lw $t2, -8($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t2
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label3:
li $t6, 0
move $v0, $t6
jr $ra
