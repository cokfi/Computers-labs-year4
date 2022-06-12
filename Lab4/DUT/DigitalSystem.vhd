LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
ENTITY DigitalSystem IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT (  Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- Changed ALUFN from 3 to 5
		  ALUout: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag,Cflag,Zflag: OUT STD_LOGIC ); -- Zflag,Cflag,Nflag
END DigitalSystem;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF DigitalSystem IS 
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
