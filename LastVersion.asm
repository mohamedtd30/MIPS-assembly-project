.data
     dequeSize: .word 12  
     barSize: .word 12
     emptyErrorMsg: .asciiz "The deque is empty..!\n"
     creationErrorMsg: .asciiz "Please, Create a deque first..!"
     enterMsg: .asciiz "Enter number of initial products :\n"
     return_del_val: .word 0
     product: .asciiz "Product "
     coul: .asciiz ":\n"
     price: .asciiz "Price: "
     ser: .asciiz "Serial Number: "
     cat: .asciiz "Category: "
     line: .asciiz "==============================\n"
     enterDataMsg: .asciiz  "\nEnter price and serial number and category of Product("
     contEnterDataMsg: .asciiz "):\n"
     prompt: .asciiz "Enter 'l' or 'L' to click on the left button,\n'r' or 'R' to click on the right: "
     final:.asciiz "\nMission completed successfully!!!\n"
     no_data_msg:.asciiz  "\nNo more data to move right.\n"
      line2: .asciiz "\n==============================\n"
.text
############################################################ 
main:

jal createBar
move $s0,$v0

move $a0,$s0
jal init 

whileTrue:
	la $a0, prompt
    	li $v0, 4
   	syscall

    	li $v0, 12
    	syscall
    	move $t0 ,$v0
    	li $t1, 'l'
    	li $t2, 'L'
    	beq $t0, $t1, doLeft
    	beq $t0, $t2, doLeft

    	li $t1, 'r'
    	li $t2, 'R'
    	beq $t0, $t1, doRight
    	beq $t0, $t2, doRight
    	
    	j breakLoop
    	
    	doRight:
    	move $a0,$s0
    	jal rightArrow
    	j whileTrue
    	doLeft:
    	move $a0,$s0
    	jal leftArrow
    	j whileTrue
    	
    	breakLoop:
    	la $a0, final
    	li $v0, 4
   	syscall
    	
    	
    	
    	
  
     

###################################################################

j endFile

####################################################################

####Creation#######

createDeque:
       		la $a0, dequeSize 
       		lw $a0, 0($a0)  
       		li $v0, 9  
       		syscall
       		jr $ra
####################################################################
	
creatNode:
       addi $sp, $sp, -4
       sw $s0, 0($sp)
       li $a0, 17
       li $v0, 9
       syscall 
       move $s0, $v0
       sw $a1, 8($s0)
       sw $a2, 12($s0)
       sb $a3, 16($s0)
       lw $s0, 0($sp)
       addi $sp, $sp, 4
       jr $ra
#####################################################################    
###INSERTION#####
insertRear:  
	 
	 addi $sp, $sp, -20
   	 sw $s0, 0($sp)
   	 sw $s1 ,4($sp)
   	 sw $ra ,8($sp)
   	 sw $t2,12($sp)
  	 sw $t0,16($sp)
   	 beq $a0,$zero,exitInsertRear
   	 move $s0,$a0   #$s0 ----> address of the deque   
	 jal creatNode
	 move $s1,$v0   #$s1 ----->node address
	 lw $t0 8($s0)
	 beq  $t0 ,$zero, firstInsertionAll
	 lw $t2 8($s0)  #$t2 ----->address of the last node before insertion 
	 sw $t2 0($s1)
	 sw $zero 4($s1)
        	 sw $s1 4($t2)
	 sw $s1 8($s0)
	j endInsertRear
	firstInsertionAll:
		sw $s1 4($s0)
		sw $s1 8($s0)
		sw $zero, 0($s1)
   		sw $zero, 4($s1)
   	endInsertRear:	
   		lw $t5 ,0($s0)
		addi $t5,$t5,1
		sw $t5,0($s0)
	exitInsertRear:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $ra, 8($sp)
		lw $t2,12($sp)
  	lw $t0,16($sp)
   		addi $sp, $sp, 20
   		jr $ra

####################################################################

