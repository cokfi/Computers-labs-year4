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

	SIGNAL Y,X:  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL ALUFN :  STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL ALUout:  STD_LOGIC_VECTOR(n-1 downto 0); -- ALUout[n-1:0]&Cflag
	SIGNAL Nflag,Cflag,Zflag:  STD_LOGIC; -- Zflag,Cflag,Nflag

begin
	L0 : top generic map (n,k,m) port map(Y,X,ALUFN,ALUout,Nflag,Cflag,Zflag);
    
--------- start of stimulus section -----------------------------------		
    tb_x_y : process
        begin
		  y <= (others => '0');
		  x <= (others => '1');
---------Adder------------------------------------------------------	  
		  for i in 0 to 1 loop-- expecting all bits 1 
			wait for 25 ns;
			x <= x-(m);
			y <= y+(m);
		  end loop;
		  wait for 25 ns;
		  y <= (others => '0');-- checking Zflag
		  x <= (others => '0');
		  --for i in 0 to 1 loop-- expecting y*2
		--	wait for 25 ns;
		--	x <= x+m;
		--	y <= y+m;
		-- end loop;  
		  wait for 25 ns;
---------Subtractor------------------------------------------------------
		  y <= ((k-1)=> '1',others => '0'); -- keep value
		  x <= (others => '0');	
		  for i in 0 to 1 loop-- insert 2's complement values 
			wait for 25 ns;
			x <= x+m;
			y <= y-m;-- check negative second iteration
		  end loop;
		  wait for 25 ns;
		  y <= (others => '0'); -- zero
		  x <= (others => '0');		
		  wait for 25 ns;
---------Shifter------------------------------------------------------
		y <= (0=>'1',(n-1) =>'1',others =>'0');
		y_loop : for i in 0 to 1 loop
		x <= (others =>'0');
		wait for 25 ns;
		x <=x+1;--carry
		wait for 25 ns;
		x <=x+1;--no carry
		wait for 50 ns;
		end loop;
---------Logical------------------------------------------------------
		y<= (0=>'1',(n-1)=>'1',others=>'0');
		x <= (0=>'0',(n-1)=>'0',others=>'1');
		wait;
	end process;
---------ALUFN process--------------------------------------------------------
	tb_ALUFN : process
        begin
		  ALUFN <= (others => '0');
		  for i in 0 to 3 loop-- AdderSub+Shifter
			wait for 100 ns;
			ALUFN <= ALUFN+1;
		  end loop;
		  for i in 0 to 2 loop-- logical
			wait for 25 ns;
			ALUFN <= ALUFN+1;
		  end loop;
		  wait;
    end process;
  
end architecture rtb;
