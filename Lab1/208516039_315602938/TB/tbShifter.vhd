library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_Shifter is
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
end tb_Shifter;
architecture rtb of tb_Shifter is

	SIGNAL y,y_shifted:  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	signal x : STD_LOGIC_VECTOR (k-1 DOWNTO 0);
	SIGNAL shiftLorR,cout :  STD_LOGIC;
	
    begin
    L0 : Shifter generic map (n,k) port map(shiftLorR,y,x,y_shifted,cout);
---------------------------------------------------------
	yx_change : process --this is a test for shift_enable and sctr_LorR
	begin 
	shiftLorR <= '0';
	x <= (others =>'0');
	y <= (0=>'1',(n-1) =>'1',others =>'0');
	y_loop : for i in 0 to n-1 loop
		wait for 10 ns;
		shiftLorR <= not(shiftLorR);
		wait for 10 ns;
		x <=x+1;
		end loop;
		wait;
	end process yx_change;
---------------------------------------------------------
	
---------------------------------------------------------
	end architecture rtb;