insertFront:
  	addi $sp, $sp, -20
  	sw $s0, 0($sp)
  	sw $s1, 4($sp)
  	sw $ra, 8($sp)
  	sw $t1,12($sp)
  	sw $t0,16($sp)
  	move $s0, $a0   # address returned from createDeque function
  	beq $s0, $zero, endInsertion
  	jal creatNode
  	move $s1, $v0 # address of the node 
  	lw $t0, 4($s0)
  	beq $t0, $zero, emptyDeque
  	sw $t0, 4($s1) #t0--------> address of the old front
  	sw $zero ,0($s1)
  	sw $s1, 0($t0)
  	sw $s1, 4($s0)
  	lw $t1, 0($s0)
  	addi $t1, $t1, 1
  	sw $t1, 0($s0)
  	j endInsertion
  	emptyDeque:
   		sw $s1, 4($s0)
   		sw $s1, 8($s0)
   		sw $zero, 0($s1)
   		sw $zero, 4($s1)
   		lw $t1, 0($s0)
   		addi $t1, $t1, 1
   		sw $t1, 0($s0)
  	endInsertion:
   		lw $s0, 0($sp)
   		lw $s1, 4($sp)
   		lw $ra ,8($sp)
   		lw $t1,12($sp)
  		lw $t0,16($sp)
   		addi $sp, $sp, 20
   		jr $ra
############################################################
######### Checking ##########

isEmpty:
    addi $sp, $sp, -4
    sw $ra, 0($sp) 
    jal checkCreation        
    lw $t0, 8($a0)
    
    
    
    beq $t0, $zero, empty
    li $v0, 0              # Return zero if not null
    lw $ra, 0($sp)         
    addi $sp, $sp, 4
    jr $ra
    empty:
    li $v0, 1
    lw $ra, 0($sp)         
    addi $sp, $sp, 4
    jr $ra
    
    
############################################################

checkCreation:
  addi $sp, $sp, -4
      sw $v0, 0($sp)
      addi $sp, $sp, -4
      sw $a0, 0($sp)
      
  beq $a0, $zero, errorCreate 
    lw $a0, 0($sp)
        addi $sp, $sp, 4
        lw $v0, 0($sp)
        addi $sp, $sp, 4 
        jr $ra
      errorCreate:
        li $v0, 4
        la $a0, creationErrorMsg
        syscall
        li $v0, 10
        syscall
        
###########################################################
error: 
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    addi $sp, $sp, -4
    sw $a0, 0($sp)
    
    li $v0, 4
    la $a0, emptyErrorMsg
    syscall
    
    lw $a0, 0($sp)
    addi $sp, $sp, 4
    lw $v0, 0($sp)
    addi $sp, $sp, 4
    lw $ra, 0($sp)         
    addi $sp, $sp, 4
    jr $ra



############################################################
########## Display ##########


#############################################################
display:
    addi $sp, $sp, -36
    sw $ra, 0($sp)         
    sw $v0, 4($sp)
    sw $s0, 8($sp)     
    sw $t0,12($sp)
    sw $t1,16($sp)
    sw $t2,20($sp)
    sw $t3,24($sp)
    sw $a0,32($sp)
    jal isEmpty
    move $t0, $v0
    bne $t0, $zero, error
    
    
    
    lw $t2, 4($a0)         # Front ptr
    lw $s0, 0($a0)     	# size in t1
    li $t1, 1
    
   
    li $v0, 4
    la $a0, line2
    syscall
    loop_print: 
        	lw $t3, 8($t2)
        	
        	li $v0, 4
        	la $a0, product
        	syscall
        	li $v0, 1
          	move $a0, $t1
        	syscall
        	addi $t1, $t1, 1   #product num.
        	
        	li $v0, 4
        	la $a0, coul
        	syscall
        	
        	li $v0, 4
        	la $a0, price
        	syscall
          	li $v0, 1
          	move $a0, $t3
          	syscall
          	li $v0, 11          
  		li $a0, 10          
        	syscall
        	
        	li $v0, 4
        	la $a0, ser
        	syscall
        	lw $t3, 12($t2)
        	li $v0, 1
          	move $a0, $t3
          	syscall
          	li $v0, 11          
  		li $a0, 10          
        	syscall
        	
        	li $v0, 4
        	la $a0, cat
        	syscall
        	lb $t3, 16($t2)
        	#addi $t3, $t3, -48  # Subtract ASCII offset to convert from ASCII to character
        	move $a0, $t3
        	li $v0, 11
        	syscall
        	li $v0, 11          
  		li $a0, 10          
        	syscall
        	li $v0 ,4
        	la $a0 ,line
        	syscall
        	
        	lw $t2, 4($t2)
    bne $t2, $zero, loop_print
     
       lw $ra, 0($sp)         
    lw $v0, 4($sp)
    lw $s0, 8($sp)     
    lw $t0,12($sp)
    lw $t1,16($sp)
    lw $t2,20($sp)
    lw $t3,24($sp)
    lw $a0,32($sp)        
     addi $sp,$sp,36 
      jr $ra
