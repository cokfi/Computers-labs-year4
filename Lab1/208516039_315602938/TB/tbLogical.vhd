library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
ENTITY tb_Logical IS
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
END tb_Logical;
---------------------------------------------------------
architecture rtb of tb_Logical is
---------------------------------------------------------
signal ALUFN : STD_LOGIC_VECTOR (1 DOWNTO 0);
signal x,y,result : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
---------------------------------------------------------
begin 
    L0: Logical generic map(n,k) port map(ALUFN,y,x,result);
Func_Change: process
        begin
		y<= (0=>'1',(n-1)=>'1',others=>'0');
		x <= (0=>'0',(n-1)=>'0',others=>'1');
        ALUFN <= (others => '0');
        loop2:for i in 0 to 3 loop
            wait for 20 ns;
            ALUFN <= ALUFN + 1;
        end loop;
        wait for 20 ns;
        ALUFN <= (others => '0');
        x <= y; 
        loop3:for i in 0 to 3 loop
            wait for 20 ns;
            ALUFN <= ALUFN + 1;
        end loop;
		wait;
        end process;
end architecture rtb;

