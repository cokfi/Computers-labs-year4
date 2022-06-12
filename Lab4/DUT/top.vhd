
----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Kfir Cohen
-- 
-- Create Date:  06/06/22 
-- Design Name:  top
-- Module Name:  
-- Project Name: LAB4 - CPU
-- Target Devices: FPGA altera
-- Tool versions: 
-- Description: top entity for an arithemetic logic unit (ALU),
-- 				including shifter adder subtractor and bitwise opearions
-- Spec:		https://github.com/Tajoro/CompLabs/tree/main/Lab4/spec				
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
--------------------------------------------------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT (  clk, rst								: 	IN  STD_LOGIC;
	  	  switches 									: 	IN	STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	  	  enableYkey0, enableALUFNkey1, enableXkey2	:	IN 	STD_LOGIC;
	  	  XvectorHex0,XvectorHex1					: 	OUT STD_LOGIC_VECTOR (0 to 6);
		  YvectorHex2,YvectorHex3					: 	OUT STD_LOGIC_VECTOR (0 to 6);
		  ALUFNredLeds9to5 							: 	OUT STD_LOGIC_VECTOR (4 DOWNTO 0); -- ALU function
		  ALUoutGreenLeds							: 	OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  NflagRedLed0,CflagRedLed1,ZflagRedLed2	: 	OUT STD_LOGIC ); -- Zflag,Cflag,Nflag
END top;
ARCHITECTURE struct OF top IS 
signal X,Y					:	STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- operands
signal ALUFN				:	STD_LOGIC_VECTOR (4 DOWNTO 0); 	 -- ALU function
signal ALUout				:	STD_LOGIC_VECTOR(n-1 downto 0);	 -- Negative flag, Carry flag, Zero flag
signal Nflag,Cflag,Zflag	:	STD_LOGIC;

BEGIN
-----------------------------------------------
-- Lab1 Instantiation
-----------------------------------------------
DigitalSystemInst: DigitalSystem generic map (n => n, k => k, m => m)
		port map(	Y 		=> Y,
					X		=> X,
					ALUFN	=> ALUFN,
					ALUout 	=> ALUout,
					Nflag 	=> Nflag,
					Cflag 	=> Cflag,
					Zflag 	=> Zflag );
-----------------------------------------------
-- Seven Segments Instantiation
-----------------------------------------------
XvectorLSBitsInst:	sevenSegments 
		port map (	binaryVector	=>	X(3 downto 0),
					sevenSegment	=> 	XvectorHex0(0 to 6)
	);

XvectorMSBitsInst:	sevenSegments 
		port map (	binaryVector	=>	X(n-1 downto 4),
					sevenSegment	=> 	XvectorHex1(0 to 6)
	);
YvectorLSBitsInst:	sevenSegments 
		port map (	binaryVector	=>	Y(3 downto 0),
					sevenSegment	=> 	YvectorHex2(0 to 6)
	);
YvectorMSBitsInst:	sevenSegments 
		port map (	binaryVector	=>	Y(n-1 downto 4),
					sevenSegment	=> 	YvectorHex3(0 to 6)
	);

-----------------------------------------------
-- input registers Instantiation
-----------------------------------------------	
RegYinst: reg generic map (REGISTER_LENGTH => n)
		port map(	clock			=>	clk,
					rst				=>	rst,
					enable			=>	not enableYkey0,
					inputVector		=>	switches,
					outputVector	=>	Y
	);

RegXinst: reg generic map (REGISTER_LENGTH => n)
	port map(	clock			=>	clk,
				rst				=>	rst,
				enable			=>	not enableXkey2,
				inputVector		=>	switches,
				outputVector	=>	X
	);
RegALUFNinst: reg generic map (REGISTER_LENGTH => 5)
	port map(	clock			=>	clk,
				rst				=>	rst,
				enable			=>	not enableALUFNkey1,
				inputVector		=>	switches( 4 downto 0),
				outputVector	=>	ALUFN
	);
-----------------------------------------------
-- output registers Instantiation
-----------------------------------------------
RegALUoutInst: reg generic map (REGISTER_LENGTH => n)
	port map(	clock			=>	clk,
				rst				=>	rst,
				enable			=>	'1',
				inputVector		=>	ALUout,
				outputVector	=>	ALUoutGreenLeds
	);
DFFNflagInst: DFFwithEnable 
	port map(	clock			=>	clk,
				rst				=>	rst,
				enable			=>	'1',
				inputBit		=>	Nflag,
				outputBit		=>	NflagRedLed0
	);
DFFCflagInst: DFFwithEnable 
	port map(	clock			=>	clk,
				rst				=>	rst,
				enable			=>	'1',
				inputBit		=>	Cflag ,
				outputBit		=>	CflagRedLed1
	);
DFFZflagInst: DFFwithEnable 
	port map(	clock			=>	clk,
				rst				=>	rst,
				enable			=>	'1',
				inputBit		=>	Zflag, 
				outputBit		=>	ZflagRedLed2
	);	

-----------------------------------------------
-- assignments
-----------------------------------------------	
ALUFNredLeds9to5 <= ALUFN;

END struct;

