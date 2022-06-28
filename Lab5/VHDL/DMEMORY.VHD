						--  Dmemory module (implements the data
						--  memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY dmemory IS
	generic(
		addressLength:	integer := 10  -- 10 for synthesis, 8 for simulation mode
	);
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	address 			: IN 	STD_LOGIC_VECTOR( addressLength DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset			: IN 	STD_LOGIC 
	);
END dmemory;

ARCHITECTURE behavior OF dmemory IS
SIGNAL write_clock : STD_LOGIC;
constant simulationfileAddress : String(1 to 61) := "C:\Users\kfir\Documents\VHDL\lab5\modelsim\Binary\dmemory.hex";
constant synthesisfileAddress : String(1 to 12) :=  "dmemory.hex";
BEGIN
-- data_memoryForSynthesis:   if simulationMode!=1 generate
-- 	dmemoryAddress		<= ALU_Result (9 DOWNTO 2)&"00"; --  memory address omission is 4 (word is 4 bytes)
-- end generate;
	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => addressLength,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => simulationfileAddress,
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => memwrite,
		clock0 => write_clock,
		address_a => address,
		data_a => write_data,
		q_a => read_data	);
-- Load memory address register with write clock
		write_clock <= NOT clock;
END behavior;

