
----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Kfir Cohen
-- 
-- Create Date:  06/06/22 
-- Design Name:  sevenSigments
-- Module Name:  
-- Project Name: LAB4 - CPU
-- Target Devices: FPGA altera
-- Tool versions: 
-- Description: conversion of binary vector into seven segments display
-- note that seven segments is *STD_LOGIC_VECTOR (0 to 6)*
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------------
ENTITY sevenSegments IS
  PORT (	binaryVector	: IN	STD_LOGIC_VECTOR (3 DOWNTO 0);
			    sevenSegment	:	OUT STD_LOGIC_VECTOR (0 to 6) -- using to instead of downto in order to fix mirror visual
		); 
END sevenSegments;
------------- complete the top Architecture code --------------
ARCHITECTURE fle OF sevenSegments IS 

BEGIN
-----------------------------HEX SCREEN------------------------------------
sevenSig: process(binaryVector)
begin
    case binaryVector is
    when "0000" => sevenSegment <= "0000001"; -- "0"     
    when "0001" => sevenSegment <= "1001111"; -- "1" 
    when "0010" => sevenSegment <= "0010010"; -- "2" 
    when "0011" => sevenSegment <= "0000110"; -- "3" 
    when "0100" => sevenSegment <= "1001100"; -- "4" 
    when "0101" => sevenSegment <= "0100100"; -- "5" 
    when "0110" => sevenSegment <= "0100000"; -- "6" 
    when "0111" => sevenSegment <= "0001111"; -- "7" 
    when "1000" => sevenSegment <= "0000000"; -- "8"     
    when "1001" => sevenSegment <= "0000100"; -- "9" 
    when "1010" => sevenSegment <= "0000010"; -- a
    when "1011" => sevenSegment <= "1100000"; -- b
    when "1100" => sevenSegment <= "0110001"; -- C
    when "1101" => sevenSegment <= "1000010"; -- d
    when "1110" => sevenSegment <= "0110000"; -- E
    when others => sevenSegment <= "0111000"; -- F
    end case;
end process;
END fle;

