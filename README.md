# Binary Search in Assembly Language 🖥️🔍

Iterative solution for the Divide and Conquer Binary Search Algorithm. Prompts the User to imput an array of size 1 &lt;= n &lt;= 20 with the precondition that the array is already sorted in ascending order. User is then asked for an element to search. The algorithm divides and conquers this array to see if the element is present and outputs whether or not it was found and if found, where in the array it was found.

- Written in **Assembly Language** for the **MIPS** Architecture.
- MIPS is a **RISC Instruction Set Architecture**
- Written, Tested and Simulated using **MARS MIPS Simulator** ([MSU](http://courses.missouristate.edu/kenvollmar/mars/))

#### Code Snippet:

```assembly

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

```
