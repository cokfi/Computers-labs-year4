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
		addressLength:	integer := 10;   -- 10 for synthesis, 8 for simulation mode
		simulationMode:	integer := 0	-- 0 for synthesis, 1 for simulation mode
	);
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	address 			: IN 	STD_LOGIC_VECTOR( addressLength-1 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset			: IN 	STD_LOGIC 
	);
END dmemory;

ARCHITECTURE behavior OF dmemory IS
-----------------------------------------------
-- signal declaration
-----------------------------------------------	
SIGNAL write_clock : STD_LOGIC;
-----------------------------------------------
-- string declaration & definition
-----------------------------------------------	
constant simulationfileAddress : String(1 to 61) := "C:\Users\kfir\Documents\VHDL\lab5\modelsim\Binary\dmemory.hex";
constant synthesisfileAddress : String(1 to 11) :=  "dmemory.hex";


BEGIN
-----------------------------------------------
-- generate memory for synthesis
-----------------------------------------------	
synthesisGenerateMemory:   if simulationMode =0 generate
	data_memoryForSynthesis: altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => addressLength,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => synthesisfileAddress, -- different from simulation
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => memwrite,
		clock0 => write_clock,
		address_a => address,
		data_a => write_data,
		q_a => read_data	);

 end generate;
-----------------------------------------------
-- generate memory for simulation
-----------------------------------------------	
simulationGenerateMemory:   if simulationMode=1 generate
	data_memoryForsimulation: altsyncram
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

	end generate;

-----------------------------------------------
-- generate write clock: Load memory address register with write clock
-----------------------------------------------	
		write_clock <= NOT clock;

END behavior;

