.data 			      		
	buf: .word 0x0000
.text 
start:
	lui   $1,0xFFFF			
        ori   $28,$1,0xF000

	lui     $1,0x0000
	lui	$19,0x00FF	#time
	lui     $16,0xFFFF

	srl   $15,$19,16

	
	
	


			
        ori    $27,$1,0x0000
	ori	$26,$1,0x0001
	ori	$25,$1,0x0002
	ori	$24,$1,0x0003
	ori	$23,$1,0x0004
	ori	$22,$1,0x0005
	ori	$21,$1,0x0006

	lui	$5,0x0000
	ori	$3,$5,0x5555 #even
	ori	$4,$5,0xaaaa #odd

	ori	$18,$1,0xFFFF
	ori    $17,$1,0x0007 #
		

loop:
	lui	$20,0x0000
	
	lw	$2,0xC70($28)	#FFFFFC72  $2  1 000
	srl    $2,$2,16  #

	and     $2,$2,$17 #
	
	beq 	$27,$2,case0
	beq	$26,$2,case1
	beq	$25,$2,case2
	beq	$24,$2,case3
	beq	$23,$2,case4
	beq	$22,$2,case5
	beq	$21,$2,case6

	j loop

case0:
	sw	$3,0xC60($28)
even:
	beq	$20,$19,odd
	addi	$20,$20,1
	j even
odd:
	lui	$20,0x0000
	sw	$4,0xC60($28)
	j time
	
case1:
	lw	$1,0xC70($28) #FFFFFC70  $1   sw15-sw0	
	
	srl    $5,$1,24
	beq    $5,$15,negative
	
	and	$1,$1,$18
	j store
	
	negative:
	or     $1,$1,$16
	
	
	
	store:
	sw	$1,0xC60($28)
	j time
case2:  #val = val+1
	addi	$1,$1,1
	sw	$1,0xC60($28)
	j time
case3:  #val = val-1
	addi	$1,$1,-1
	sw	$1,0xC60($28)
	j time
case4:  #shift left
	sll	$1,$1,1
	sw	$1,0xC60($28)
	j time
case5:  #shift right logical
	srl $1,$1,1
	sw	$1,0xC60($28)
	j time
case6:  #shift right arithmetic
	
	sra	$1,$1,1
	sw	$1,0xC60($28)
	j time


time:
	beq	$20,$19,loop
	addi	$20,$20,1
	j time
	



	


