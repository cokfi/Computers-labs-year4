LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
-----------Shifter- Based on Barrel Shifter------------------- 
ENTITY Shifter IS
  GENERIC (	n : INTEGER := 8;
			k : integer := 3);     -- k=log2(n)
  PORT (    shiftLorR: IN STD_LOGIC; -- -- decide wether shifting left or right , left=0 ;right=1
			y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
			x: IN STD_LOGIC_VECTOR (k-1 DOWNTO 0); -- Input
            y_shifted: OUT STD_LOGIC_VECTOR(n-1 downto 0); -- Result
			cout: OUT STD_LOGIC); -- carry out output
END Shifter;
--------------------------------------------------------------
ARCHITECTURE dfl OF Shifter IS

type mem1 is array (0 to k-2) of std_logic_vector (n-1 downto 0);
type mem2 is array (0 to 1) of std_logic_vector (k-1 downto 0);
signal reg : mem1;--
signal carry_reg : mem2;

BEGIN		
---------------------SingleShift----------------------------	
	first: SingleShifter generic map(n,shift=>1)port map(
				y => y,
				shift_enable => x(0),
				sctr_LorR => shiftLorR,
				y_after => reg(0),
				s_cout => carry_reg(0)(0)
			);
	carry_reg(1)(0) <= carry_reg(0)(0);
---------------------2 to 2^(k-2) Shifters------------------	
	middle_f: for i in 1 to k-2 generate
	middle:		SingleShifter generic map(n,shift=>2**i)port map(
			y => reg(i-1),
			shift_enable => x(i),
			sctr_LorR => shiftLorR,
			y_after => reg(i),
			s_cout => carry_reg(0)(i)
			);
			carry_reg(1)(i) <= carry_reg(0)(i)or(not(x(i))and carry_reg(1)(i-1)); -- save msb carry
			end generate;
--------------------- 2^(k-1) Shifter--------------------	
	last:	SingleShifter generic map(n,shift=>2**(k-1))port map(
			y => reg(k-2),
			shift_enable => x(k-1),
			sctr_LorR => shiftLorR,
			y_after =>y_shifted ,
			s_cout => carry_reg(0)(k-1)
			);		
	cout<= carry_reg(0)(k-1)or(not(x(k-1))and carry_reg(1)(k-2));-- save msb carry
	end dfl;





