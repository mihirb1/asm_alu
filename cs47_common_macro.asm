# ***** DO NOT MODIFY THIS FILE **** #
        .macro print_str($arg)
	li	$v0, 4    
	la	$a0, $arg   
	syscall                    
	.end_macro
	
        .macro print_int($arg)
	li 	$v0, 1     
	li	$a0, $arg  
	syscall            
	.end_macro
	
        .macro exit
	li 	$v0, 10 
	syscall
	.end_macro
	
	.macro read_int($arg)
	li	$v0,5	
	syscall
	move	$arg, $v0 
	.end_macro
	
	.macro print_reg_int ($arg)
	li	$v0, 1		
	move	$a0, $arg 	
	syscall
	.end_macro
	
	.macro lwi ($reg, $ui, $li)
	lui $reg, $ui
	ori $reg, $reg, $li
	.end_macro
	
	.macro push($reg)
	sw	$reg, 0x0($sp)
	addi    $sp, $sp, -4	
	.end_macro
	
	.macro pop($reg)
	addi    $sp, $sp, +4	
	lw	$reg, 0x0($sp)	
	.end_macro

	.macro push_var_value($varName)
	lw	$t0, $varName
	push($t0)
	.end_macro
	
	.macro push_var_address($varName)
	la	$t0, $varName
	push($t0)
	.end_macro

	.macro call_printf($format)
	la	$a0, $format
	jal	printf
	.end_macro
