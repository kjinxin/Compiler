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
addi $sp, $sp, -1860
li $t1, 3
move $t0, $t1
sw $t0, -4($fp)
li $t3, 4
move $t2, $t3
sw $t2, -8($fp)
li $t5, 0
move $t4, $t5
sw $t4, -12($fp)
li $t7, 0
move $t6, $t7
sw $t6, -16($fp)
lw $s1, -4($fp)
lw $s2, -4($fp)
mul $s0, $s1, $s2
sw $s0, -620($fp)
lw $s4, -8($fp)
lw $s5, -8($fp)
mul $s3, $s4, $s5
sw $s3, -624($fp)
li $s6, -1
li $s7, 0
bne $s6, $s7, label1
j label3
label3:
lw $t1, -620($fp)
lw $t2, -624($fp)
add $t0, $t1, $t2
sw $t0, -628($fp)
lw $t3, -628($fp)
li $t4, 0
bgt $t3, $t4, label1
j label2
label1:
lw $t6, -4($fp)
lw $t7, -4($fp)
mul $t5, $t6, $t7
sw $t5, -632($fp)
lw $s1, -8($fp)
lw $s2, -8($fp)
mul $s0, $s1, $s2
sw $s0, -636($fp)
lw $s4, -632($fp)
lw $s5, -636($fp)
sub $s3, $s4, $s5
sw $s3, -640($fp)
lw $s7, -620($fp)
lw $t0, -624($fp)
mul $s6, $s7, $t0
sw $s6, -644($fp)
lw $t2, -640($fp)
lw $t3, -644($fp)
add $t1, $t2, $t3
sw $t1, -648($fp)
lw $t5, -4($fp)
li $t6, 8
sub $t4, $t5, $t6
sw $t4, -652($fp)
lw $t7, -12($fp)
lw $s0, -648($fp)
lw $s1, -652($fp)
div $s0, $s1
mflo $t7
sw $t7, -12($fp)
label2:
lw $s3, -4($fp)
li $s4, 3
mul $s2, $s3, $s4
sw $s2, -656($fp)
li $s6, 7
lw $s7, -656($fp)
sub $s5, $s6, $s7
sw $s5, -660($fp)
li $t1, 4
lw $t2, -8($fp)
mul $t0, $t1, $t2
sw $t0, -664($fp)
lw $t4, -660($fp)
lw $t5, -664($fp)
sub $t3, $t4, $t5
sw $t3, -668($fp)
lw $t7, -620($fp)
lw $s0, -624($fp)
mul $t6, $t7, $s0
sw $t6, -672($fp)
lw $s2, -668($fp)
lw $s3, -672($fp)
add $s1, $s2, $s3
sw $s1, -676($fp)
li $s5, 0
lw $s6, -676($fp)
sub $s4, $s5, $s6
sw $s4, -680($fp)
lw $s7, -12($fp)
lw $t0, -680($fp)
lw $t1, -680($fp)
sub $s7, $t0, $t1
sw $s7, -12($fp)
label4:
lw $t2, -12($fp)
li $t3, 150
blt $t2, $t3, label5
j label6
label5:
addi $t5, $fp, -616
move $t4, $t5
sw $t4, -684($fp)
lw $t7, -12($fp)
li $s0, 4
mul $t6, $t7, $s0
sw $t6, -688($fp)
lw $s2, -684($fp)
lw $s3, -688($fp)
add $s1, $s2, $s3
sw $s1, -692($fp)
lw $s4, -692($fp)
li $s5, 1
sw $s5, 0($s4)
sw $s4, -692($fp)
lw $s6, -12($fp)
lw $s7, -12($fp)
li $t0, 1
add $s6, $s7, $t0
sw $s6, -12($fp)
j label4
label6:
addi $t2, $fp, -616
move $t1, $t2
sw $t1, -696($fp)
lw $t4, -696($fp)
li $t5, 0
add $t3, $t4, $t5
sw $t3, -700($fp)
lw $t7, -700($fp)
lw $s0, 0($t7)
lw $s1, -620($fp)
add $t6, $s0, $s1
sw $t6, -704($fp)
lw $s3, -704($fp)
li $s4, 1
sub $s2, $s3, $s4
sw $s2, -708($fp)
lw $s5, -12($fp)
lw $s6, -708($fp)
lw $s7, -620($fp)
sub $s5, $s6, $s7
sw $s5, -12($fp)
lw $t1, -8($fp)
lw $t2, -8($fp)
mul $t0, $t1, $t2
sw $t0, -712($fp)
lw $t4, -680($fp)
lw $t5, -712($fp)
sub $t3, $t4, $t5
sw $t3, -716($fp)
lw $t7, -4($fp)
lw $s0, -4($fp)
mul $t6, $t7, $s0
sw $t6, -720($fp)
lw $s2, -716($fp)
lw $s3, -720($fp)
add $s1, $s2, $s3
sw $s1, -724($fp)
li $s5, 1
lw $s6, -724($fp)
mul $s4, $s5, $s6
sw $s4, -728($fp)
li $t0, 0
lw $t1, -728($fp)
sub $s7, $t0, $t1
sw $s7, -732($fp)
lw $t2, -732($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t2
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t3, -4($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t3
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t4, -8($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t4
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t5, -680($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t5
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t6, -620($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t6
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label7:
lw $s0, -8($fp)
lw $s1, -8($fp)
mul $t7, $s0, $s1
sw $t7, -736($fp)
lw $s3, -680($fp)
lw $s4, -736($fp)
sub $s2, $s3, $s4
sw $s2, -740($fp)
lw $s6, -4($fp)
lw $s7, -4($fp)
mul $s5, $s6, $s7
sw $s5, -744($fp)
lw $t1, -740($fp)
lw $t2, -744($fp)
add $t0, $t1, $t2
sw $t0, -748($fp)
li $t4, 1
lw $t5, -748($fp)
mul $t3, $t4, $t5
sw $t3, -752($fp)
li $t7, 0
lw $s0, -752($fp)
sub $t6, $t7, $s0
sw $t6, -756($fp)
lw $s1, -12($fp)
lw $s2, -756($fp)
blt $s1, $s2, label8
j label9
label8:
lw $s4, -4($fp)
li $s5, 4
add $s3, $s4, $s5
sw $s3, -760($fp)
lw $s7, -760($fp)
lw $t0, -8($fp)
sub $s6, $s7, $t0
sw $s6, -764($fp)
lw $t2, -620($fp)
move $t1, $t2
sw $t1, -768($fp)
lw $t4, -764($fp)
li $t5, 1
sub $t3, $t4, $t5
sw $t3, -772($fp)
lw $t6, -764($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t6
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label10:
lw $s0, -4($fp)
lw $s1, -8($fp)
add $t7, $s0, $s1
sw $t7, -776($fp)
lw $s3, -776($fp)
li $s4, 10
sub $s2, $s3, $s4
sw $s2, -780($fp)
lw $s6, -780($fp)
li $s7, 3
add $s5, $s6, $s7
sw $s5, -784($fp)
lw $t0, -768($fp)
lw $t1, -784($fp)
bgt $t0, $t1, label11
j label12
label11:
li $t3, 0
move $t2, $t3
sw $t2, -788($fp)
addi $t5, $fp, -616
move $t4, $t5
sw $t4, -792($fp)
lw $t7, -12($fp)
li $s0, 10
div $t7, $s0
mflo $t6
sw $t6, -796($fp)
lw $s2, -796($fp)
li $s3, 4
mul $s1, $s2, $s3
sw $s1, -800($fp)
lw $s5, -792($fp)
lw $s6, -800($fp)
add $s4, $s5, $s6
sw $s4, -804($fp)
addi $t0, $fp, -616
move $s7, $t0
sw $s7, -808($fp)
lw $t2, -12($fp)
li $t3, 10
div $t2, $t3
mflo $t1
sw $t1, -812($fp)
lw $t5, -812($fp)
li $t6, 4
mul $t4, $t5, $t6
sw $t4, -816($fp)
lw $s0, -808($fp)
lw $s1, -816($fp)
add $t7, $s0, $s1
sw $t7, -820($fp)
lw $s3, -768($fp)
li $s4, 3
mul $s2, $s3, $s4
sw $s2, -824($fp)
lw $s6, -820($fp)
lw $s7, 0($s6)
lw $t0, -824($fp)
add $s5, $s7, $t0
sw $s5, -828($fp)
lw $t1, -804($fp)
lw $t2, -828($fp)
sw $t2, 0($t1)
sw $t1, -804($fp)
lw $t3, -772($fp)
li $t4, 2
beq $t3, $t4, label13
j label14
label13:
addi $t6, $fp, -616
move $t5, $t6
sw $t5, -832($fp)
lw $s0, -12($fp)
li $s1, 10
div $s0, $s1
mflo $t7
sw $t7, -836($fp)
lw $s3, -836($fp)
li $s4, 4
mul $s2, $s3, $s4
sw $s2, -840($fp)
lw $s6, -832($fp)
lw $s7, -840($fp)
add $s5, $s6, $s7
sw $s5, -844($fp)
addi $t1, $fp, -616
move $t0, $t1
sw $t0, -848($fp)
lw $t3, -12($fp)
li $t4, 10
div $t3, $t4
mflo $t2
sw $t2, -852($fp)
lw $t6, -852($fp)
li $t7, 4
mul $t5, $t6, $t7
sw $t5, -856($fp)
lw $s1, -848($fp)
lw $s2, -856($fp)
add $s0, $s1, $s2
sw $s0, -860($fp)
lw $s4, -768($fp)
li $s5, 3
mul $s3, $s4, $s5
sw $s3, -864($fp)
li $s7, 2
lw $t0, -864($fp)
add $s6, $s7, $t0
sw $s6, -868($fp)
lw $t2, -860($fp)
lw $t3, 0($t2)
lw $t4, -868($fp)
sub $t1, $t3, $t4
sw $t1, -872($fp)
lw $t5, -844($fp)
lw $t6, -872($fp)
sw $t6, 0($t5)
sw $t5, -844($fp)
label14:
lw $t7, -12($fp)
li $s0, 100
bgt $t7, $s0, label15
j label16
label15:
lw $s2, -768($fp)
li $s3, 2
div $s2, $s3
mflo $s1
sw $s1, -876($fp)
lw $s4, -788($fp)
lw $s5, -876($fp)
li $s6, 1
sub $s4, $s5, $s6
sw $s4, -788($fp)
j label17
label16:
addi $t0, $fp, -616
move $s7, $t0
sw $s7, -880($fp)
lw $t2, -12($fp)
li $t3, 10
div $t2, $t3
mflo $t1
sw $t1, -884($fp)
lw $t5, -884($fp)
li $t6, 4
mul $t4, $t5, $t6
sw $t4, -888($fp)
lw $s0, -880($fp)
lw $s1, -888($fp)
add $t7, $s0, $s1
sw $t7, -892($fp)
addi $s3, $fp, -616
move $s2, $s3
sw $s2, -896($fp)
lw $s5, -12($fp)
li $s6, 10
div $s5, $s6
mflo $s4
sw $s4, -900($fp)
lw $t0, -900($fp)
li $t1, 4
mul $s7, $t0, $t1
sw $s7, -904($fp)
lw $t3, -896($fp)
lw $t4, -904($fp)
add $t2, $t3, $t4
sw $t2, -908($fp)
lw $t6, -908($fp)
lw $t7, 0($t6)
lw $s0, -768($fp)
add $t5, $t7, $s0
sw $t5, -912($fp)
lw $s1, -892($fp)
lw $s2, -912($fp)
sw $s2, 0($s1)
sw $s1, -892($fp)
label17:
lw $s3, -788($fp)
lw $s4, -788($fp)
li $s5, 1
sub $s3, $s4, $s5
sw $s3, -788($fp)
lw $s7, -768($fp)
li $t0, 2
div $s7, $t0
mflo $s6
sw $s6, -916($fp)
lw $t1, -768($fp)
lw $t2, -916($fp)
li $t3, 1
sub $t1, $t2, $t3
sw $t1, -768($fp)
j label10
label12:
lw $t5, -8($fp)
lw $t6, -16($fp)
add $t4, $t5, $t6
sw $t4, -920($fp)
lw $t7, -920($fp)
lw $s0, -620($fp)
blt $t7, $s0, label18
j label20
label20:
lw $s1, -624($fp)
li $s2, 0
bne $s1, $s2, label18
j label19
label18:
lw $s3, -12($fp)
lw $s4, -12($fp)
li $s5, 1
add $s3, $s4, $s5
sw $s3, -12($fp)
label19:
j label7
label9:
lw $s6, -12($fp)
li $s7, 0
move $s6, $s7
sw $s6, -12($fp)
label21:
lw $t0, -12($fp)
li $t1, 150
blt $t0, $t1, label22
j label23
label22:
addi $t3, $fp, -616
move $t2, $t3
sw $t2, -924($fp)
lw $t5, -12($fp)
li $t6, 4
mul $t4, $t5, $t6
sw $t4, -928($fp)
lw $s0, -924($fp)
lw $s1, -928($fp)
add $t7, $s0, $s1
sw $t7, -932($fp)
lw $s2, -16($fp)
lw $s3, -16($fp)
lw $s4, -932($fp)
lw $s5, 0($s4)
add $s2, $s3, $s5
sw $s2, -16($fp)
lw $s6, -12($fp)
lw $s7, -12($fp)
li $t0, 1
add $s6, $s7, $t0
sw $s6, -12($fp)
j label21
label23:
lw $t1, -16($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
move $a0, $t1
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t2, 0
move $v0, $t2
jr $ra
