org 0x0000

ori $29, $0, 0xfffc			#initialize stack
ori $11, $0, 0x0002			#num 1
ori $12, $0, 0x0003			#num 2

push $11					#push num1 to stack
push $12					#push num2 to stack

multiply:
	pop $2					#grab num1 from stack
	pop $3					#gran num2 from stack
	addu $4, $3, $0			#num 2 in register 4 as index
	ori $5, $0, 0x0000		#total in register 5
	ori $6, $0, 0x0001		#load number 1 to dec

multiply_loop:
	beq $4, $0, done		#branch if index is 0
	addu $5, $5, $2			#add sum to num 1
	subu $4, $4, $6			#reduce index by 1
	j multiply_loop			#loop

done:
	push $5					#push answer to stack

halt						#done
