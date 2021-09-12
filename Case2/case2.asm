.data 			      		
	buf: .word 0x0000
.text 
start:
	lui   $1,0xFFFF			
        ori   $28,$1,0xF000

	lui     $1,0x0000
	lui	$19,0x00FF	#time

	

	
	
	


			
        ori    $27,$1,0x0000
	ori	$26,$1,0x0001
	ori	$25,$1,0x0002
	ori	$24,$1,0x0003
	ori	$23,$1,0x0004
	ori	$22,$1,0x0005
	ori	$21,$1,0x0006
	ori	$21,$1,0x0006
	ori	$10,$1,0x0007 #¸Ä³É$10

	lui	$5,0x0000
	ori	$3,$5,0x5555 #even
	ori	$4,$5,0xaaaa #odd

	ori	$18,$1,0xFFFF
	ori    $17,$1,0x00FF
	ori    $16,$1,0xFF00
		

loop:
	lui	$20,0x0000
	lw	$2,0xC70($28)	#FFFFFC72  $2  1 000

	srl    $2,$2,16
	andi    $2,$2,7
	
	beq 	$27,$2,case0
	beq	$26,$2,case1
	beq	$25,$2,case2
	beq	$24,$2,case3
	beq	$23,$2,case4
	beq	$22,$2,case5
	beq	$21,$2,case6
	beq   	$10,$2,case7

	j loop

case0:
	lw	$1,0xC70($28)	#FFFFFC70  $1   sw15-sw0
	and     $3,$1,$16
	srl     $3,$3,8	
	and	$4,$1,$17
	
	j time
	
case1:
	add     $1,$3,$4
	sw	$1,0xC60($28)
	j time
case2:  #val = val+1
	sub     $1,$3,$4
	sw	$1,0xC60($28)
	j time
case3:  #val = val-1
	sllv     $1,$3,$4
	sw	$1,0xC60($28)
	j time
case4:  #shift left
	srlv     $1,$3,$4
	sw	$1,0xC60($28)
	j time
case5:  #shift right logical
	slt    $1,$4,$3  
	sw	$1,0xC60($28)
	j time
case6:  #shift right arithmetic
	and     $1,$3,$4
	sw	$1,0xC60($28)
	j time
	
case7:  #shift right arithmetic
	xor     $1,$3,$4
	sw	$1,0xC60($28)
	j time


time:
	beq	$20,$19,loop
	addi	$20,$20,1
	j time
	



	


