----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Kfir Cohen
-- 
-- Create Date:  06/06/22 
-- Design Name:  register
-- Module Name:  
-- Project Name: general 
-- Target Devices: 
-- Tool versions: 
-- Description: An array of sync reset DFFs with enable 
-- 				
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY reg IS
	GENERIC(
		REGISTER_LENGTH : integer := 8
	);
	PORT (	clock,rst,enable: IN std_logic;
			inputVector		: IN std_logic_vector (REGISTER_LENGTH-1 downto 0);
			outputVector	: OUT std_logic_vector (REGISTER_LENGTH-1 downto 0)
	);
END reg;
--------------------------------------------------------
ARCHITECTURE dataflow OF reg IS
BEGIN

Reg: process(clock)
begin
	if (rst = '1') then
		outputVector <= (others =>'0');
	elsif(clock'event and clock = '1' and enable = '1') then	-- rising edge +enable
		outputVector <=	inputVector;
	end if;
end process;

END dataflow;

