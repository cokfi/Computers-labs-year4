----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Kfir Cohen
-- 
-- Create Date:  07/06/22 
-- Design Name:  tbTOP
-- Module Name:  
-- Project Name: LAB4 - CPU
-- Target Devices: modelsim
-- Tool versions: 
-- Description: TB for top entity of an arithemetic logic unit (ALU),
-- 				including shifter adder subtractor and bitwise opearions
-- Spec:		https://github.com/Tajoro/CompLabs/tree/main/Lab4/spec				
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_top is
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
end tb_top;
---------------------------------------------------------
architecture rtb of tb_top is
	signal clock, rst: 											STD_LOGIC;
	SIGNAL switches: 											STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL ALUFNredLeds9to5 :  									STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL NflagRedLed0,CflagRedLed1,ZflagRedLed2:  			STD_LOGIC; -- Zflag,Cflag,Nflag
	signal ALUoutGreenLeds: 	 								STD_LOGIC_VECTOR(n-1 downto 0);
	signal XvectorHex0,XvectorHex1,YvectorHex2,YvectorHex3:  	STD_LOGIC_VECTOR (6 DOWNTO 0);
	signal enableYkey0, enableALUFNkey1, enableXkey2: 			STD_LOGIC;
begin
	topInst : top generic map (n,k,m) 
		port map(clk 				=> clock,
				 rst				=>	rst,
				 switches			=>	switches,
				 enableYkey0		=>	enableYkey0,
				 enableALUFNkey1	=>	enableALUFNkey1,
				 enableXkey2		=>	enableXkey2,
				 XvectorHex0		=>	XvectorHex0,
				 XvectorHex1		=>	XvectorHex1,
				 YvectorHex2		=>	YvectorHex2,
				 YvectorHex3		=>	YvectorHex3,
				 ALUFNredLeds9to5	=>	ALUFNredLeds9to5,
				 ALUoutGreenLeds	=>	ALUoutGreenLeds,
				 NflagRedLed0		=>	NflagRedLed0,
				 CflagRedLed1		=>	CflagRedLed1,
				 ZflagRedLed2		=>	ZflagRedLed2
				 );
--------- start of stimulus section -----------------------------------	

---------------------------------clock---------------------------------
gen_clk : process
	begin
		clock <= '0';
		wait for 25 ns;
		clock <= not clock;
		wait for 25 ns;
	end process;
---------------------------------rst-----------------------------------
gen_rst : process
	begin
		rst <= '1';
		wait for 55 ns;
		rst <= not rst;
		wait;
	end process;
-------------------------switches+pushbuttons--------------------------
tb_x_y : process
	begin
		enableYkey0	<=	'1';
		enableALUFNkey1 <= '1';
		enableXkey2	<=	'1';
		switches	<=	(others => '0');
		wait for 100 ns;
		switches	<=	"01010101";
		wait for 100 ns;
		enableYkey0	<=	'0';
		wait for 100 ns;
		enableYkey0	<=	'1';
		wait for 100 ns;
		switches	<=	"10101010";
		wait for 100 ns;
		enableXkey2	<=	'0';
		wait for 100 ns;
		enableXkey2	<=	'1';
		wait for 100 ns;
		switches	<=	"11101000";
		wait for 100 ns;
		enableALUFNkey1	<=	'0';
		wait for 100 ns;
		enableALUFNkey1	<=	'1';
		wait;
	end process;
  
end architecture rtb;
