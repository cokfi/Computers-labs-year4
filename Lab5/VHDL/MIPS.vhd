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
--
-- Additional Comments:
-- *** There are four stages of pipe : ***
-- Fetch 	(instruction fetch)
-- Decode 	(decode instruction, read registers from registr file and generate control lines)
-- Execute 	(arithmetic operations by ALU)
-- Memory 	(write/read data from memory)
-- WB 		(write back to register file)
-- *** signals will have prefix according to their stage *** 
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
-- *** There are four stages of pipe : ***
-- Fetch 	(instruction fetch)
-- Decode 	(decode instruction, read registers from registr file and generate control lines)
-- Execute 	(arithmetic operations by ALU)
-- Memory 	(write/read data from memory)
-- WB 		(write back to register file)
-- *** signals will have prefix according to their stage ***

	SIGNAL CLKafterDivider	: STD_LOGIC; -- with period 2*T_clock , the divider's output
	SIGNAL FetchPC_plus_4 	: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL DecodePC_plus_4 	: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL ExecutePC_plus_4 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL DecodeDataFromRegisterA 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL DecodeDataFromRegisterB	 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ExecuteDataFromRegisterA 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ExecuteDataFromRegisterB 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL DecodeSign_Extend 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ExecuteSign_Extend 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	signal WBregisterAddress				: STD_LOGIC_VECTOR( 4  DOWNTO 0 );

	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL WriteBackALUresult: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL MemorydataFromMemoryToRegisterFile 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL WBdataFromMemoryToRegisterFile 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL DecodeALUSrc 	: STD_LOGIC;
	SIGNAL ExecuteALUSrc 	: STD_LOGIC;
	SIGNAL Branch 			: STD_LOGIC;
	SIGNAL DecodeRegDst 	: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL ExecuteRegDst 	: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL WBcontrolRegWrite: STD_LOGIC;
	SIGNAL DecodeRegWrite: STD_LOGIC;
	SIGNAL isBranchConditionTrue: STD_LOGIC;
	SIGNAL Jump 			: STD_LOGIC;
	SIGNAL Jr_ctl 			: STD_LOGIC;
	SIGNAL Jr_Address    	: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemWrite_4memory	: STD_LOGIC;  -- MemWrite AND not peripherial writing 
	SIGNAL MemRead_4memory	: STD_LOGIC;  -- MemRead  AND not peripherial writing 
	SIGNAL WbMemtoReg: STD_LOGIC;
	SIGNAL DecodeMemtoReg 	: STD_LOGIC;
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL ALUoperation 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL FetchInstruction : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL DecodeInstruction: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Peri_address		: STD_LOGIC_VECTOR( 3 DOWNTO 0 ); --[A11,A4,A3,A2]
	SIGNAL Data_Bus			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	signal real_reset 		: STD_LOGIC;

BEGIN
-----------------------------------------------
-- assignments
-----------------------------------------------
					-- copy important signals to output pins for easy 
					-- display in Simulator
   Instruction_out 	<= FetchInstruction;
   ALU_result_out 	<= ALU_result;
   read_data_1_out 	<= dataFromRegisterA;
   read_data_2_out 	<= dataFromRegisterB;
   Branch_out 		<= Branch;
   isBranchConditionTrue_out <= isBranchConditionTrue;
   RegWrite_out 	<= WbRegWrite;
   MemWrite_out 	<= MemWrite;	
   Peri_address 	<= ALU_Result(11)&ALU_Result (4 DOWNTO 2); -- peripherial address
   real_reset		<= reset;
   MemWrite_4memory <= MemWrite and not(Peri_address(3)); -- Peri_address(3) = Address(11) means peripherial writing
   MemRead_4memory  <= MemRead and not(Peri_address(3)); -- Peri_address(3) = Address(11) means peripherial writing
-----------------------------------------------
-- mux: reading data from memory/ALU (*unused signal*)
-----------------------------------------------		
	write_data_out  	<= WBdataFromMemoryToRegisterFile WHEN WbMemtoReg = '1' ELSE ALU_result;
-----------------------------------------------
-- DATA BUS tristates
-----------------------------------------------
					
					-- tristate write to memory with data_bus from register R[Rb]
	DATA_BUS 		<= dataFromRegisterB WHEN MemWrite = '1' 		  ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

					-- tristate read from memory with data_bus 
	--registerFileWriteData		<= WBdataFromMemoryToRegisterFile   WHEN MemRead_4memory = '1' ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"; 
	
