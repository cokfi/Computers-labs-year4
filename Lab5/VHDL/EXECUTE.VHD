----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Ron Tal and Kfir Cohen
-- 
-- Create Date:  26/06/22 
-- Design Name:  MIPS
-- Module Name:  
-- Project Name: LAB5 - CPU
-- Target Devices: FPGA altera
-- Tool versions: 
-- Description:  Execute module, implements the ALU, arithmetic logic unit including the Branch Address computation  
--  for the MIPS cpu.
-- Spec:		https://github.com/cokfi/Computers-labs-year4/tree/main/Lab5			
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------	


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  execute IS
	PORT(	Read_data_1 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- data from register R[Ra]
			Read_data_2 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- data from register R[Rb]
			Sign_extend 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Function_opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALUoperation  			: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- selector from control unit 
			ALUSrc 					: IN 	STD_LOGIC; 						-- selector from control unit
			PC_plus_4 				: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			clock, reset			: IN 	STD_LOGIC; 
			isBranchConditionTrue 	: OUT	STD_LOGIC;
			Jr_ctl					: OUT	STD_LOGIC; 						-- jump register - control
			Jr_Address				: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );	-- jump register - address		
			ALUresult 				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0);
			branchAddressResult 	: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 ) 	-- address result for branch 
			);
END execute;

ARCHITECTURE behavior OF execute IS

-----------------------------------------------
-- signals declaration
-----------------------------------------------
SIGNAL Ainput, Binput 							 : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALUpreliminaryOutput						 : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
signal multiplicationBeforeCut      			 : STD_LOGIC_VECTOR( 63 DOWNTO 0 ); -- multiplication result before cutting the vector to 32 bits
SIGNAL BranchAddress 			                 : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL ALUctl									 : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL bneCondition,beqCondition				 : STD_LOGIC;
signal isALUoutputZero							 : STD_LOGIC;
Alias  shamt                					 : STD_LOGIC_VECTOR(4 downto 0) is Sign_extend(10 downto 6);


BEGIN

-----------------------------------------------
-- operands assignment and mux
-----------------------------------------------	
	Ainput <= Read_data_1;
	isALUoutputZero <= '1' when ALUpreliminaryOutput = x"00000000"  else '0' ; --elementwise nor changed because of quartus

BinputMux:	Binput <= Read_data_2 when  ALUSrc = '0' 
  			ELSE  Sign_extend( 31 downto 0 ); -- immadiate or Lw (load word)

						
-----------------------------------------------
-- Generate branch control
-----------------------------------------------		
	bneCondition <= not(isALUoutputZero) 	when ALUoperation = "11010" ELSE '0' ;--branch not equal condition;
	beqCondition <= isALUoutputZero 		when ALUoperation =	"10101" ELSE '0' ; --branch equal condition;
						-- Generate branch condition
	isBranchConditionTrue <=  bneCondition or beqCondition;
-----------------------------------------------
-- Generate Jr Flag and Address
-----------------------------------------------	  

	Jr_ctl <= '1' 
		WHEN ALUoperation = "01001" --when the operation is jr
		ELSE '0';
		
	Jr_Address <= ALUpreliminaryOutput(9 DOWNTO 2);   		
-----------------------------------------------
-- mux: Select ALUresult
-----------------------------------------------	

ALUresultMux: with ALUoperation select
 	ALUresult <= 	X"0000000" & B"000"  & ALUpreliminaryOutput( 31 ) when "01011", -- when the operation is slt
					X"0000000" & B"000"  & ALUpreliminaryOutput( 31 ) when "10110", -- when the operation is slti
					X"00000"&B"00"&PC_plus_4 						  when "10100", -- when the operation is jal		
					ALUpreliminaryOutput( 31 DOWNTO 0 )				  when others;
-----------------------------------------------
-- mux: Select ALUctl 
-----------------------------------------------

ALUctlMux: with ALUoperation select
	ALUctl    <=	"0010" when "01111", -- mul (multiplication)
					"0000" when "00000", -- shift left, sll
					"0001" when "00001", -- shift right, srl
					"0010" when "00010", -- X unused operation X : mult (mul is the right operation for multiplication)
					"0011" when "00011", -- adder for ADD 
					"0011" when "01000", -- adder for move
					"0011" when "01001", -- adder for jr ($ra +$0)
					"0011" when "10000", -- adder for addi (add immadiate)
					"0011" when "10001", -- adder for lw (load word)
					"0011" when "10010", -- adder for sw (store word)
					"0011" when "10011", -- adder for j (jump)
					"0011" when "10100", -- adder for jal (jump and link) 
					"0100" when "01010", -- subtractor for Sub
					"0100" when "01011", -- subtractor for slt
					"0100" when "10101", -- subtractor for beq (branch equal)
					"0100" when "10110", -- subtractor for slti (set less than immadiate)
					"0101" when "01100", -- AND for and
					"0101" when "10111", -- AND for andi (and immadiate)  
					"0110" when "01101", -- OR for or
					"0110" when "11000", -- OR for ori (or immadiate)
					"0111" when "01110",-- XOR for xor
					"0111" when "11001",-- XOR for xori (xor immadiate)
					"0111" when "11010",-- XOR for bne (branch not equal)
					"1000" when "11011",-- Lui (load upper immadiate)
					"1111" when others; -- unexpected error
								  
-----------------------------------------------
-- Adder to compute Branch Address
-----------------------------------------------
						
	BranchAddress				<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
	branchAddressResult 	<= BranchAddress( 7 DOWNTO 0 );

-----------------------------------------------
-- ALU multiplication
-----------------------------------------------	

	multiplicationBeforeCut <= Ainput*Binput;

-----------------------------------------------
-- ALU's heart
-----------------------------------------------		
PROCESS ( ALUctl, Ainput, Binput, shamt, multiplicationBeforeCut )
	BEGIN
					-- Select ALU operation
 	CASE ALUctl IS
						-- ALU performs shift left, sll
		WHEN "0000" 	=>	ALUpreliminaryOutput 	<= std_logic_vector(SHL(unsigned(Binput),unsigned(shamt))); -- shift left shamt times
						-- ALU performs Shift right, srl
		WHEN "0001" 	=>	ALUpreliminaryOutput 	<= std_logic_vector(SHR(unsigned(Binput),unsigned(shamt))); -- shift right shamt times
						-- ALU performs mult
	 	WHEN "0010" 	=>	ALUpreliminaryOutput 	<= multiplicationBeforeCut(31 downto 0);
						-- ALU performs add, add/move/jal
 	 	WHEN "0011" 	=>	ALUpreliminaryOutput 	<= Ainput + Binput;
						-- ALU performs sub, sub/slt/slti/beq
 	 	WHEN "0100" 	=>	ALUpreliminaryOutput 	<= Ainput - Binput;
						-- ALU performs AND, and/andi
 	 	WHEN "0101" 	=>	ALUpreliminaryOutput 	<= Ainput AND Binput; 
						-- ALU performs OR, or/ori
 	 	WHEN "0110" 	=>	ALUpreliminaryOutput 	<= Ainput OR Binput;
						-- ALU performs XOR, xor/xori/bne
 	 	WHEN "0111" 	=>	ALUpreliminaryOutput 	<= Ainput XOR Binput;
						-- ALU performs lui, lui
  	 	WHEN "1000" 	=>	ALUpreliminaryOutput 	<= std_logic_vector(SHL(unsigned(Binput),unsigned'(X"10"))) ;-- shift left 16 times

 	 	WHEN OTHERS	=>	ALUpreliminaryOutput 	<= X"00000000" ;
  	END CASE;
  END PROCESS;
  
END behavior;