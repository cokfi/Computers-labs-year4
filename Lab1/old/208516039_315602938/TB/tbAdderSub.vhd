library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tb_AddSub is
constant n : integer := 8;
constant k : integer := 3;   -- k=log2(n)
end tb_AddSub;

architecture rtb of tb_AddSub is
	SIGNAL sctr,cout : STD_LOGIC;
	SIGNAL y,x,s : STD_LOGIC_VECTOR ((n-1) DOWNTO 0);
begin
	L0 : AdderSub generic map (n)port map(sctr,x,y,cout,s);
--------- start of stimulus section -----------------------------------		
        tb_x_y : process
        begin
		  y <= (others => '0');
		  x <= (others => '1');
---------add loop------------------------------------------------------	  
		  for i in 0 to 4 loop-- expecting all bits 1 
			wait for 50 ns;
			x <= x-(k-1);
			y <= y+(k-1);
		  end loop;
		  y <= (others => '0');
		  x <= (others => '0');
		  for i in 0 to 4 loop-- expecting y*2
			wait for 50 ns;
			x <= x+(k-1);
			y <= y+(k-1);
		  end loop;  
---------Sub loop------------------------------------------------------
		  y <= (others => '0');
		  x <= (others => '0');	
		  wait for 50 ns;
		  y <= (n-1=> '0',others => '1');
		  x <= (others => '0');	
		  for i in 0 to 5 loop-- insert 2's complement values 
			wait for 50 ns;
			x <= x+2*(k-1);
			y <= y-2*(k-1);
		  end loop;	
		  wait;
        end process;
---------Sub or Add------------------------------------------------------		
  		Sub_or_Add : process
        begin
		  sctr <= '0';
			wait for 500 ns;
			sctr <= '1';
		  wait;
        end process;
end architecture rtb;