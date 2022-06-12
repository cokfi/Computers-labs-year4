LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
---------------------------------------------------------------
------------------- single shifter-----------------------------
--------------------------------------------------------------- 
ENTITY SingleShifter IS
GENERIC ( n : INTEGER := 8;
		  shift : integer :=1);     -- k=log2(n)
PORT (    shift_enable: IN STD_LOGIC; -- '1' to shift, '0' to keep the value 
		  sctr_LorR : IN STD_LOGIC; -- decide wheter shifting left or right , left=0 ;right=1
		  y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
		  y_after: OUT STD_LOGIC_VECTOR(n-1 downto 0); -- Result
		  s_cout: OUT STD_LOGIC); -- carry out
END SingleShifter;
--------------------------------------------------------------
ARCHITECTURE dfl2 OF SingleShifter IS

  signal mux_in1_vec: STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- vector with shift
BEGIN		
-----giving each output bit a mux 2to1:------------------------	
  f: for i in 0 to shift-1 generate -- from 0 to shift-1
		  mux_in1_vec(i) <= (sctr_LorR) and y(i+shift); -- shifting left or right according to ALUFN (LSB)
		  y_after(i)<=(y(i) and not(shift_enable)) or (mux_in1_vec(i) and shift_enable); -- mux 2_1, shift_enable = ctr
		  
  end generate;

  rest : for i in shift to n-shift-1 generate -- from shift to n-shift-1
	  mux_in1_vec(i) <=((sctr_LorR) and y(i+shift)) or (not(sctr_LorR) and y(i-shift)); -- shifting left or right according to ALUFN (rest)
	  y_after(i)<=(y(i) and not(shift_enable)) or (mux_in1_vec(i) and shift_enable); -- mux 2_1, shift_enable = ctr

  end generate;

  restish : for i in n-shift to n-1 generate -- from n-shit to n-1
	  mux_in1_vec(i) <=(not(sctr_LorR) and y(i-shift)); -- shifting left or right according to ALUFN (rest)
	  y_after(i)<=(y(i) and not(shift_enable)) or (mux_in1_vec(i) and shift_enable); -- mux 2_1, shift_enable = ctr

  end generate;
  
  s_cout <= ((y(n-shift) and not(sctr_LorR))or(y(shift-1) and sctr_LorR))and shift_enable  ; -- carry out from single shifter

END dfl2;
---------------------------------------------------------------
-------------------end of single shifter-----------------------
--------------------------------------------------------------- 
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





