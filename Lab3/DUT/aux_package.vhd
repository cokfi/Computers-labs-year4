LIBRARY ieee;
USE ieee.std_logic_1164.all;
package aux_package is
----------------------------TOP----------------------------------
component top is
	generic(	Dwidth: integer:=16;
				Awidth: integer:=6;
				dept:  integer:=64);
	PORT( 
		reset, clock, enable			: IN 	std_logic; -- enables the control unit
		TBactive						: IN 	std_logic; -- the TB is controlling the registers file and program memory
		RFdataIn,MEMdataIn				: IN	std_logic_vector(Dwidth-1 downto 0);
		RFreadAddr,RFwriteAddr			: IN	std_logic_vector(3 downto 0);
		MEMwriteEnable, RFwriteEnable	: IN 	std_logic;
		MEMwriteAddress					: IN	std_logic_vector(Awidth-1 downto 0);
		RFdataOut						: OUT	std_logic_vector(Dwidth-1 downto 0);
		done							: OUT	std_logic		
		);
END component;
----------------------------Control------------------------------
  component Control is
	PORT( 	
		Opcode 							: IN 	STD_LOGIC_VECTOR(3 downto 0);
		Nflag,Zflag,Cflag				: IN 	STD_LOGIC;
		clk, rst, enableTB				: IN 	STD_LOGIC;
		ALUctl 							: OUT 	STD_LOGIC;
		Ain, Cin, Cout 					: OUT 	STD_LOGIC; -- ALU registers enables
		immIn, RFOut, wrRFenable 		: OUT 	STD_LOGIC;
		RFaddr,PCsel					: OUT 	STD_LOGIC_VECTOR(1 downto 0);
		PCin, IRin			 			: OUT 	STD_LOGIC;
		tbDone							: OUT 	STD_LOGIC
	 );
  end component;
----------------------------Datapath---------------------------	
  component Datapath is
	generic(	Dwidth: integer:=16;
	Awidth: integer:=6;
	depth:  integer:=64);
	PORT(
	clock, rst							: IN  	std_logic;
	wrEn								: IN  	std_logic; -- Enable for Program Memory (from TB)
	Ain, Cin, Cout 						: IN 	STD_LOGIC; -- ALU registers enables
	ALUctl								: IN 	STD_LOGIC; 
	immIn, RFOut, wrRFenable 			: IN 	STD_LOGIC;
	PCin, IRin			 				: IN 	STD_LOGIC;
	RFaddr,PCsel						: IN 	STD_LOGIC_VECTOR(1 downto 0);
	writeAddr							: IN  	std_logic_vector(Awidth-1 downto 0);
	TBactive,TBwriteRFenable			: IN	std_logic;
	RFreadAddrTB						: IN 	std_logic_vector(3 downto 0);
	RFwriteAddrTB						: IN 	std_logic_vector(3 downto 0);
	RFdataInTB							: IN 	std_logic_vector(Dwidth-1 downto 0);
	MEMdataInTB							: IN 	std_logic_vector(Dwidth-1 downto 0);
	RFdataOutTB							: OUT 	std_logic_vector(Dwidth-1 downto 0);
	Nflag,Zflag,Cflag					: OUT 	STD_LOGIC;
	Opcode 								: OUT 	STD_LOGIC_VECTOR(3 downto 0)
	);
  end component;
---------------------------ALU---------------------------------
	component ALU is
		generic( 	Dwidth: integer:=16);
		PORT(		Cin,Ain				:	in 		std_logic; -- control
	   				ALUctl				:	in 		std_logic; -- ALU operation	
	   				clk, rst			:	in 		std_logic;
	   				operandA,operandB	: 	in 		std_logic_vector(Dwidth-1 downto 0); --operands
	   				Zflag,Cflag,Nflag	:	out		std_logic;  -- Zero, Carry, Negative
	   				ALUOut				: 	out 	std_logic_vector(Dwidth-1 downto 0)
	   		);
	end component;
---------------------------RF---------------------------------
	component RF is
		generic( 		
						Dwidth: integer:=16;
						 Awidth: integer:=4
						);
		port(	
			clk,rst,WregEn: 		in std_logic;	
			WregData:						in std_logic_vector(Dwidth-1 downto 0);
			WregAddr,RregAddr:	in std_logic_vector(Awidth-1 downto 0);
			RregData: 					out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
---------------------------ProgMem---------------------------------
	component ProgMem is
		generic( Dwidth: integer:=16;
				 Awidth: integer:=6;
				 dept:   integer:=64);
		port(	
				clk,memEn: 			in std_logic;	
				WmemData:			in std_logic_vector(Dwidth-1 downto 0);
				WmemAddr,RmemAddr:	in std_logic_vector(Awidth-1 downto 0);
				
				RmemData: 			out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
---------------------------Adder---------------------------------	
	component Adder IS
		GENERIC (length : INTEGER := 16);
		PORT ( a, bPreXor: IN STD_LOGIC_VECTOR (length-1 DOWNTO 0);
				cin: IN STD_LOGIC;
				  s: OUT STD_LOGIC_VECTOR (length-1 DOWNTO 0);
			   cout: OUT STD_LOGIC);
	END component;
	
end aux_package;
