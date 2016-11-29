# palgorithm.asm
# Alex Dunker
# ECE 437

#*****************************************************************************#
#									P0										  #
#*****************************************************************************#

	org 	0x000 				# first processor
	ori		$s0, $0, 0			# values to generate
	ori 	$s1, $0, 0			# the bufferhead
	ori		$s2, $0, 0			# buffer size
	ori		$s3, $0, 10			# max buffer size
	ori		$s4, $0, 0			# value
	ori		$s5, $0, 0xbabe		# seed
	ori		$s6, $0, 40			# buffer head
	ori		$s7, $0, 256

producer:
	lw		$s2, buffSZ($0)		# load size
	beq		$s2, $s3, producer  # at max size, do nothing
	beq		$s4, $s7, finish_p0	# finish processor 0 if 256 have been generated
	ori 	$a0, $0, l4			# move lock to argument register
	jal 	lock				# try to acquire lock
	lw 		$s2, buffSZ($0)		# load size
	addiu	$s2, $s2, 1			# increment
	sw		$s2, buffSZ($0)		# store increment
	ori		$a0, $s5, 0			# set seed
	jal 	crc32				# generate random Numerator
	addiu	$t0, $s1, buffer 	# buffer head location
	sw		$v0, 0($t0)			# store on ring buffer 
	ori		$s5, $v0, 0x0000	# update seed
	addiu	$s1, $s1, 0x0004	# increment the head
	jal		head_reset
	ori 	$a0, $0, l4
	jal 	unlock				# release lock 
	ori 	$t0, $0, 256		# max to generate
	addiu 	$s4, $s4, 1			# increment
	ori 	$t2, $0, 256
	beq 	$s4, $t0, finish_p0 # finish
	j 		producer

head_reset:
	beq		$s1, $s6, head_reset2
	jr 		$ra 				# return to caller

head_reset2:
	ori		$s1, $0, 0
	jr		$ra 				# return to caller

finish_p0:
	ori		$t5, $0, 256
	sw		$t5, fin($0)
	halt 						#complete

#*****************************************************************************#
#									P1										  #
#*****************************************************************************#

	org		0x200 				#second processor
	ori 	$s2, $0, 40
	ori		$s3, $0, 1
	ori		$s4, $0, 0			# buffer tail
	ori		$s5, $0, 0xFFFF		# min
	ori		$s6, $0, 0x0000		# max
	ori 	$s7, $0, 0x0000		# sum

consumer:
	lw		$t3, buffSZ($0)
	beq		$t3, $0, p1_check
	ori 	$a0, $0, l4
	jal		lock				# try to acquire lock
	lw 		$t3, buffSZ($0)		# empty do nothing
	ori		$t0, $0, 1			
	subu 	$t3, $t3, $t0		# decrease size
	sw		$t3, buffSZ($0) 	# store value
	addiu	$t4, $s4, buffer 	# tail location
	lw 		$t1, 0($t4) 		# load val from tail
	ori 	$a1, $t1, 0			# cur val 
	andi 	$a1, $a1, 0xFFFF 
	addiu 	$s4, $s4, 4			# increment the tail
	jal		tail_reset 
	ori 	$a0, $s5, 0			# setup argument
	jal		min 				# get the minimum
	ori 	$s5, $v0, 0			# put the sum in the register
	ori 	$a0, $s6, 0			# setup argument
	jal		max 				# get the max
	ori 	$s6, $v0, 0			# pull the returned result
	addu 	$s7, $s7, $a1 		# sum
	ori 	$a0, $0, l4			# move lock to argumetn
	jal		unlock				# release the lock

	j 		consumer			# DO IT ALL AGAIN

finish_p1:
	sw 		$s5, v_min($0)		# min value
	sw		$s6, v_max($0)		# max value

	srl 	$s7, $s7, 4
	srl 	$s7, $s7, 4			# user lower 16 bits
	sw 		$s7, v_avg($0)		# store the value

	halt

p1_check:
	lw 		$t0, fin($0) 		# check signal from p0
	beq 	$t0, $0, consumer	# finish or return to consumer
	j 		finish_p1

tail_reset:
	beq 	$s4, $s2, tail_reset2
	jr 		$ra 				# return to caller

tail_reset2:
	ori 	$s4, $0, 0
	jr 		$ra 				# return to caller

# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
acquire:
	ll		$t0, 0($a0)			# load lock location
	bne		$t0, $0, acquire 	# wait on lock to be open
	addiu	$t0, $t0, 1	
	sc		$t0, 0($a0)
	beq		$t0, $0, lock 		# if sc failed retry
	jr		$ra


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
	sw		$0, 0($a0)
	jr		$ra


###############################################################################
#							Subroutines - given
###############################################################################
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra

min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra

divide:               # setup frame
  push  $ra           # saved return address
  push  $a0           # saved register
  push  $a1           # saved register
  or    $v0, $0, $0   # Quotient v0=0
  or    $v1, $0, $a0  # Remainder t2=N=a0
  beq   $0, $a1, divrtn # test zero D
  slt   $t0, $a1, $0  # test neg D
  bne   $t0, $0, divdneg
  slt   $t0, $a0, $0  # test neg N
  bne   $t0, $0, divnneg
divloop:
  slt   $t0, $v1, $a1 # while R >= D
  bne   $t0, $0, divrtn
  addiu $v0, $v0, 1   # Q = Q + 1
  subu  $v1, $v1, $a1 # R = R - D
  j     divloop
divnneg:
  subu  $a0, $0, $a0  # negate N
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
  beq   $v1, $0, divrtn
  addiu $v0, $v0, -1  # return -Q-1
  j     divrtn
divdneg:
  subu  $a0, $0, $a1  # negate D
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
divrtn:
  pop $a1
  pop $a0
  pop $ra
  jr  $ra

crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  srl $t4, $a0, 31
  sll $a0, $a0, 1
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra

###############################################################################
#							DATA
###############################################################################

# lock value
l4:
	cfw 	0x0000

# done signal
fin:
	cfw 	0x0000

# circular buffer
buffer:
	cfw 	0x000
	cfw 	0x000
	cfw 	0x000
	cfw 	0x000
	cfw 	0x000
	cfw 	0x000
	cfw 	0x000
	cfw 	0x000
	cfw 	0x000
	cfw 	0x000
  
# buffer size
buffSZ:       
	cfw 	0x000

org 	0x0800

# values for min, max and avg
v_min:
	cfw 	0xFFFF
v_max:
	cfw 	0x0000
v_avg:
	cfw 	0xFFFF
