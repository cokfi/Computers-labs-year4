----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Ron Tal and Kfir Cohen
--
-- Create Date:  22/05/22 
-- Design Name:  Adder
-- Module Name:  Adder and Subtractor - Behavioral 
-- Project Name: LAB3 - CPU
-- Target Devices: 
-- Tool versions:
-- Description: adder and subtractor depend on the carry in bit, if '0' preforms a+b if '1' preforms a-b
--
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
-------------------------------------
ENTITY Adder IS
  GENERIC (length : INTEGER := 16);
  PORT ( a, bPreXor: IN STD_LOGIC_VECTOR (length-1 DOWNTO 0);
          cin: IN STD_LOGIC;
            s: OUT STD_LOGIC_VECTOR (length-1 DOWNTO 0);
         cout: OUT STD_LOGIC);
END Adder;
------------------------------------------------
ARCHITECTURE bhv OF Adder IS
signal b : STD_LOGIC_VECTOR (length-1 DOWNTO 0);
signal carry : STD_LOGIC_VECTOR (length DOWNTO 0);
BEGIN
  carry(0) <= cin;

  generateB: FOR i IN 0 TO length-1 GENERATE
    b(i) <= bPreXor(i) xor cin;
  END generate generateB;

  generateCarry: FOR i IN 0 TO length-1 GENERATE
    carry(i+1) <= (a(i) AND b(i)) OR (a(i) AND
    carry(i)) OR (b(i) AND carry(i)); -- incase at least 2 of the entries contain '1' carry(i+1) <= '1'
  end GENERATE generateCarry;  

  generateResult: FOR i IN 0 TO length-1 GENERATE
    s(i) <= a(i) XOR b(i) XOR carry(i); -- a(i)+b(i)+c(i) modulo 2
  end GENERATE generateResult;
  
  cout <= carry(length);
END bhv;