###################################################################################
# Deletion and Clear


clear:
 	addi $sp, $sp, 8
 	sw $s0, 0($sp)
 	sw $s3, 4($sp)
 	lw $s0, 0($a0)
 	lw $s3, 4($a0)
 	beq $s0, $zero, endLoop
 	Loop:
  		beq $s0, $zero, endLoop
  		add $t1, $zero, $s3
  		lw $s3, 4($s3)
  		sw $zero, 0($t1)
  		addi $t2, $t1, 4
  		sw $zero, 0($t2)
  		addi $t2, $t2, 4
  		sw $zero, 0($t2)
  		addi $t2, $t2, 4
  		sw $zero, 0($t2)
  		addi $t2, $t2, 4
  		sb $zero, 0($t2)
  		bne $s3 ,$zero,Loop
  	endLoop:
  		sw $zero, 0($a0)
  		sw $zero, 4($a0)
  		sw $zero, 8($a0)
  		lw $s0, 0($sp)
  		lw $s3, 4($sp)
  		addi $sp, $sp, 8
  		jr $ra
#############################################################
deleteFront:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $t0,4($sp)
    sw $t2,8($sp)
    sw $t3,12($sp)
    jal isEmpty
    move $t0, $v0

    bne $t0, $zero, error

    lw $t0, 4($a0)

    sw $zero, 8($t0)
    sw $zero, 12($t0)
    sw $zero, 16($t0)

    lw $t2, 4($t0)         # Get the next ptr to make it first

    sw $zero, 4($t0)
    sw $zero, 0($t0)

    beq $t2, $zero, out
        sw $zero, 0($t2)       # Make first ptr of 2nd element 0 
    out:

    sw $zero, 4($t0)       # Put 0 in popped next ptr

    lw $t3, 0($a0)         # Get size
    addi $t3, $t3, -1
    sw $t3, 0($a0)

    sw $t2, 4($a0)         # Put the next ptr of the popped in first

    bne $t2, $zero, go
    sw $zero, 8($a0)

    go:
        lw $ra, 0($sp)
         lw $t0,4($sp)
    lw $t2,8($sp)
    lw $t3,12($sp)
        addi $sp, $sp, 16
        jr $ra
##########################################################################


deleteRear:
	addi $sp , $sp , -28
	sw   $ra ,0($sp)
	sw   $s0 ,4($sp)
	sw   $t0,8($sp)
	sw   $t1,12($sp)
	sw   $t2,16($sp)
	sw   $t3,20($sp)
	sw   $t4,24($sp)
	move $s0,$a0    #s0------------>address of deque
	jal isEmpty
	move $t0 , $v0
	li $v0,-1
	bne $t0,$zero, EmptyDeque
	lw $t2 , 8($s0)
	move $t1,$t2
	lw $t3, 0($t2)
	sw $t3 , 8($s0)
	lw $t4 ,8($s0)
	beq $t4 , $zero,LastDeletionRear
	sw $zero 4($t4)
	j  endDeleteRear
	LastDeletionRear:
		sw $zero 4($s0)
	j endDeleteRear
	EmptyDeque:
		la $a0 ,emptyErrorMsg
		li $v0 ,4
		syscall 
		li $v0 10
		syscall
	j exitDeleteRear
	endDeleteRear:
		lw $t6  0($s0)
		addi $t6,$t6,-1
		sw $t6,0($s0)
		sw $zero 0($t1)
		sw $zero 4($t1)
		sw $zero 8($t1)
		sw $zero 12($t1)
		sw $zero 16($t1)
	exitDeleteRear:
		lw $ra ,0($sp)
		lw $s0 ,4($sp)
		lw   $t0,8($sp)
		lw   $t1,12($sp)
		lw   $t2,16($sp)
		lw   $t3,20($sp)
		lw   $t4,24($sp)
		addi $sp ,$sp,28
		jr $ra



   
