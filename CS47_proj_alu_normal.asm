.include "./cs47_proj_macro.asm"
.text
.globl au_normal

au_normal:
	addi 	$sp, $sp, -24
	sw	$fp, 24($sp)
	sw	$ra, 20($sp)
	sw	$a0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a2, 8($sp)
	addi	$fp, $sp 24
	
	li	$t0, 43		
	li	$t1, 45		
	li	$t2, 42		
	li	$t3, 47		

	beq	$a2, $t0, addition
	beq	$a2, $t1, subtraction
	beq	$a2, $t2, multiplication
	beq	$a2, $t3, division
	j	end_function	
	
	addition:
	add	$v0, $a0, $a1
	j	end_function
	
	subtraction:
	sub	$v0, $a0, $a1
	j	end_function
	
	multiplication:
	mult	$a0, $a1
	mflo	$v0
	mfhi	$v1
	j	end_function
	
	division:
	div	$a0, $a1
	mflo	$v0
	mfhi	$v1
	j	end_function
	
	end_function:
	lw	$fp, 24($sp)
	lw	$ra, 20($sp)
	lw	$a0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a2, 8($sp)
	addi	$sp, $sp, 24

	jr	$ra