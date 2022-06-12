
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





