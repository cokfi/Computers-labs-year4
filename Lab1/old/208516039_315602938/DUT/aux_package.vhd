library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
----------------------------Top--------------------------------
	component top is
	GENERIC (n : INTEGER := 8;
			 k : integer := 3;     -- k=log2(n)
		     m : integer := 4	); -- m=2^(k-1)
	PORT (  Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag,Cflag,Zflag: OUT STD_LOGIC ); -- Zflag,Cflag,Nflag
	end component;
-------------------------FullAdder-----------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
--------------------------Shifter------------------------------	
	component Shifter is
	GENERIC	(n : INTEGER := 8;
			 k : integer := 3);     -- k=log2(n)
	PORT (   shiftLorR: IN STD_LOGIC; -- decide wether shifting left or right , left=0 ;right=1
			 y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); 
			 x: IN STD_LOGIC_VECTOR (k-1 DOWNTO 0); -- number of shifts
             y_shifted: OUT STD_LOGIC_VECTOR(n-1 downto 0); -- Result
			 cout: OUT STD_LOGIC); -- carry out 
	end component;
---------------------------ALU---------------------------------
	component ALU is
	GENERIC (n : INTEGER := 8;
			 k : integer := 3);     -- k=log2(n)
	PORT (	 ALUFN: IN STD_LOGIC_VECTOR (4 DOWNTO 0); --2 MSB bits [1,dc]=Logical, [1,0]= shift, [0,0]= AdderSub.
			 logical,shifter,addersub: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
             Cin: in STD_LOGIC_VECTOR(1 downto 0); --carry in 
             ALUout: OUT STD_LOGIC_VECTOR(n-1 downto 0); -- Result
			 Zero,Neg,Carry: OUT STD_LOGIC -- Flags
        );
	end component;	
--------------------------Logical------------------------------
	component Logical is
	GENERIC (n : INTEGER := 8;
			 k : integer := 3);     -- k=log2(n)
	PORT (   ALUFN: IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- decide which module is used. Logical ALUFN= TOP ALUFN[2:1]
			 y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
             x: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
             result: OUT STD_LOGIC_VECTOR(n-1 downto 0)); -- Result
	end component;
-----------------------AdderSubtractor--------------------------
	component AdderSub is
	GENERIC (n : INTEGER := 8);
	PORT (    sctr: IN STD_LOGIC_VECTOR (1 downto 0); -- subtractor control , ADD = 0 , Sub=1
			x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
            cout: OUT STD_LOGIC;
            s: OUT STD_LOGIC_VECTOR(n-1 downto 0));
	end component;	
------------------------SingleShifter---------------------------
	component SingleShifter is
	GENERIC ( n : INTEGER := 8;
			shift : integer :=1);     -- k=log2(n)
	PORT (    shift_enable: IN STD_LOGIC; -- '1' to shift, '0' to keep the value 
			sctr_LorR : IN STD_LOGIC; -- decide wheter shifting left or right , left=0 ;right=1
			y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
            y_after: OUT STD_LOGIC_VECTOR(n-1 downto 0); -- Result
			s_cout: OUT STD_LOGIC); -- carry out output);
	end component;
-----------------------------------------------------------------

end aux_package;

