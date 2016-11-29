# palgorithm.asm
# Alex Dunker
# ECE 437


	org 	0x0000
	ori		$sp, $zero, 0x3ffc
	jal 	mainp0
	halt

lock:
aquire:
	ll		$t0, 0($a0)
	bne

mainp0:
	push $ra