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

inc:
move $fp, $sp
addi $sp, $sp, -36
lw $t0, 8($fp)
sw $t0, -4($fp)
lw $t0, -4($fp)
li $t2, 1
add $t1, $t0, $t2
sw $t1, -8($fp)
lw $t1, -8($fp)
move $v0, $t1
jr $ra

main:
move $fp, $sp
addi $sp, $sp, -60
li $t1, 10
move $t0, $t1
sw $t0, -4($fp)
lw $t0, -4($fp)
addi $sp, $sp, -4
sw $t0, 0($sp)
addi $sp, $sp, -8
sw $fp, 0($sp)
sw $ra, 4($sp)
jal inc
lw $t0, -4($fp)
move $sp, $fp
lw $fp, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t0, $v0
addi $sp, $sp, 4
sw $t0, -4($fp)
lw $t0, -4($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t0
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t2, 0
move $v0, $t2
jr $ra
