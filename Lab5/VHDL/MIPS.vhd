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
-- Description: -- Top Level Structural Model for MIPS Processor Core
-- 				including shifter adder subtractor and bitwise opearions
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
USE work.aux_package.all;

ENTITY MIPS IS

	PORT( reset, clock					: IN 	STD_LOGIC; -- reset is opposite
		-- Output important signals to pins for easy display in Simulator
		PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ALU_result_out, read_data_1_out,
		read_data_2_out, write_data_out,	
     	Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out, isBranchConditionTrue_out,
		Memwrite_out, Regwrite_out		: OUT 	STD_LOGIC;
		LEDG				: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); --Green leds
		LEDR				: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); --Red leds
		HEX0				: OUT 	STD_LOGIC_VECTOR( 0 TO 6); 
		HEX1				: OUT 	STD_LOGIC_VECTOR( 0 TO 6); 
		HEX2				: OUT 	STD_LOGIC_VECTOR( 0 TO 6); 
		HEX3				: OUT 	STD_LOGIC_VECTOR( 0 TO 6); 
		SW					: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ) -- Switches		
		);
END 	MIPS;

ARCHITECTURE structure OF MIPS IS

-----------------------------------------------
-- signals declaration
-----------------------------------------------

	SIGNAL CLKout			: STD_LOGIC; -- with period 2*T_clock , the divider's output
	SIGNAL PC_plus_4 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUSrc 			: STD_LOGIC;
	SIGNAL Branch 			: STD_LOGIC;
	SIGNAL RegDst 			: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL isBranchConditionTrue: STD_LOGIC;
	SIGNAL Mul 				: STD_LOGIC; -- execute multiply
	SIGNAL jal_c 			: STD_LOGIC; -- execute multiply
	SIGNAL Jump 			: STD_LOGIC;
	SIGNAL Jr_ctl 			: STD_LOGIC;
	SIGNAL Jr_Address    	: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemWrite_4memory	: STD_LOGIC;  -- MemWrite AND not peripherial writing 
	SIGNAL MemRead_4memory	: STD_LOGIC;  -- MemRead AND not peripherial writing 
	SIGNAL MemtoReg 		: STD_LOGIC;
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL ALUoperation 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Peri_address		: STD_LOGIC_VECTOR( 3 DOWNTO 0 ); --[A11,A4,A3,A2]
	SIGNAL Data_Bus			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	signal real_reset 		: STD_LOGIC;

BEGIN
-----------------------------------------------
-- assignments
-----------------------------------------------
					-- copy important signals to output pins for easy 
					-- display in Simulator
   Instruction_out 	<= Instruction;
   ALU_result_out 	<= ALU_result;
   read_data_1_out 	<= read_data_1;
   read_data_2_out 	<= read_data_2;
   write_data_out  	<= read_data WHEN MemtoReg = '1' ELSE ALU_result;--"11111111111111111111111111111111";
   Branch_out 		<= Branch;
   isBranchConditionTrue_out 		<= isBranchConditionTrue;
   RegWrite_out 	<= RegWrite;
   MemWrite_out 	<= MemWrite;	
   Peri_address 	<= ALU_Result(11)&ALU_Result (4 DOWNTO 2); -- peripherial address
   real_reset		<= reset;
   MemWrite_4memory <= MemWrite and not(Peri_address(3)); -- Peri_address(3) = Address(11) means peripherial writing
   MemRead_4memory  <= MemRead and not(Peri_address(3)); -- Peri_address(3) = Address(11) means peripherial writing
  
					-- DATA BUS tristates
	DATA_BUS 		<= read_data_2 WHEN MemWrite = '1' 		  ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"; -- tristate write to memory with data_bus 
	DATA_BUS		<= read_data   WHEN MemRead_4memory = '1' ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"; -- tristate read from memory with data_bus
	
   
 -----------------------------------------------
-- instanciations
-----------------------------------------------  
					-- connect the 5 MIPS components   

  IFE : Ifetch
	PORT MAP (	Instruction 	=> Instruction,
    	    	PC_plus_4_out 	=> PC_plus_4,
				Add_result 		=> Add_result,
				Branch 			=> Branch,
				Jump     		=> Jump,
				Jr				=> Jr_ctl,
				Jr_Address		=> Jr_Address,
				isBranchConditionTrue 			=> isBranchConditionTrue,
				PC_out 			=> PC,        		
				clock 			=> CLKout,  
				reset 			=> real_reset );

   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1,
        		read_data_2 	=> read_data_2,
        		Instruction 	=> Instruction,
        		read_data 		=> DATA_BUS,
				ALU_result 		=> ALU_result,
				RegWrite 		=> RegWrite,
				MemtoReg 		=> MemtoReg,
				RegDst 			=> RegDst,
				Sign_extend 	=> Sign_extend,
        		clock 			=> CLKout,  
				reset 			=> real_reset );


   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction( 31 DOWNTO 26 ),
				Function_opcode => Instruction( 5 DOWNTO 0 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch,
				ALUoperation 	=> ALUoperation,
				Jump			=> Jump
			 );

   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1,
             	Read_data_2 	=> read_data_2,
				Sign_extend 	=> Sign_extend,
                Function_opcode	=> Instruction( 5 DOWNTO 0 ),
				ALUoperation 	=> ALUoperation,
				ALUSrc 			=> ALUSrc,
				isBranchConditionTrue => isBranchConditionTrue,
				Jr_ctl			=> Jr_ctl,
				Jr_Address		=> Jr_Address,
                ALUresult		=> ALU_Result,
				branchAddressResult	  => Add_Result,
				PC_plus_4		=> PC_plus_4,
                Clock			=> CLKout,
				Reset			=> real_reset );

   MEM:  dmemory
	PORT MAP (	read_data 		=> read_data,
				address 		=> ALU_Result (9 DOWNTO 2),-- jump memory address by 4
				write_data 		=> DATA_BUS,
				MemRead 		=> MemRead_4memory, 
				Memwrite 		=> MemWrite_4memory, 
                clock 			=> CLKout,  
				reset 			=> real_reset );
	
	PERI:  peripherial
	PORT MAP (	reset			=> real_reset,
				clock 			=> CLKout,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Address			=> Peri_address,
				Data			=> Data_Bus(7 downto 0),
				LEDG			=> LEDG,
				LEDR			=> LEDR,
				HEX0			=> HEX0,
				HEX1			=> HEX1,
				HEX2			=> HEX2,
				HEX3			=> HEX3,
				SW				=> SW);

	DIVI:  divider
	PORT MAP (  CLKin			=> clock,
				CLKout			=> CLKout);
END structure;
