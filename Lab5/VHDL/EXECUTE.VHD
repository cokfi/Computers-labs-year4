--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  Execute IS
	PORT(	Read_data_1 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Function_opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALUOp 					: IN 	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
			ALUSrc 					: IN 	STD_LOGIC;
			isBranchConditionTrue 	: OUT	STD_LOGIC;
			Mul						: IN 	STD_LOGIC;
			jal_c					: IN 	STD_LOGIC;
			Jr_ctl					: OUT	STD_LOGIC;
			Jr_Address				: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );			
			ALU_Result 				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Add_Result 				: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- address result for branch 
			PC_plus_4 				: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			clock, reset			: IN 	STD_LOGIC );
END Execute;

ARCHITECTURE behavior OF Execute IS
SIGNAL Ainput, Binput 							 : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux							 : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
signal mult_before_cut      					 : STD_LOGIC_VECTOR( 63 DOWNTO 0 );
SIGNAL Branch_Add 			                	 : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL ALU_ctl									 : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL ctl_in									 : STD_LOGIC_VECTOR( 8 DOWNTO 0 ); -- ALUop with function 
SIGNAL Adder,Sub,Or_result,And_result,Xor_result : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL bne_cond,beq_cond						 : STD_LOGIC;
signal isALUoutputZero							 : STD_LOGIC;
Alias shamt                						 : STD_LOGIC_VECTOR(4 downto 0) is Sign_extend(10 downto 6);
BEGIN


	Ainput <= Read_data_1;
	isALUoutputZero = and ALU_output_mux; --elementwise and
						-- ALU input mux
BinputMux:	Binput <= Read_data_2 
			WHEN ( ALUSrc = '0' ) 
  			ELSE  Sign_extend( 31 DOWNTO 0 );
						-- Generate ALU control bits
	ctl_in<= ALUOp&Function_opcode;
	
	bne_cond <= '0' when isALUoutputZero ELSE '1' ;--WHEN ALUop="011" ELSE '0';
	beq_cond <= '1' when isALUoutputZero ELSE '0' ; 
						-- Generate Zero Flag
	isBranchConditionTrue <=  bne_cond or beq_cond;  
						-- Generate Jr Flag and Address
	Jr_ctl <= '1' 
		WHEN ctl_in = "000001000" --when the operation is jr
		ELSE '0';
		
	Jr_Address <= ALU_output_mux(9 DOWNTO 2);   		
		
						-- Select ALU output        
	ALU_result <= 	X"0000000" & B"000"  & ALU_output_mux( 31 ) 
		WHEN  ctl_in = "000101010" -- when the operation is slt
		
		ELSE		X"0000000" & B"000"  & ALU_output_mux( 31 )
		WHEN  ALUOp = "111" -- when the operation is slti
		
		ELSE		X"00000"&B"00"&PC_plus_4		
		WHEN  ALUoperation="1001" -- when the operation is jal
		
		ELSE  	ALU_output_mux( 31 DOWNTO 0 );
		
						-- Select ALUctl TODO: make it readable/portable
	ALU_ctl    <=	"0010" WHEN  Mul = '1'			  -- mul
	ELSE "0000" WHEN  ctl_in = "000000000" 			  -- shift left
	ELSE "0001" WHEN  ctl_in = "000000010" 			  -- shift right
	ELSE "0010" WHEN  ctl_in = "000011000"			  -- mult
	ELSE "0011" WHEN  ctl_in = "000100000"			  -- ADDER for ADD 
	ELSE "0011" WHEN  ctl_in = "000100001"			  -- ADDER for MOVE
	ELSE "0011" WHEN  ctl_in = "000001000"			  -- ADDER for jr ($ra +$0)
	ELSE "0011" WHEN  ALUOp = "001"			  		  -- ADDER for addi/lw/sw/j
	ELSE "0100" WHEN  ctl_in = "000100010"			  -- SUB for Sub
	ELSE "0100" WHEN  ctl_in = "000101010"			  -- SUB for Slt	
	ELSE "0100" WHEN  ALUOp = "010"			  		  -- SUB for Beq
	ELSE "0100" WHEN  ALUOp = "111"			  		  -- SUB for Slti
	ELSE "0101" WHEN  ctl_in = "000100100"			  -- AND for And
	ELSE "0101" WHEN  ALUOp = "110"			  		  -- AND for Andi
	ELSE "0110" WHEN  ctl_in = "000100101"			  -- OR for Or
	ELSE "0110" WHEN  ALUOp = "101"			          -- OR for Ori	
	ELSE "0111" WHEN  ctl_in = "000100110"			  -- XOR for Xor
	ELSE "0111" WHEN  ALUOp = "011"			  		  -- XOR for xori/bne
	ELSE "1000" WHEN  ALUOp = "100"				      -- Lui
	ELSE "1111";									  -- unexpected error
	
						-- Adder to compute Branch Address
	Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
	Add_result 	<= Branch_Add( 7 DOWNTO 0 );
		
						-- calculate ALU mult	
	mult_before_cut <= Ainput*Binput;
	
PROCESS ( ALU_ctl, Ainput, Binput )
	BEGIN
					-- Select ALU operation
 	CASE ALU_ctl IS
						-- ALU performs shift left, sll
		WHEN "0000" 	=>	ALU_output_mux 	<= std_logic_vector(SHL(unsigned(Binput),unsigned(shamt))); -- shift left shamt times
						-- ALU performs Shift right, srl
		WHEN "0001" 	=>	ALU_output_mux 	<= std_logic_vector(SHR(unsigned(Binput),unsigned(shamt))); -- shift right shamt times
						-- ALU performs mult
	 	WHEN "0010" 	=>	ALU_output_mux 	<= mult_before_cut(31 downto 0);
						-- ALU performs add, add/move
 	 	WHEN "0011" 	=>	ALU_output_mux <= Ainput + Binput;
						-- ALU performs sub, sub/slt/slti/beq
 	 	WHEN "0100" 	=>	ALU_output_mux 	<= Ainput - Binput;
						-- ALU performs AND, and/andi
 	 	WHEN "0101" 	=>	ALU_output_mux 	<= Ainput AND Binput; 
						-- ALU performs OR, or/ori
 	 	WHEN "0110" 	=>	ALU_output_mux 	<= Ainput OR Binput;
						-- ALU performs XOR, xor/xori/bne
 	 	WHEN "0111" 	=>	ALU_output_mux 	<= Ainput XOR Binput;
						-- ALU performs lui, lui
  	 	WHEN "1000" 	=>	ALU_output_mux 	<= std_logic_vector(SHL(unsigned(Binput),unsigned'(X"10"))) ;-- shift left 16 times

 	 	WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
  	END CASE;
  END PROCESS;
  

END behavior;