############################################################################
########### GETTING DATA ################

getFront:
    addi $sp, $sp, -4
    sw $ra, 0($sp)         
    jal isEmpty
    move $t0, $v0
    bne $t0, $zero, error
    lw $v0, 4($a0)
    lw $ra 0($sp)
    addi $sp,$sp,4
    jr $ra
    
#########################################################################
getRear:
    addi $sp, $sp, -4
    sw $ra, 0($sp)         
    jal isEmpty
    move $t0, $v0
    bne $t0, $zero, error
    lw $v0, 8($a0)
    lw $ra 0($sp)
    addi $sp,$sp,4
    jr $ra
#############################################################
getSize:
	lw $v0 ,0($a0)
	jr $ra
##################################################################
createBar:
		la $a0, barSize 
       		lw $a0, 0($a0)  
       		li $v0, 9  
       		syscall
       		jr $ra
#####################################################################
init:
	addi $sp, $sp,-28
	sw $ra ,0($sp)
	sw $s0 ,4($sp)
	sw $s1 ,8($sp)
	sw $s2 ,12($sp)
	sw $s3 ,16($sp)
	sw $t0 ,20($sp)
	sw $t9 ,24($sp)
	move $s2,$a0    #$s2-------------> bar
	jal createDeque
	move $s0,$v0    #$s0-------------> data


	jal createDeque
	move $s1,$v0    #$s1-------------> view

	

	sw $s0, 0($s2)
	sw $s1 ,4($s2)


    	la $a0, enterMsg
    	li $v0, 4
    	syscall

    	li $v0, 5
    	syscall
    
    	move  $s3,$v0
    	
    	li $t0,0
    	initLoop:
    		la $a0, enterDataMsg
    		li $v0, 4
    		syscall
    		
    		move $t9,$t0
    		addi $t9,$t9,1
    		li $v0,1
    		move $a0,$t9
    		syscall
    		
    		la $a0, contEnterDataMsg
    		li $v0, 4
    		syscall
    		
    		li $v0, 4
        		la $a0, price
       	 	syscall
    		li $v0, 5
    		syscall
    		move  $a1,$v0
    		
    		 li $v0, 4
        		la $a0, ser
        		syscall
    		li $v0, 5
    		syscall
    		move  $a2,$v0
    		
    		li $v0, 4
        		la $a0, cat
       	 	syscall
    		li $v0, 12
    		syscall
    		move  $a3,$v0
    		
    		move $a0,$s2
    		
    		jal addProduct
    		
    		addi $t0,$t0,1
    		bne $t0,$s3,initLoop
    		
    	move $a0,$s1
    	jal display
    	
    	
	lw $ra ,0($sp)
	lw $s0 ,4($sp)
	lw $s1 ,8($sp)
	lw $s2 ,12($sp)
	lw $s3 ,16($sp)
	lw $t0 ,20($sp)
	lw $t9 ,24($sp)
    	addi $sp,$sp,28
    	
    	jr $ra
    		
    		
#######################################################################
    	
    	addProduct:
         addi $sp, $sp, -8
         sw $ra, 0($sp)
         sw $t0 ,4($sp)    
         lw $t0 ,8($a0)
         addi $t0,$t0,1
	 sw $t0,8($a0)   	 
         beq $t0,6,c
         slti $t1 ,$t0 , 6
         beq $t1 , 1 , c
         lw  $a0 ,0($a0)
         jal insertRear
         
         j endAdd
         c:
         lw  $a0 ,4($a0)
         jal insertRear
         endAdd:
         lw $ra, 0($sp)
         lw $t0,4($sp)
         addi $sp, $sp, 8
         jr $ra




 




	


