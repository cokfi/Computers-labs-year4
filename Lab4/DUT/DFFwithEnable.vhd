----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Kfir Cohen
-- 
-- Create Date:  06/06/22 
-- Design Name:  DFF
-- Module Name:  
-- Project Name: general 
-- Target Devices: 
-- Tool versions: 
-- Description: A single sync reset DFF with enable 
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
ENTITY DFFwithEnable IS

	PORT (	clock,rst,enable: IN std_logic;
			inputBit		: IN std_logic;
			outputBit		: OUT std_logic
	);
END DFFwithEnable;
--------------------------------------------------------
ARCHITECTURE dataflow OF DFFwithEnable IS
BEGIN

DFF: process(clock)
begin
	if (rst = '1') then
		outputBit <= '0';
	elsif(clock'event and clock = '1' and enable = '1') then	-- rising edge +enable
		outputBit <=	inputBit;
	end if;
end process;

END dataflow;

