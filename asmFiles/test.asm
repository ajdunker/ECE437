org 0x0000

ori $29, $0, 0xfffc			#initialize stack
ori $11, $0, 0x00BC			#num 1
ori $12, $0, 0x0014			#num 2

push $11					#push num1 to stack
push $12					#push num2 to stack

pop $2
pop $3


ori $15, $0, 0x800
ori $16, $0, 0x804
sw $2, 0($15)
sw $3, 0($16)

halt