##################################################################
# Tesla part -----------------------------------------------------
# Function to print "No more data to move left." and return
printNoData:
    li $v0, 4             # Load system call for print_string
    la $a0, no_data_msg   # Load address of the message string
    syscall               # Print the message
    jr $ra                 # Return to caller
    
########### LEFT ARROW  ################
leftArrow:
	
	addi $sp, $sp,-28
	sw $ra ,0($sp)
	sw $t0 ,4($sp)
	sw $t1 ,8($sp)
	sw $t2 ,12($sp)
	sw $t3 ,16($sp)
	sw $t4 ,20($sp)
	sw $t5 ,24($sp)
	
	move $t0,$a0 
	lw $t1,0($t0) # data deque
	lw $t2,4($t0) # view deque 
	lw $t3,8($t1) # rear of data
	lw $t4,4($t1) # front of view
	beqz $t3,printNoData 
	beqz $t4,printNoData
	
	# Remove data from the front of the view deque
	move $a0,$t2
	jal getFront
	move $t5,$v0  # data of deleted item .
	move $a0,$t1 
	lw $a1,8($t5)
	lw $a2,12($t5)
	lw $a3,16($t5)
	jal insertRear
	move $a0,$t2
	jal deleteFront
	
	# Insert removed data at the front of the data deque
	  # data of deleted item 
	move $a0,$t1
	jal getFront
	move $t5,$v0
	move $a0,$t2 
	lw $a1,8($t5)
	lw $a2,12($t5)
	lw $a3,16($t5)
	
	jal insertRear
	#  Remove data from the rear of the data deque
	move $a0,$t1
	jal deleteFront
	
	# Insert removed data at the rear of the view deque
	
	
	
	
	# display items 
	move $a0,$t2
	jal display
	
	lw $ra ,0($sp)
	lw $t0 ,4($sp)
	lw $t1 ,8($sp)
	lw $t2 ,12($sp)
	lw $t3 ,16($sp)
	lw $t4 ,20($sp)
	lw $t5 ,24($sp)
	addi $sp, $sp,28
	
	jr $ra

########### RIGHT ARROW  ################
rightArrow:
	addi $sp, $sp,-28
	sw $ra ,0($sp)
	sw $t0 ,4($sp)
	sw $t1 ,8($sp)
	sw $t2 ,12($sp)
	sw $t3 ,16($sp)
	sw $t4 ,20($sp)
	sw $t5 ,24($sp)



	move $t0,$a0 
	lw $t1,0($t0) # data deque
	lw $t2,4($t0) # view deque 
	lw $t3,4($t1) # front of data
	lw $t4,8($t1) # rear of view
	beqz $t3,printNoData 
	beqz $t4,printNoData
	
	# Remove data from the rear of the view deque
	move $a0,$t2
	jal getRear
	
	move $t5,$v0  # data of deleted item .
	move $a0,$t1 
	lw $a1,8($t5)
	lw $a2,12($t5)
	lw $a3,16($t5)
	jal insertFront
	
	
	move $a0,$t2
	jal deleteRear
	
	# Insert removed data at the rear of the data deque
	
	move $a0,$t1
	jal getRear
	
	
	move $t5,$v0  # data of deleted item .
	move $a0,$t2 
	lw $a1,8($t5)
	lw $a2,12($t5)
	lw $a3,16($t5)
	jal insertFront
	#  Remove data from the front of the data deque
	move $a0,$t1
	jal deleteRear
	
	# Insert removed data at the front of the view deque
	
	
	# display items 
	move $a0,$t2
	jal display
	lw $ra ,0($sp)
	lw $t0 ,4($sp)
	lw $t1 ,8($sp)
	lw $t2 ,12($sp)
	lw $t3 ,16($sp)
	lw $t4 ,20($sp)
	lw $t5 ,24($sp)
	addi $sp, $sp,28
	
	jr $ra

###################################################################

endFile:


