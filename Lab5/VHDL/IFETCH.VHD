-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
	PORT(	SIGNAL Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        	SIGNAL Branch 			: IN 	STD_LOGIC;
        	SIGNAL Zero 			: IN 	STD_LOGIC;
			SIGNAL Jump 			: IN 	STD_LOGIC;
			SIGNAL Jr	 			: IN 	STD_LOGIC;
			SIGNAL Jr_Address		: IN	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
      		SIGNAL PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL clock, reset 	: IN 	STD_LOGIC);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL Instruction_sig 						   : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL PC, PC_plus_4,Mem_Addr 			           : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL brOR4src,next_PC,Jump_Src : STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- brOR4src selected branch or pc+4 address
	Alias  Jump_Address                        : STD_LOGIC_VECTOR(7 downto 0) is Instruction_sig(7 downto 0);
BEGIN
						--ROM for Instruction Memory
inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => 10,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "program.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => clock,
		address_a 	=> Mem_Addr, 
		q_a 			=> Instruction_sig );
		
		
		Instruction <= Instruction_sig;
					-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
					-- copy output signals - allows read inside module
		PC_out 			<= PC;
		PC_plus_4_out 	<= PC_plus_4;
						-- send address to inst. memory address register
		Mem_Addr <= Next_PC&"00";
						-- Adder to increment PC by 4        
      	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
       	PC_plus_4( 1 DOWNTO 0 )  <= "00";
		
						-- Mux to select Branch Address or PC + 4        
		brOR4src  <=  Add_result  WHEN ( ( Branch = '1' ) AND ( Zero = '1' ) ) 
			ELSE   PC_plus_4( 9 DOWNTO 2 );
			
						-- Mux to select brOR4src or Jump Address
		Jump_Src  <=  Jump_Address  WHEN  Jump = '1'    
			ELSE   brOR4src ;
			
						-- Mux to select Jump_Src or Jr_Address
		Next_PC  <= X"00" WHEN Reset = '1' ELSE
					Jr_Address  WHEN  Jr = '1'    
			ELSE   Jump_Src ;	
			
			
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ; 
			ELSE 
				   PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;
	END PROCESS;
END behavior;


