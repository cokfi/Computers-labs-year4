
----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Kfir Cohen
-- 
-- Create Date:  27/06/22 
-- Design Name:  secondpipe
-- Module Name:  
-- Project Name: LAB5 - CPU
-- Target Devices: FPGA altera
-- Tool versions: 
-- Description: registers for pipeline cpu (between Fecth section to Decode section)
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
--------------------------------------------------------------
ENTITY secondpipe IS
  PORT (	instruction	        : IN  STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			    PCplus4	            :	IN  STD_LOGIC_VECTOR( 9  DOWNTO 0 );
          clock,reset         : IN  STD_LOGIC;
          delayedInstruction	: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			    delayedPCplus4	    :	OUT STD_LOGIC_VECTOR( 9  DOWNTO 0 )
		); 
END secondpipe;
ARCHITECTURE fle OF secondpipe IS 

BEGIN

-----------------------------------------------
--pipe instruction register
-----------------------------------------------
  pipe1InstructionRegInst: reg generic map (REGISTER_LENGTH => 32)
    port map(	clock			=>	clk,
          rst				    =>	rst,
          enable			  =>	'1',
          inputVector		=>	instruction,
          outputVector	=>	delayedInstruction
    );
-----------------------------------------------
--pipe PCplus4 register
-----------------------------------------------
  pipe1PCplus4RegInst: reg generic map (REGISTER_LENGTH => 10)
    port map(	clock			=>	clk,
          rst				    =>	rst,
          enable			  =>	'1',
          inputVector		=>	instruction,
          outputVector	=>	delayedInstruction
    );

END fle;

