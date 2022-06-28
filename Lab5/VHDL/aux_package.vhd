library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
----------------------------MIPS-------------------------------
component MIPS IS
	generic (
		simulationMode: integer := 0; 				   -- 0 for synthesis, 1 for simulation mode
		addressLength:	integer := 10 -2*simulationMode -- 10 for synthesis, 8 for simulation mode
	);
	PORT( reset, clock					: IN 	STD_LOGIC; -- reset is opposite
		-- Output important signals to pins for easy display in Simulator
		PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ALU_result_out, read_data_1_out,
		read_data_2_out, write_data_out,	
     	Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out, isBranchConditionTrue_out,
		Memwrite_out, Regwrite_out		: OUT 	STD_LOGIC;
		LEDG				: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); --Green leds
		LEDR				: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); --Red leds
		HEX0				: OUT 	STD_LOGIC_VECTOR( 0 TO 6); 
		HEX1				: OUT 	STD_LOGIC_VECTOR( 0 TO 6); 
		HEX2				: OUT 	STD_LOGIC_VECTOR( 0 TO 6); 
		HEX3				: OUT 	STD_LOGIC_VECTOR( 0 TO 6); 
		SW					: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ) -- Switches		
		);
END 	component;
----------------------------control-------------------------------	
component control IS
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
	ALUoperation 	: OUT 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	Jump			: OUT 	STD_LOGIC
	);

END component;
----------------------------execute-------------------------------
component  execute IS
	PORT(	Read_data_1 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- data from register R[Ra]
			Read_data_2 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- data from register R[Rb]
			Sign_extend 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Function_opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALUoperation  			: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- selector from control unit 
			ALUSrc 					: IN 	STD_LOGIC; 						-- selector from control unit
			PC_plus_4 				: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			clock, reset			: IN 	STD_LOGIC; 
			isBranchConditionTrue 	: OUT	STD_LOGIC;
			Jr_ctl					: OUT	STD_LOGIC; 						-- jump register - control
			Jr_Address				: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );	-- jump register - address		
			ALUresult 				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0);
			branchAddressResult 	: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 ) 	-- address result for branch 
			);
END component;	
----------------------------Idecode-------------------------------
component Idecode IS
	  PORT(	read_data_1	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 	: IN 	STD_LOGIC;
			MemtoReg 	: IN 	STD_LOGIC;
			RegDst 		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			Sign_extend : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			clock,reset	: IN 	STD_LOGIC );
END component;
----------------------------Ifetch-------------------------------
component Ifetch IS
	PORT(	
			SIGNAL clock, reset 	: IN 	STD_LOGIC;
			SIGNAL Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- branch address result
        	SIGNAL Branch 			: IN 	STD_LOGIC;
        	SIGNAL isBranchConditionTrue : IN 	STD_LOGIC;
			SIGNAL Jump 			: IN 	STD_LOGIC;
			SIGNAL Jr	 			: IN 	STD_LOGIC;
			SIGNAL Jr_Address		: IN	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			SIGNAL Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
      		SIGNAL PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 )
        	);
END component;
----------------------------Dmemory-------------------------------
component dmemory IS
	generic(
			addressLength:	integer := 10;  -- 10 for synthesis, 8 for simulation mode
			simulationMode:	integer := 0	-- 0 for synthesis, 1 for simulation mode
	);
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	address 			: IN 	STD_LOGIC_VECTOR( addressLength-1 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset			: IN 	STD_LOGIC );
END component;
----------------------------peripherial-------------------------------
component peripherial IS
	PORT(reset				: IN 	STD_LOGIC;
		 clock			    : IN 	STD_LOGIC;
		 MemRead 			: IN 	STD_LOGIC;
         MemWrite 			: IN 	STD_LOGIC;
		 Address			: IN	STD_LOGIC_VECTOR( 3 DOWNTO 0 ); --[A11,A4,A3,A2]
		 Data				: INOUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );	--[D7,...,D0]
		 LEDG				: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); --Green leds
		 LEDR				: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); --Red leds
		 HEX0				: OUT 	STD_LOGIC_VECTOR( 0 TO 6 ); 
		 HEX1				: OUT 	STD_LOGIC_VECTOR( 0 TO 6 );  
		 HEX2				: OUT 	STD_LOGIC_VECTOR( 0 TO 6 ); 
		 HEX3				: OUT 	STD_LOGIC_VECTOR( 0 TO 6 ); 
		 SW					: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ) -- Switches
	);
END component;
----------------------------divider-------------------------------
component divider is port (
	CLKin : in std_logic;	 
	CLKout : out std_logic );
end component;

end aux_package;

