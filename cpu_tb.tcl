# restart the simulation
restart

#forcing a clock with 10 ns period
add_force clock 1 {0 5ns} -repeat_every 10ns

#top-level CPU testbench is named cpu_tb
#this instruction will add the internal signals and ports of a component name U_1, which in this case is the memory block.
#this should be replaced by the name of the componenet in your top-level testbench
add_wave {{/cpu_tb/U_1}} 
#add_wave {{/cpu_tb/U_0/ControlUnit/opCode}}
add_wave {{/cpu_tb/U_0/ControlUnit/state}}
#add_wave {{/cpu_tb/U_0/ControlUnit/IRWrite}} 
#add_wave {{/cpu_tb/U_0/ControlUnit/PCWrite}} 
#add_wave {{/cpu_tb/U_0/DP/RegFile/regArr}} 
#add_wave {{/cpu_tb/U_0/ControlUnit/RegWrite}}
#add_wave {{/cpu_tb/U_0/DP/RegFile/wr}}
#add_wave {{/cpu_tb/U_0/DP/RegFile/wd}}
#add_wave {{/cpu_tb/U_0/ControlUnit/ALUSrcB}}
#add_wave {{/cpu_tb/U_0/DP/MultUnit/A}}
#add_wave {{/cpu_tb/U_0/DP/MultUnit/B}}
#add_wave {{/cpu_tb/U_0/DP/MultUnit/R}}
#add_wave {{/cpu_tb/U_0/ControlUnit/ALUControlOp}}
#add_wave {{/cpu_tb/U_0/DP/ALUUnit/ALUOp}}
#add_wave {{/cpu_tb/U_0/DP/ALUOut/Q}}
#add_wave {{/cpu_tb/U_0/DP/WriteDataMux/in1}}
#add_wave {{/cpu_tb/U_0/DP/WriteDataMux/output}}
#add_wave {{/cpu_tb/U_0/DP/ALU_OC_MUX/output}}
#add_wave {{/cpu_tb/U_0/DP/AReg/D}}
#add_wave {{/cpu_tb/U_0/DP/BReg/D}}
#add_wave {{/cpu_tb/U_0/DP/BReg/Q}}
#add_wave {{/cpu_tb/U_0/DP/RegFile/r1}}
#add_wave {{/cpu_tb/U_0/DP/RegFile/d1}}

# Test 0

#addi $7, $0, 17
#addi $11, $0, -3
#and $11, $7, $11
#sw $11, 15($7)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
# the first 4 memory locations are initialized with the instruction codes correpsonding to the 4 instructions above.
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {20070011}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {200BFFFD}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {00EB5824}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {ACEB000F}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}
#add_force {/cpu_tb/U_1/mw_U_0ram_table[8]} -radix hex {00000000}

#give a reset signal
add_force reset 0
run 2500ps

add_force reset 1
run 5 ns
add_force reset 0

run 400 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x00000011} {
	puts "Test 0 passed."
} else {
	puts "Test 0 failed."
}

# Test 1

#addi $7, $0, 17
#addi $11, $0, -3
#sub $11, $7, $11
#sw $11, 15($7)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {20070011}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {200BFFFD}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {00EB5822}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {aceb000f}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 400 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x00000014} {
	puts "Test 1 passed."
} else {
	puts "Test 1 failed."
}

# Test 2

#addi $7, $0, 17
#addi $11, $0, -3
#addu $11, $7, $11
#sw $11, 15($7)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {20070011}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {200BFFFD}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {00EB5821}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {aceb000f}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 400 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x0000000E} {
	puts "Test 2 passed."
} else {
	puts "Test 2 failed."
}

# Test 3

#addi $7, $0, 17
#addi $11, $0, -3
#sra $11, $7, 1
#sw $11, 15($7)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {20070011}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {200BFFFD}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {00075843}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {aceb000f}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 400 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x00000008} {
	puts "Test 3 passed."
} else {
	puts "Test 3 failed."
}

# Test 4

