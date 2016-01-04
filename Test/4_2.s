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

fact:
move $fp, $sp
addi $sp, $sp, -132
lw $t0, 8($fp)
sw $t0, -4($fp)
li $t2, 10
move $t1, $t2
sw $t1, -8($fp)
li $t4, 20
move $t3, $t4
sw $t3, -12($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
bgt $t0, $t1, label1
j label2
label1:
lw $t0, -4($fp)
move $v0, $t0
jr $ra
j label3
label2:
lw $t1, -8($fp)
move $v0, $t1
jr $ra
label3:

main:
move $fp, $sp
addi $sp, $sp, -144
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
move $t0, $v0
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t0, -4($fp)
lw $t0, -4($fp)
li $t1, 1
bgt $t0, $t1, label4
j label5
label4:
lw $t0, -4($fp)
addi $sp, $sp, -4
sw $t0, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal fact
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t2, $v0
addi $sp, $sp, 4
sw $t2, -8($fp)
j label6
label5:
lw $t2, -8($fp)
li $t3, 1
move $t2, $t3
sw $t2, -8($fp)
label6:
lw $t2, -8($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t2
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t4, 0
move $v0, $t4
jr $ra
