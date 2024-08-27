.include "./cs47_common_macro.asm"
.text
.globl printf

printf:
	addi	$sp, $sp, -24
	sw	$fp, 24($sp)
	sw	$ra, 20($sp)
	sw	$a0, 16($sp)
	sw	$s0, 12($sp)
	sw	$s1,  8($sp)
	addi	$fp, $sp, 24

	move 	$s0, $a0 
	add     $s1, $zero, $zero 
printf_loop:
	lbu	$a0, 0($s0)
	beqz	$a0, printf_ret
	beq     $a0, '%', printf_format

	li	$v0, 11
	syscall
	j 	printf_last
printf_format:
	addi	$s1, $s1, 1 
	mul	$t0, $s1, 4
	add	$t0, $t0, $fp 
	
	addi	$s0, $s0, 1
	lbu	$a0, 0($s0)
	beq 	$a0, 'd', printf_int
	beq	$a0, 's', printf_str
	beq	$a0, 'c', printf_char
printf_int: 
	lw	$a0, 0($t0) 
	li	$v0, 1
	syscall
	j 	printf_last
printf_str:
	lw	$a0, 0($t0) 
	li	$v0, 4
	syscall
	j 	printf_last
printf_char:
	lbu	$a0, 0($t0)
	li	$v0, 11
	syscall
	j 	printf_last
printf_last:
	addi	$s0, $s0, 1 
	j	printf_loop
printf_ret:

	lw	$fp, 24($sp)
	lw	$ra, 20($sp)
	lw	$a0, 16($sp)
	lw	$s0, 12($sp)
	lw	$s1,  8($sp)
	addi	$sp, $sp, 24
	jr $ra