-----------------------------------------------
-- Mux: select write register address with RegDst
-----------------------------------------------
					
muxWriteRegisterAddress:  write_register_address <=
write_register_address_1  	WHEN ExecuteRegDst = "01"  -- rs is chosen	
ELSE 	write_register_address_0 	WHEN ExecuteRegDst = "00"  -- rd is chosen				
ElSE 	B"11111";										-- $ra is chosen

-----------------------------------------------
-- instanciations
-----------------------------------------------  

   IFE : Ifetch
	PORT MAP (	Instruction 	=> FetchInstruction,
    	    	PC_plus_4_out 	=> FetchPC_plus_4,
				Add_result 		=> Add_result,
				Branch 			=> Branch,
				Jump     		=> Jump,
				Jr				=> Jr_ctl,
				Jr_Address		=> Jr_Address,
				isBranchConditionTrue => isBranchConditionTrue,
				PC_out 			=> PC,        		
				clock 			=> CLKafterDivider,  
				reset 			=> real_reset );

   FirstPipeInst: firstpipe
   PORT MAP (	Instruction 		=> FetchInstruction,
   				PCplus4 			=> FetchPC_plus_4,
				delayedInstruction	=> DecodeInstruction,
				delayedPCplus4		=> DecodePC_plus_4 --will be used at execute
				Clock				=> CLKafterDivider,
				reset				=> real_reset
   );

   ID : Idecode
   	PORT MAP (	read_data_1 	=> DecodeDataFromRegisterA,-- data from register R[Ra]
        		read_data_2 	=> DecodeDataFromRegisterB,-- data from register R[Rb]
        		Instruction 	=> DecodeInstruction, 
				WriteBackRegisterAddress => WBregisterAddress,-- TODO: add mux for WB reg address
        		read_data 		=> WBdataFromMemoryToRegisterFile,   	-- data for writing to register file
				ALU_result 		=> WriteBackALUresult,
				RegWrite 		=> WbRegWrite,
				MemtoReg 		=> WbMemtoReg,
				--RegDst 			=> RegDst,
				Sign_extend 	=> DecodeSign_extend,
        		clock 			=> CLKafterDivider,  
				reset 			=> real_reset 
	);

   CTL:   control
	PORT MAP ( 	Opcode 			=> DecodeInstruction( 31 DOWNTO 26 ),
				Function_opcode => DecodeInstruction( 5 DOWNTO 0 ),
				RegDst 			=> DecodeRegDst,
				ALUSrc 			=> DecodeALUSrc,
				MemtoReg 		=> DecodeMemtoReg,
				RegWrite 		=> DecodeRegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch,
				ALUoperation 	=> ALUoperation,
				Jump			=> Jump
			 );

   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> ExecuteDataFromRegisterA,
             	Read_data_2 	=> ExecuteDataFromRegisterB,
				Sign_extend 	=> ExecuteSign_extend,
                Function_opcode	=> Instruction( 5 DOWNTO 0 ),
				ALUoperation 	=> ALUoperation,
				ALUSrc 			=> ExecuteALUSrc,
				isBranchConditionTrue => isBranchConditionTrue,
				Jr_ctl			=> Jr_ctl,
				Jr_Address		=> Jr_Address,
                ALUresult		=> ALU_Result,
				branchAddressResult	  => Add_Result,
				PC_plus_4		=> ExecutePC_plus_4,
                Clock			=> CLKafterDivider,
				Reset			=> real_reset );

   MEM:  dmemory
	PORT MAP (	read_data 		=> dataFromMemoryToRegisterFile,
				address 		=> ALU_Result (9 DOWNTO 2),-- jump memory address by 4
				write_data 		=> dataFromRegisterB,
				MemRead 		=> MemRead_4memory, 
				Memwrite 		=> MemWrite_4memory, 
                clock 			=> CLKafterDivider,  
				reset 			=> real_reset );
	
	PERI:  peripherial
	PORT MAP (	reset			=> real_reset,
				clock 			=> CLKafterDivider,
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
				CLKout			=> CLKafterDivider);
END structure;
