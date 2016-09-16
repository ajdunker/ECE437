org 0x0000

ori $29, $0, 0xfffc					#stack pointer
ori $11, $0, 0x0008					#month august
ori $12, $0, 0x0013					#day 19
ori $13, $0, 0x07E0					#year 2016
ori $28, $0, 0xfff8					#point where 1 item is on stack

calculate:
	addu $10, $12, $0				#add days to the sum
	ori $7, $0, 0x0001				#load 1
	subu $11, $11, $7				#subtract 1 from month
	ori $7, $0, 0x001E				#load 30
	push $7							#push 30 to stack
	push $11						#push month calc to stack
	jal multiply					#multiply stack
	pop $11							#pop off the answer
	addu $10, $10, $11				#added multiplied months to total

	ori $7, $0, 0x07D0				#load 2000
	subu $13, $13, $7				#subtract 2000 from year
	ori $7, $0, 0x016D				#load 365
	push $7							#push 365 to stack
	push $13						#push year calc to stack
	jal multiply 					#jump to multiply
	pop $13							#pop answer of stack
	addu $10, $10, $13				#add to total
	j done 							#jump to done

multiply:	
	pop $2							#grab num1 from stack
	pop $3							#gran num2 from stack
	addu $4, $3, $0					#num 2 in register 4 as index
	ori $5, $0, 0x0000				#total in register 5
	ori $6, $0, 0x0001				#load 1 to dec

multiply_loop:
	beq $4, $0, multiply_done		#branch if index is 0
	addu $5, $5, $2					#add sum to num 1
	subu $4, $4, $6					#reduce index by 1
	j multiply_loop					#loop

multiply_done:
	push $5							#push answer to stack
	jr $31					

done:
	push $10						#push answer to stack

halt								#done
