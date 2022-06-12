----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Kfir Cohen
--
-- Create Date:  13/05/22 
-- Design Name:  ALU
-- Module Name:  Arithmetic Logic Unit - Behavioral 
-- Project Name: LAB3 - CPU
-- Target Devices: 
-- Tool versions:
-- Description: arithmetic logic unit for multicycle CPU
--
-- Dependencies:
-- 
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
USE work.aux_package.all;

ENTITY  ALU IS
generic( 	
			Dwidth: integer:=16
		);
PORT(		
			clk, rst			: in 		std_logic;
			Cin,Ain				: in 		std_logic; -- control
			ALUctl				: in 		std_logic; -- ALU operation	
			operandA,operandB	: in 		std_logic_vector(Dwidth-1 downto 0); --operands
			Zflag,Cflag,Nflag	: out		std_logic;  -- Zero, Carry, Negative
			ALUOut				: out 		std_logic_vector(Dwidth-1 downto 0)
			);
END ALU;

ARCHITECTURE behavior OF ALU IS
SIGNAL Ainput, Binput							 : STD_LOGIC_VECTOR( Dwidth-1 DOWNTO 0 );
signal regA,regC,regCout						 : STD_LOGIC_VECTOR( Dwidth-1 DOWNTO 0 );
signal adderSubResult							 : STD_LOGIC_VECTOR( Dwidth DOWNTO 0 ); -- the MSB is the carry
SIGNAL ALUResult							 	 : STD_LOGIC_VECTOR( Dwidth DOWNTO 0 );

BEGIN
-- component Adder IS
-- 	GENERIC (length : INTEGER := 8);
-- 	PORT ( a, bPreXor: IN STD_LOGIC_VECTOR (length-1 DOWNTO 0);
-- 		cin: IN STD_LOGIC;
-- 		s: OUT STD_LOGIC_VECTOR (length-1 DOWNTO 0);
-- 		cout: OUT STD_LOGIC);
-- END component;
	AdderSubtractorInst: Adder 
		generic map (length=>Dwidth) 
		port map  (
			a 		=> Ainput,
			bPreXor => Binput,
			cin 	=> ALUctl,
			s 		=> adderSubResult(Dwidth-1 DOWNTO 0),
			cout	=> adderSubResult(Dwidth) 
		);

	Ainput <= regA;
	Binput <= operandB; 
	ALUOut	<=	regCout;
	PROCESS ( ALUctl,adderSubResult) -- the process is portable for future operations (otherwise asignment would have done the same thing)
	BEGIN
					-- Select ALU operation
 	CASE ALUctl IS
						-- ALU performs add, add/move/nop
		WHEN '0' 	=>	ALUResult 	<= adderSubResult; -- addition

						-- ALU performs sub, (might be extended to sub/slt/slti/beq)
		WHEN '1' 	=>	ALUResult 	<= adderSubResult; -- subtraction

 	 	WHEN OTHERS	=>	ALUResult 	<= (others =>'0') ;
  	END CASE;
  	END PROCESS;

	regCProcess: Process(clk) -- master slave register
	begin
			if(rst='1') then
				regC	<=	(others=>'0');
			elsif (clk'event and clk='1' and Cin = '1') then --Rising Edge
				regC 	<=	ALUResult(Dwidth-1 downto 0);
			elsif (clk'event and clk='0') then --falling Edge
				regCout	<=	regC;
			end if;
	end process;
	
	regsFlagsProcess: Process(clk)
	begin
			if(rst='1') then
				Cflag 	<=	 '0';
				Zflag 	<=	 '0';
				Nflag 	<=	 '0';
			elsif (clk'event and clk='1'and Cin = '1') then 
				Cflag 	<=	 ALUResult(Dwidth);
				Zflag	<= 	 not(or(ALUResult(Dwidth-1 downto 0)));
				Nflag 	<=	 ALUResult(Dwidth-1);
			end if;
	end process;

	regAProcess: Process(clk)
	begin
			if(rst='1') then
				regA	<= 	(others=>'0');
			elsif (clk'event and clk='1' and Ain = '1') then 
				regA 	<=	operandA(Dwidth-1 downto 0);
			end if;
	end process;  

END behavior;

