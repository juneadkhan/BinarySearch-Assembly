.data

A:			.space 80  	# integer array with 20 elements (A[20])
size_prompt:		.asciiz 	"Enter a array size [between 1 and 20]: "
array_prompt:		.asciiz 	"A["
sorted_array_prompt:	.asciiz 	"A["
close_bracket: 		.asciiz 	"]"
close_bracket_equal: 	.asciiz 	"] = "
search_prompt:		.asciiz		"Enter search value: "
is_found:		.asciiz		" is found in "
not_found:		.asciiz		" not in array"
ensure_input:		.asciiz		"Ensure the input is sorted (Low to High)"
newline: 		.asciiz 	"\n" 	

.text

main:	

	la $s0, A			# store address of array A in $s0
  
	add $s1, $0, $0			# create variable "size" ($s1) and set to 0
	add $s2, $0, $0			# create search variable "v" ($s2) and set to 0
	add $t0, $0, $0			# create variable "i" ($t0) and set to 0

	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, size_prompt 		# put string memory address in register $a0
	syscall           		# print string
  
	addi $v0, $0, 5			# system call (5) to get integer from user and store in register $v0
	syscall				# get user input for variable "size"
	add $s1, $0, $v0		# copy to register $s1, b/c we'll reuse $v0
	
	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, newline			# put string memory address in register $a0 
	syscall  			# NEWLINE
	
	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, ensure_input 		# put string memory address in register $a0
	syscall           		# print string
	
	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, newline			# put string memory address in register $a0 
	syscall  			# NEWLINE
  
prompt_loop:

	slt $t1, $t0, $s1		# if( i < size ) $t1 = 1 (true), else $t1 = 0 (false)
	beq $t1, $0, end_prompt_loop	 
	sll $t2, $t0, 2			# multiply i * 4 (4-byte word offset)
				
  	addi $v0, $0, 4  		# print "A["
  	la $a0, array_prompt 			
  	syscall  
  	         			
  	addi $v0, $0, 1			# print	value of i (in base-10)
  	add $a0, $0, $t0			
  	syscall	
  					
  	addi $v0, $0, 4  		# print "] = "
  	la $a0, close_bracket_equal		
  	syscall					
  	
  	addi $v0, $0, 5			# get input from user and store in $v0
  	syscall 			
	
	add $t3, $s0, $t2		# A[i] = address of A + ( i * 4 )
	sw $v0, 0($t3)			# A[i] = $v0 
	addi $t0, $t0, 1		# i = i + 1
		
	j prompt_loop			# jump to beginning of loop

end_prompt_loop:

	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, newline			# put string memory address in register $a0 
	syscall  			# NEWLINE
	
	addi $v0, $0, 4  		# print "Enter search value: "
  	la $a0, search_prompt 			
  	syscall 
  	
  	addi $v0, $0, 5			# system call (5) to get integer from user and store in register $v0
	syscall				# get user input for variable "v"
	add $s2, $0, $v0		# copy to register $s2, b/c we'll reuse $v0
	
  	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, newline			# put string memory address in register $a0 
	syscall  			# NEWLINE
		
binarySearch:
	
	li $t1, 0 			# left = 0
	li $t2, 0 			# middle = 0
	subu $t3, $s1, 1 		# right = size - 1 
	li $t4, -1 			# elementindex = -1
	
whileLoop: 

	bgt $t1, $t3, end 		# end while when left > right
	
	subu $t2, $t3, $t1 		# Middle = right - left
	srl $t2, $t2, 1 		# Middle = (right - left) / 2
	
	add $t2, $t2, $t1	 	# Middle = left + (right - left) / 2
	
	sll $t6, $t2, 2    		# index for A[Middle]
        addu $s0, $0, $t6       	# point to middle
	lw  $a0, 0($s0)         	# a0 = A[middle]
		
	bne $a0, $s2, notEqual 		# if ( A[middle] == v) { IF NOT SKIP TO notEqual
		
	add $t4, $0, $t2 		# element_index = middle
	j end 				# BREAK
	
	notEqual:
	
		slt $t5, $a0, $s2 	# is A[middle] < v . IF YES, t5 = TRUE
		beqz $t5, notLess
		
		addi $t1, $t2, 1 	# left = middle + 1
		j pastnotLess

	notLess:	
		subi $t3, $t2, 1 	# right = middle - 1
		
	pastnotLess:
	
		j whileLoop
	
					# END OF WHILE
	
end:
	
	bge $t4, $0, notIndex
		
	addi $v0, $0, 1  		# system call (1) to print Int
	la $a0, ($s2) 			# put string memory address in register $a0
	syscall   			# search value
			
	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, not_found 		# put string memory address in register $a0 - printf( "%d not in sorted A\n", v );
	syscall  			# not in sorted A
		
	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, newline			# put string memory address in register $a0 
	syscall  			# NEWLINE 
		
	j exit
	
notIndex:
		
	addi $v0, $0, 1  		# system call (1) to print Int
	la $a0, ($s2)			# put string memory address in register $a0 
	syscall  			# Element
		
	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, is_found 		# put string memory address in register $a0
	syscall    			# is found in
		
		
	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, sorted_array_prompt 	# put string memory address in register $a0
	syscall    			#Sorted A[
		
	addi $v0, $0, 1  		# system call (1) to print Int
	la $a0, ($t4) 			# put string memory address in register $a0 
	syscall  			# Element Index
		  
	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, close_bracket		# put string memory address in register $a0
	syscall 			# ]
		
	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, newline			# put string memory address in register $a0 
	syscall  			# NEWLINE

exit:                
  addi $v0, $0, 10      		# system call (10) exits the progra
  syscall               		# exit the program