.include "./cs47_proj_macro.asm"

.data
	message1: .asciiz " _______________________\n"
	newLine: .asciiz "\n"

.text
.globl au_logical

au_logical:
	addi 	$sp, $sp, -40
	sw	$fp, 40($sp)
	sw	$ra, 36($sp)
	sw	$s0, 32($sp)
	sw	$s1, 28($sp)
	sw	$s2, 24($sp)
	sw	$s3, 20($sp)
	sw	$a0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a2, 8($sp)
	addi	$fp, $sp 40


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
	jal	add_logical
	j	end_function

	subtraction:
	jal	sub_logical
	j	end_function

	multiplication:
	jal	mul_signed
	j	end_function

	division:
	jal	div_signed
	j	end_function

	end_function:
	lw	$fp, 40($sp)
	lw	$ra, 36($sp)
	lw	$s0, 32($sp)
	lw	$s1, 28($sp)
	lw	$s2, 24($sp)
	lw	$s3, 20($sp)
	lw	$a0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a2, 8($sp)
	add 	$sp, $sp, 40

	jr 	$ra

add_logical:
	addi	$sp, $sp, -24
	sw	$s0, 24($sp)
	sw	$a1, 20($sp)
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp 24

	li	$t0, 0		
	li	$t1, 0		
	li	$t2, 0		
	li	$t4, 0		
	li	$t5, 0		
	li	$t6, 0		
	add	$s0, $zero, $zero
	addLoop:
	beq	$t2, 32, end_addLoop
	extract_0th_bit($t0, $a0)	
	extract_0th_bit($t1, $a1)	
	full_adder($t0, $t1, $t5, $t4, $t6, $t8) 
	insert_to_nth_bit($s0, $t2, $t5, $t6) 	
	move	$t6, $t8 	
	addi	$t2, $t2, 1	
	j	addLoop

	end_addLoop:
	move	$v0, $s0	
	move	$v1, $t8	

	lw	$s0, 24($sp)
	lw	$a1, 20($sp)
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	add	$sp, $sp, 24
	jr	$ra

sub_logical:
	addi	$sp, $sp, -20
	sw	$a1, 20($sp)
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp 20

	neg	$a1, $a1	# negate $a1
	jal	add_logical

	lw	$a1, 20($sp)
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	add	$sp, $sp, 20
	jr	$ra

mul_unsigned:
	addi	$sp, $sp, -48
	sw	$s6, 48($sp)
	sw	$a1, 44($sp)
	sw	$a0, 40($sp)
	sw	$s5, 36($sp)
	sw	$s4, 32($sp)
	sw	$s3, 28($sp)
	sw	$s2, 24($sp)
	sw	$s1, 20($sp)
	sw	$s0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi $fp, $sp, 48

	move	$s6, $a1 
	li	$s0, 0 
	li	$s1, 0
	li	$s2, 0 
	jal	twos_complement_if_neg	
	move	$s3, $v0
	move	$a0, $s6
	jal	twos_complement_if_neg	
	move	$s5, $v0 
	stop_s5:
	li	$s4, 0  

	unsign_mul_loop:
	beq	$s4, 32, end_unsign_mul_loop
	beqz	$s5, end_unsign_mul_loop	
	
	extract_0th_bit($t0, $s5)
	beqz	$t0, shift_MCND_by_1
	
	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $s2
	move	$a3, $s3
	jal	bit64_adder
	move	$s0, $v0
	move	$s1, $v1
	shift_MCND_by_1:

	move	$a0, $s2
	move	$a1, $s3
	jal	MCND_64bit_shift_left_by_1
	move	$s2, $v0
	move	$s3, $v1

	addi	$s4, $s4, 1
	j	unsign_mul_loop

	end_unsign_mul_loop:
	move	$v0, $s1
	move	$v1, $s0

	lw	$s6, 48($sp)
	lw	$a1, 44($sp)
	lw	$a0, 40($sp)
	lw	$s5, 36($sp)
	lw	$s4, 32($sp)
	lw	$s3, 28($sp)
	lw	$s2, 24($sp)
	lw	$s1, 20($sp)
	lw	$s0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi 	$sp, $sp, 48
	jr	$ra

mul_signed:
	addi	$sp, $sp, -32
	sw	$s6, 32($sp)
	sw	$a1, 28($sp)
	sw	$a0, 24($sp)
	sw	$s1, 20($sp)
	sw	$s0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi 	$fp, $sp, 32

	move	$t1, $a0
	move	$t2, $a1
	li	$t3, 31
	extract_nth_bit($t0, $t1, $t3)
	extract_nth_bit($t4, $t2, $t3)
	
	xor	$s6, $t0, $t4	
	jal	mul_unsigned
	move	$s0, $v0	
	move	$s1, $v1	

	beqz	$s6, end_mul_signed
	move	$a0, $s0
	move	$a1, $s1
	jal	twos_complement_64bit
	move	$s0, $v0
	move	$s1, $v1

	end_mul_signed:
	move	$v0, $s0
	move	$v1, $s1

	lw	$s6, 32($sp)
	lw	$a1, 28($sp)
	lw	$a0, 24($sp)
	lw	$s1, 20($sp)
	lw	$s0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi 	$sp, $sp, 32
	jr	$ra

div_unsigned:

	addi	$sp, $sp, -40
	sw	$s4, 40($sp)
	sw	$s3, 36($sp)
	sw	$s2, 32($sp)
	sw	$s1, 28($sp)
	sw	$s0, 24($sp)
	sw	$a1, 20($sp)
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp, 40

	move	$s1, $a1	
	jal	twos_complement_if_neg
	move	$s0, $v0	
	move	$a0, $s1
	jal	twos_complement_if_neg
	move	$s1, $v0	
	li	$s2, 0		
	li	$s3, 0		
	li	$s4, 0		
	
	move	$s2, $s0

	division_loop:
	beq	$s4, 32, end_division
	sll	$s3, $s3, 1	
	li	$t1, 31		
	move	$t2, $s2	

	extract_nth_bit($t0, $t2, $t1)
	insert_to_nth_bit($s3, $zero, $t0, $t3)
	sll	$s2, $s2, 1	
	
	move	$a0, $s3
	move	$a1, $s1
	jal	sub_logical
	move	$t3, $v0

	bltz	$t3, not_large_enough

	move	$s3, $t3

	li	$t0, 1		
	insert_to_nth_bit($s2, $zero, $t0, $t2)

	not_large_enough:
	addi	$s4, $s4, 1
	j	division_loop

	end_division:
	move	$v0, $s2 	
	move	$v1, $s3	

	lw	$s4, 40($sp)
	lw	$s3, 36($sp)
	lw	$s2, 32($sp)
	lw	$s1, 28($sp)
	lw	$s0, 24($sp)
	lw	$a1, 20($sp)
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 40
	jr	$ra

div_signed:
	addi	$sp, $sp, -40
	sw	$s4, 40($sp)
	sw	$s3, 36($sp)
	sw	$s2, 32($sp)
	sw	$s1, 28($sp)
	sw	$s0, 24($sp)
	sw	$a1, 20($sp)
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp, 40

	move	$t1, $a0
	move	$t2, $a1
	li	$t3, 31
	extract_nth_bit($s3, $t1, $t3)
	extract_nth_bit($s4, $t2, $t3)
	
	xor	$s0, $s3, $s4	

	jal	div_unsigned
	move	$s1, $v0	
	move	$s2, $v1	

	beqz	$s0, check_remainder_sign
	move	$a0, $s1
	jal	twos_complement
	move	$s1, $v0	

	check_remainder_sign:
	beqz	$s3, end_div_signed
	move	$a0, $s2
	jal	twos_complement
	move	$s2, $v0	

	end_div_signed:
	move	$v0, $s1 	
	move	$v1, $s2	

	lw	$s4, 40($sp)
	lw	$s3, 36($sp)
	lw	$s2, 32($sp)
	lw	$s1, 28($sp)
	lw	$s0, 24($sp)
	lw	$a1, 20($sp)
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 40
	jr	$ra

twos_complement:
	addi	$sp, $sp, -16
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp 16

	not	$a0, $a0
	li	$a1, 1
	jal	add_logical

	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp 16
	jr	$ra

twos_complement_if_neg:
	addi	$sp, $sp, -16
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp 16

	li	$t1, 31
	move	$t2, $a0
	extract_nth_bit($t0, $t2, $t1)
	beqz	$t0, positive
	jal	twos_complement
	stop_v0:
	j	tcin_done

	positive:
	move	$v0, $a0

	tcin_done:
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp 16
	jr	$ra

twos_complement_64bit:
	addi	$sp, $sp, -28
	sw	$s1, 28($sp)
	sw	$s0, 24($sp)
	sw	$a1, 20($sp)
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp 28

	not	$a0, $a0	
	not	$a1, $a1	
	move	$s0, $a1	
	li	$a1, 1
	jal	add_logical
first_add:
	move	$a0, $v1	
	move	$a1, $s0	
	move	$s1, $v0	
	jal	add_logical
second_add:
	move	$v1, $v0	
	move	$v0, $s1

	lw	$s1, 28($sp)
	lw	$s0, 24($sp)
	lw	$a1, 20($sp)
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 28
	jr	$ra

bit_replicator:
	addi	$sp, $sp -16
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp, 16

	extract_0th_bit($t0, $a0)
	beqz	$t0, end_br 	

	srl	$t0, $t0, 1	
	move	$a0, $t0	
	jal	twos_complement 

	end_br:
	move	$v0, $t0

	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 16
	jr	$ra

bit64_adder:
	addi	$sp, $sp, -36
	sw	$s5, 36($sp)
	sw	$s4, 32($sp)
	sw	$s3, 28($sp)
	sw	$s2, 24($sp)
	sw	$s1, 20($sp)
	sw	$s0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp, 36

	move	$s0, $a0	
	move	$s1, $a1	
	move	$s2, $a2	
	move	$s3, $a3	

	move	$a0, $s2
	move	$a1, $s0
	jal	add_logical
	move	$s2, $v0	
	move	$t0, $v1	
	move 	$a0, $s3
	move	$a1, $t0
	jal	add_logical
	move	$s3, $v0	
	
	move 	$a0, $s3
	move	$a1, $s1
	jal	add_logical
	move	$s3, $v0	

	move	$v0, $s2
	move	$v1, $s3

	lw	$s5, 36($sp)
	lw	$s4, 32($sp)
	lw	$s3, 28($sp)
	lw	$s2, 24($sp)
	lw	$s1, 20($sp)
	lw	$s0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 36
	jr 	$ra

MCND_64bit_shift_left_by_1:
	addi	$sp, $sp, -24
	sw	$s0, 24($sp)
	sw	$a1, 20($sp) 
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp, 24

	move	$s0, $a1
	li	$t1, 31	
	extract_nth_bit($t0, $s0, $t1)
	sll	$a0, $a0, 1 
	
	insert_to_nth_bit($a0, $zero, $t0, $t1)
	sll	$a1, $a1, 1 
	move	$v0, $a0
	move	$v1, $a1

	lw	$s0, 24($sp)
	lw	$a1, 20($sp) 
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 24
	jr	$ra

