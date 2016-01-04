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
addi $sp, $sp, -120
li $t1, 20
move $t0, $t1
sw $t0, -4($fp)
label1:
lw $t0, -4($fp)
li $t2, 5
bgt $t0, $t2, label2
j label3
label2:
lw $t0, -4($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t0
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, -4($fp)
lw $t0, -4($fp)
li $t3, 1
sub $t0, $t0, $t3
sw $t0, -4($fp)
j label1
label3:
li $t4, 0
move $v0, $t4
jr $ra
