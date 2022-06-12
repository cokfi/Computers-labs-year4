----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Kfir Cohen
-- 
-- Create Date:  20/05/22 
-- Design Name:  top
-- Module Name:  
-- Project Name: LAB3 - CPU
-- Target Devices: 
-- Tool versions: 
-- Description: top entity for a multicycle CPU, including DataPath and Control unit
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
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.all;


ENTITY top IS
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
END 	top;


ARCHITECTURE structure OF top IS

signal Opcode						:	STD_LOGIC_VECTOR(3 downto 0);
signal Nflag,Zflag,Cflag			:	STD_LOGIC;	
signal ALUctl 						: 	STD_LOGIC;
signal Ain, Cin, Cout 				: 	STD_LOGIC; -- ALU registers enables
signal immIn, RFOut, wrRFenable 	: 	STD_LOGIC;
signal RFaddr,PCsel					: 	STD_LOGIC_VECTOR(1 downto 0);
signal PCin, IRin			 		: 	STD_LOGIC;


begin

DataPath_inst: DataPath generic map(Dwidth=>16,
									Awidth=>6,
									depth=>64)
						port map(	clock 	=>	clock,
									rst		=>  reset,
									wrEn	=>	MEMwriteEnable,
									Ain		=>	Ain,
									Cin		=>	Cin,
									Cout	=>	Cout,
									ALUctl	=>	ALUctl,
									immIn	=>	immIn,
									RFout	=>	RFout,
									wrRFenable	=> wrRFenable,
									PCin	=>	PCin,
									IRin	=>	IRin,
									RFaddr	=>	RFaddr,
									PCsel 	=>	PCsel,
									writeAddr 		=>	MEMwriteAddress, -- Program memory write address
									TBactive 		=>	TBactive,
									TBwriteRFenable =>	RFwriteEnable,
									RFreadAddrTB 	=>	RFreadAddr,
									RFwriteAddrTB 	=>	RFwriteAddr,
									RFdataInTB 		=>	RFdataIn,
									MEMdataInTB 	=>	MEMdataIn,
									RFdataOutTB 	=>	RFdataOut,
									Nflag	=>	Nflag,
									Zflag	=>	Zflag,
									Cflag	=>	Cflag,
									OPcode	=>	Opcode
								);

Control_inst: 	control port map(	OPcode	=>	Opcode,
									Nflag	=>	Nflag,
									Zflag	=>	Zflag,
									Cflag	=>	Cflag,
									clk		=>	clock,
									rst		=>	reset,
									enableTB 	=> enable,
									ALUctl	=>	ALUctl,
									Ain		=> 	Ain,
									Cin		=>	Cin,
									Cout	=>	Cout,
									immIn	=>	immIn,
									RFout	=>	RFout,
									wrRFenable	=>	wrRFenable,
									PCin	=>	PCin,
									RFaddr	=> RFaddr,
									PCsel	=> PCsel,
									IRin	=> IRin,
									tbDone	=> done
									);

END structure;
