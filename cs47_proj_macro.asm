.macro extract_nth_bit($regD, $regS, $regT)
	srlv	$regS, $regS, $regT	
	li	$regD, 1		
	and	$regD, $regS, $regD	
.end_macro

.macro extract_0th_bit($regD, $regS)
	li	$regD, 1		
	and	$regD, $regS, $regD	
	srl	$regS, $regS, 1		
.end_macro

.macro insert_to_nth_bit($regD, $regS, $regT, $maskReg)
	move	$maskReg, $regT			
	sllv	$maskReg, $maskReg, $regS	
	or	$regD, $regD, $maskReg		
.end_macro

.macro half_adder($A, $B, $Y, $C)
	xor	$Y, $A, $B	
	and	$C, $A, $B	
.end_macro

.macro full_adder($A, $B, $Y, $AB, $Ci, $Co)
	half_adder($A, $B, $Y, $AB)
	and	$Co, $Ci, $Y	
	xor	$Y, $Ci, $Y	
	xor	$Co, $Co, $AB	
.end_macro

.macro twos_complement($num)
	not	$num, $num
	addi	$num, $num, 1
.end_macro

.macro twos_complement_if_neg($num)
	bgez	$num, tcin_done
	twos_complement($num)
	tcin_done:
.end_macro