#addi $7, $0, 17
#addi $11, $0, -3
#sllv $11, $7, $7
#sw $11, 15($7)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {20070011}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {200BFFFD}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {00E75804}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {aceb000f}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 400 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x00220000} {
	puts "Test 4 passed."
} else {
	puts "Test 4 failed."
}

# Test 5

#addi $7, $0, 17
#addi $11, $0, -3
#slti $11, $7, 63
#sw $11, 15($7)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {20070011}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {200BFFFD}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {28EB003F}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {aceb000f}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 400 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x00000001} {
	puts "Test 5 passed."
} else {
	puts "Test 5 failed."
}

# Test 6

#addi $7, $0, 17
#addi $11, $0, -3
#bne $11, $7, B_GO
#addi $1, $0, 2
#sll $0, $0, 0
#sll $0, $0, 0
#B_GO: addi $1, $0, 1
#sw $1, 15($7)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {20070011}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {200BFFFD}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {15670003}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {20010002}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {20010001}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {ACE1000F}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 800 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x00000001} {
	puts "Test 6 passed."
} else {
	puts "Test 6 failed."
}

# Test 7

#lui $1, 0x00001001
#ori $13, $1,0x00000020
#lui $1, 0x00000123
#ori $9, $1,0x00004567
#sw $9, 0($13)
#lh $11, 2($13)
#sw $11, 16($13)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {3C011001}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {342D0020}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {3C010123}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {34294567}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {ADA90000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {85AB0002}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {ADAB0010}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 800 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x01234567} {
	puts "Test 7 passed 1."
} else {
	puts "Test 7 failed 1."
}

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[12]}] == 0x00000123} {
	puts "Test 7 passed 2"
} else {
	puts "Test 7 failed 2."
}

# Test 8

#lui $1, 0x00001001
#ori $13, $1,0x00000020
#addi $9, $0,-45
#clo, $10,$9
#sw $10, 0($13)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {3C011001}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {342D0020}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {2009FFD3}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {71205021}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {ADAA0000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 1000 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x0000001A} {
	puts "Test 8 passed."
} else {
	puts "Test 8 failed."
}

# Test 9

#lui $1, 0x00001001
#ori $3, $0, 0xFF0F
#sw $3, 32($1)
#ori $5, $0, 0xBBBB
#sll $0,$0,0
#lw $2, 32($1)
#and $4, $2,$5
#sw $4, 36($1)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {3C011001}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {3403FF0F}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {AC230020}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {3405BBBB}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {8C220020}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00452024}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {AC240024}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 1000 ns


if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x0000ff0f} {
	puts "Test 9 passed 1."
} else {
	puts "Test 9 failed 1."
}


if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[9]}] == 0x0000bb0b} {
	puts "Test 9 passed 2."
} else {
	puts "Test 9 failed 2."
}

# Test 10

#addi $11, $0, -3
#bltzal $11,B_GO
#sll $0, $0, 0
#j EXIT
#sll $0, $0, 0
#B_GO: jr $31
#sll $0, $0, 0
#EXIT: sw $31, 32($zero)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {200BFFFD}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {05700003}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {08000007}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {03E00008}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {AC1F0020}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 1000 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x00000008} {
	puts "Test 10 passed."
} else {
	puts "Test 10 failed."
}




# Test 11

#ori $1, $0, 65535
#ori $2, $0, 65535
#multu $1, $2
#mflo $3
#mfhi $4
#sw $3, 44($0)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {3401FFFF}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {3402FFFF}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {00220019}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {00001812}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00002010}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {AC03002C}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 1000 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[11]}] == 0xFFFE0001} {
	puts "Test 11 passed."
} else {
	puts "Test 11 failed."
}


# Test 12

#ori $1, $0, 65535
#sll $1, $1, 16
#ori $2, $0, 65535
#sll $2, $2, 16
#multu $1, $2
#mflo $3
#mfhi $4
#sw $4, 44($0)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {3401FFFF}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {00010C00}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {3402FFFF}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {00021400}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00220019}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {00001812}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00002010}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {AC04002C}

#give a reset signal
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 1000 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[11]}] == 0xFFFE0001} {
	puts "Test 12 passed."
} else {
	puts "Test 12 failed."
}
