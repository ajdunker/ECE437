org 0x0000

ori $29, $0, 0xfffc				#stack pointer
ori $11, $0, 0x00D2				#num 1
ori $12, $0, 0x0002				#num 2
ori $13, $0, 0x00BA				#num 3
ori $14, $0, 0x0008				#num 4
ori $28, $0, 0xfff8				#point where 1 item is on stack

push $11						#push numbers to stack
push $12
push $13
push $14

multiply_procedure:
	beq $29, $28, done 			#jump to  done if 1 item left on stack
	jal multiply 				#start the multiplication
	j multiply_procedure 		#mutiply th the next number

multiply:	
	pop $2						#grab num1 from stack
	pop $3						#gran num2 from stack
	addu $4, $3, $0				#num 2 in register 3 as index
	ori $5, $0, 0x0000			#total in register 4
	ori $6, $0, 0x0001			#load number 1 to dec

multiply_loop:
	beq $4, $0, multiply_done	#branch if index is 0
	addu $5, $5, $2				#add sum to num 1
	subu $4, $4, $6				#reduce index by 1
	j multiply_loop				#loop

multiply_done:
	push $5						#push answer to stack
	jr $31						#jump return

done:
	pop $10						#pop the answer into a register
	push $10					#put the answer back to the stack

halt							#done
