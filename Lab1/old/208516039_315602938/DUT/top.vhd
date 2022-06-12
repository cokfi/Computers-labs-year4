LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT (  Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- Changed ALUFN from 3 to 5
		  ALUout: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag,Cflag,Zflag: OUT STD_LOGIC ); -- Zflag,Cflag,Nflag
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 
type mem3 is array (0 to 2) of std_logic_vector (n-1 downto 0);
signal c_reg : STD_LOGIC_VECTOR (1 DOWNTO 0); -- carry from AdderSub&Shifter '0' <= AdderSub, '1' <= Shifter
signal result_reg : mem3; -- save the result of each operation

BEGIN
---------------------------------------------------------------
AdderSubaba : AdderSub generic map (n)port map(
			sctr => ALUFN(1 downto 0), --'1' SUB , '0' ADD
			x => X,
			y => Y,
			cout => c_reg(0),
			s => result_reg(0));	
---------------------------------------------------------------	
Shifteroko : Shifter generic map (n,k) port map(
			shiftLorR => ALUFN(0), --left=0 ;right=1
			x => X(k-1 downto 0),
			y => Y,
			cout => c_reg(1),
			y_shifted => result_reg(1));
---------------------------------------------------------------			
Logiloko : Logical generic map (n,k) port map(
			ALUFN => ALUFN(2 downto 0),
			x => X,
			y => Y,
			result => result_reg(2));	
---------------------------------------------------------------
ALUFORU  : ALU generic map (n,k) port map(
			ALUFN => ALUFN(4 downto 0), -- 2 MSB bits of ALUFN [1,1]=Logical, [1,0]= shift, [0,0]= AdderSub.
			logical => result_reg(2),
			shifter => result_reg(1),
			addersub => result_reg(0),
			Cin => c_reg, -- Cin(1) for shifter ,Cin(0) for AdderSub
			Zero => Zflag,
			Neg => Nflag,
			Carry => Cflag, 
			ALUout=>ALUout);

END struct;
----------------------------END OF top----------------------------------

------------------------------------------------------------------------
--------------------------------ALU-------------------------------------
------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
ENTITY ALU IS
  GENERIC ( n : INTEGER := 8;
			k : integer := 3);     -- k=log2(n)
  PORT (    ALUFN: IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- 2 MSB bits of ALUFN [1,1]=Logical, [1,0]= shift, [0,0]= AdderSub.
			logical,shifter,addersub: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
            Cin: in STD_LOGIC_VECTOR(1 downto 0);-- Cin(1) for shifter ,Cin(0) for AdderSub
            ALUout: OUT STD_LOGIC_VECTOR(n-1 downto 0); -- Result
			Zero,Neg,Carry: OUT STD_LOGIC); -- carry out output
END ALU;

ARCHITECTURE dfl OF ALU IS
signal reg_out:STD_LOGIC_VECTOR(n-1 downto 0); -- Result
signal zcheck:STD_LOGIC_VECTOR(n downto 0);-- zero register check, for n bit or
signal ALUFN_msb_plus_valid :STD_LOGIC_VECTOR(2 downto 0);--  (ALUFN(4),ALUFN(3),isValidALUFN )
begin
zcheck(0) <= '0';

isValidALUFN_mux: with ALUFN select -- 0 when ALUFN isn't valid
ALUFN_msb_plus_valid(0) <=  '1'  when "01000",
							'1'  when "01001",
							'1'  when "01010",
							'1'  when "10000",
							'1'  when "10001",
							'1'  when "11000", 
							'1'  when "11001", 
							'1'  when "11010", 
							'1'  when "11011", 
							'1'  when "11100", 
							'1'  when "11101", 
							'0'   when others; 
ALUFN_msb_plus_valid(2 downto 1) <= ALUFN(4)&ALUFN(3);

alu_output_mux: with ALUFN_msb_plus_valid select -- first 2 MSB [1,1]=Logical, [1,0]= shift, [0,0]= AdderSub.
	reg_out <=  addersub when "011",
				shifter  when "101",
				logical  when "111",
				unaffected when others; -- latch when others (spec demands)

elementwise_or_regout : for i in 0 to n-1 generate -- in vhdl 2008 we can write: or zcheck(0)<= or regout 
    zcheck(i+1) <= reg_out(i)or zcheck(i); -- n bit or.
end generate;

with ALUFN_msb_plus_valid select -- Cin(1) for shifter ,Cin(0) for AdderSub
	Carry <= Cin(0) when "011",
			 Cin(1) when "101",
			 '0' 	when "111", 
			 unaffected when others;

Zero <= not(zcheck(n));
Neg<= reg_out(n-1);
ALUout <= reg_out;

end dfl;

