.data 
src: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 # original matrix

dst: .word 0:16 # empty array for results

M:   .word 4
MxM: .word 16

.text

#
main:

# Load Pointers to Arrays
load_pointers:
la		$s1, src		# pointer to source array 
la    $s2, dst    # pointer to destination array


for_loop:
lw    $s3, MxM    # save matrix size (for comparison)
lw    $s7, M      # save row/col size  (for comparison)
move    $s4,$zero # src line index
move    $s5,$zero # offset
move     $s6,$s1  # save begining of src
iterations:
addi $s4,$s4,1    # update src index (first line is 1, last line is 4)
lw   $t1,0($s6)   # load element from src
sw   $t1,0($s2)      # save to dst 
addi $s2,$s2,4        # increment dst pointer

slt  $t3,$s4,$s7            # Check if the second is bigger than first one, true? set 1 to $t3
beq  $t3,$zero,end_of_line  # if $s4(index) is equal to $s3(size of matrix) -> reached the end of line
addi $s6,$s6,16    # go to next line (skip 4 elements)

j		iterations		# jump to iterations (next iteration)

end_of_line:


move    $s4,$zero # src line index
addi    $s5,$s5,4 # increment offset
add     $s6, $s1,$s5  # add offset
bne     $s5,$s3,iterations   # if not reached to end of matrix - continue iterations

end: # infinite loop to keep cpu busy
add	$zero,$zero,$zero
j	end

