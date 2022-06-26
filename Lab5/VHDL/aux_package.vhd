library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
----------------------------top-------------------------------
	component top IS
	GENERIC(n : INTEGER := 8;
			k : integer := 3;    -- k=log2(n)
			m : integer := 4);	 -- m=2^(k-1)
	PORT (  clk, rst									: 	IN  STD_LOGIC;
			switches 									: 	IN	STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			enableYkey0, enableALUFNkey1, enableXkey2	:	IN 	STD_LOGIC;
			XvectorHex0,XvectorHex1						: 	OUT STD_LOGIC_VECTOR (0 to 6);
			YvectorHex2,YvectorHex3						: 	OUT STD_LOGIC_VECTOR (0 to 6);
			ALUFNredLeds9to5 							: 	OUT STD_LOGIC_VECTOR (4 DOWNTO 0); -- ALU function
			ALUoutGreenLeds								: 	OUT STD_LOGIC_VECTOR(n-1 downto 0);
			NflagRedLed0,CflagRedLed1,ZflagRedLed2		: 	OUT STD_LOGIC ); -- Zflag,Cflag,Nflag
  	END component;
----------------------------control-------------------------------	
ENTITY control IS
   PORT( 	
	Opcode 			: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	Function_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	RegDst 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	ALUSrc 			: OUT 	STD_LOGIC;
	MemtoReg 		: OUT 	STD_LOGIC;
	RegWrite 		: OUT 	STD_LOGIC;
	MemRead 		: OUT 	STD_LOGIC;
	MemWrite 		: OUT 	STD_LOGIC;
	Branch 			: OUT 	STD_LOGIC;
	ALUoperation 	: OUT 	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	Jump			: OUT 	STD_LOGIC;
	);

END component;
----------------------------execute-------------------------------	
end aux_package;

