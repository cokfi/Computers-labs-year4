-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
	generic(
		addressLength:	integer := 10;   -- 10 for synthesis, 8 for simulation mode
		simulationMode:	integer := 0	-- 0 for synthesis, 1 for simulation mode
	);
	PORT(	
			SIGNAL clock, reset 	: IN 	STD_LOGIC;
			SIGNAL Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- branch address result
        	SIGNAL Branch 			: IN 	STD_LOGIC;
        	SIGNAL isBranchConditionTrue : IN 	STD_LOGIC;
			SIGNAL Jump 			: IN 	STD_LOGIC;
			SIGNAL Jr	 			: IN 	STD_LOGIC;
			SIGNAL Jr_Address		: IN	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			SIGNAL Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
      		SIGNAL PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 )
        	);
END Ifetch;
-----------------------------------------------
-- signals declaration
-----------------------------------------------
ARCHITECTURE behavior OF Ifetch IS
	SIGNAL Instruction_sig 						   : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL PC, PC_plus_4 			           : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL next_PC : STD_LOGIC_VECTOR( 7 DOWNTO 0 ); 
	SIGNAL Mem_Addr : STD_LOGIC_VECTOR( addressLength-1 DOWNTO 0 ); 
	Alias  Jump_Address                        : STD_LOGIC_VECTOR(7 downto 0) is Instruction_sig(7 downto 0);
BEGIN
						
-----------------------------------------------
-- instantiation of program memory (ROM for Instruction Memory)
-----------------------------------------------
-----------------------------------------------
--for simulation
-----------------------------------------------	
simulationGeneratePM:   if simulationMode=1 generate
	instProgramMemory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => addressLength, -- 8
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\Users\kfir\Documents\VHDL\lab5\modelsim\Binary\program.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => clock,
		address_a 	=> Mem_Addr, 
		q_a 			=> Instruction_sig );
end generate;
-----------------------------------------------
--for synthesis
-----------------------------------------------	
synthesisGenerateMemory:   if simulationMode =0 generate
	data_memoryForSynthesis: altsyncram

	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => addressLength, --10
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "program.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => clock,
		address_a 	=> Mem_Addr, 
		q_a 			=> Instruction_sig );
end generate;
		
-----------------------------------------------
-- assignments
-----------------------------------------------		
		Instruction <= Instruction_sig;
					-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
					-- copy output signals - allows read inside module
		PC_out 			<= PC;
		PC_plus_4_out 	<= PC_plus_4;
					       		

					-- send address to inst. memory address register
-----------------------------------------------
--for simulation
-----------------------------------------------	
simulationReadAddress:	if simulationMode =1 generate
		Mem_Addr <= Next_PC;
	end generate;
-----------------------------------------------
--for synthesis
-----------------------------------------------	
synthesisReadAddress:	if simulationMode =0 generate
		Mem_Addr <= Next_PC&"00";
	end generate;

-----------------------------------------------
-- Adder to increment PC by 4 
-----------------------------------------------	
		PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
		PC_plus_4( 1 DOWNTO 0 )  <= "00";					       

-----------------------------------------------
-- Mux: select next program counter
-----------------------------------------------				
nextPCmux:	Next_PC  <= X"00"	 		WHEN Reset = '1' ELSE
						Jr_Address	  	WHEN  Jr = '1'   ELSE 
						Jump_Address	when Jump = '1'  ELSE
						Add_result  	WHEN ( ( Branch = '1' ) AND ( isBranchConditionTrue = '1' )) ELSE
						PC_plus_4( 9 DOWNTO 2 );
			
-----------------------------------------------
-- register PC (program counter) -- rising edge
-----------------------------------------------			
PCregister:	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ; 
			ELSE 
				   PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;
	END PROCESS;

END behavior;


