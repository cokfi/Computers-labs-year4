----------------------------------------------------------------------------------
-- Company: BGU
-- Engineers: Ron Tal and Kfir Cohen
-- 
-- Create Date:  20/05/22 
-- Design Name:  DataPath
-- Module Name:  
-- Project Name: LAB3 - CPU
-- Target Devices: 
-- Tool versions: 
-- Description: data path for a multicycle CPU, including execute unit, register file, memory, databus.
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

ENTITY  DataPath IS
generic(	Dwidth: integer:=16;
		 	Awidth: integer:=6;
		 	depth:  integer:=64);
PORT(
	clock, rst							: IN 	std_logic;
	wrEn								: IN  	std_logic; -- Enable for Program Memory (from TB)
	Ain, Cin, Cout 						: IN 	STD_LOGIC; -- ALU registers enables
	ALUctl								: IN 	STD_LOGIC; 
	immIn, RFOut, wrRFenable 			: IN 	STD_LOGIC;
	PCin, IRin			 				: IN 	STD_LOGIC;
	RFaddr,PCsel						: IN 	STD_LOGIC_VECTOR(1 downto 0);
	writeAddr							: IN  	std_logic_vector(Awidth-1 downto 0); -- Program memory write address
	TBactive,TBwriteRFenable			: IN	std_logic;
	RFreadAddrTB						: IN 	std_logic_vector(3 downto 0);
	RFwriteAddrTB						: IN 	std_logic_vector(3 downto 0);
	RFdataInTB							: IN 	std_logic_vector(Dwidth-1 downto 0);
	MEMdataInTB							: IN 	std_logic_vector(Dwidth-1 downto 0);
	RFdataOutTB							: OUT 	std_logic_vector(Dwidth-1 downto 0);
	Nflag,Zflag,Cflag					: OUT 	STD_LOGIC;
	Opcode 								: OUT 	STD_LOGIC_VECTOR(3 downto 0)
	);
END DataPath;

ARCHITECTURE behavior OF DataPath IS
-- TODO: Add BUS
signal dataBus		: std_logic_vector(Dwidth-1 downto 0);
signal immadiateExtended: std_logic_vector(Dwidth-1 downto 0);
signal PC			: std_logic_vector(Awidth-1 downto 0);
signal PCinput		: std_logic_vector(Awidth-1 downto 0);
signal PCplusOne	: std_logic_vector(Awidth-1 downto 0);
signal PCplusOneExtended 	 : std_logic_vector(Awidth downto 0); -- extended with '0' MSB
signal PCplusImmadiatePlusOne: std_logic_vector(Awidth downto 0); -- extended with '0' MSB

signal RFdataIn		: std_logic_vector(Dwidth-1 downto 0); 		-- selected between dataBus and RFdataInTB
signal RFdataOut	: std_logic_vector(Dwidth-1 downto 0); 		
signal RFaddrFromIR	: std_logic_vector(3 downto 0); 			-- selected between ra rb rc
signal RFreadAddr,RFwriteAddr: std_logic_vector(3 downto 0); 	-- selected between TB input and IRinput
signal RFwriteEnable: std_logic;

signal PM_dataOut	: std_logic_vector(Dwidth-1 downto 0); 		-- Output of Program Memory
signal ALUOut		: std_logic_vector(Dwidth-1 downto 0);
signal one			: std_logic_vector(Awidth-1 downto 0);
signal IR			: std_logic_vector(Dwidth-1 downto 0);
alias	IRopcode	: std_logic_vector(3 downto 0) is IR(Dwidth-1 downto Dwidth-4);
alias	IRra		: std_logic_vector(3 downto 0) is IR(Dwidth-5 downto Dwidth-8);
alias	IRrb		: std_logic_vector(3 downto 0) is IR(Dwidth-9 downto Dwidth-12);
alias	IRrc		: std_logic_vector(3 downto 0) is IR(Dwidth-13 downto 0);	
alias	IRimmadiate	: std_logic_vector(7 downto 0) is IR(7 downto 0);		




begin 

-----------------------------------------------
-- Connect Components
-----------------------------------------------

progMem_Connect: ProgMem port map (
			clk => clock,
			memEn => wrEn, 			-- enable writing to memory by TB
			WmemData => MEMdataInTB,		--by TB
			WmemAddr => writeAddr, 	--by TB
			RmemAddr => PC,
			RmemData => PM_dataOut
		);

ALU_Connect: ALU 	
	generic map(
		Dwidth	=>	Dwidth) 
	port map(
		clk => clock,
		rst => rst,
		Cin => Cin,
		Ain => Ain,
		ALUctl => ALUctl,
		operandA => dataBus,
		operandB => dataBus,
		Zflag => Zflag,
		Cflag => Cflag,
		Nflag => Nflag,
		ALUOut => ALUOut
		);
RF_Connect: RF -- Registers File
	generic map(
		Dwidth	=>	Dwidth,
		Awidth 	=>	4	) -- reg address is 4 bit only! (not 6)
	port map(
		clk => clock,
		rst => rst,
		WregEN => RFwriteEnable,
		WregData => RFdataIn,
		WregAddr => RFwriteAddr,
		RregAddr => RFreadAddr,
		RregData => RFdataOut
		);	

-----------------------------------------------
-- assignments
-----------------------------------------------
one(0)	 <= '1';
one(Awidth-1 downto 1) <= (others => '0');
PCplusOneExtended 		<= '0'&PCplusOne;
PCplusOne 				<= std_logic_vector(unsigned(PC)+ unsigned(one));
PCplusImmadiatePlusOne 	<= std_logic_vector(signed(PCplusOneExtended) + resize(signed(IR(4 downto 0)),Awidth+1)); --resize for signextend, and keeping PCplusOne possitive
immadiateExtended 		<= std_logic_vector(resize(signed(IRimmadiate),Dwidth));
Opcode 					<= IRopcode;
RFdataOutTB				<= RFdataOut;

-----------------------------------------------
-- muxes
-----------------------------------------------

PCmux:		with PCsel select
				PCinput		<= 	PCplusImmadiatePlusOne(Awidth-1 downto 0) when "01",--resize for signextend
								PCplusOne 		when "10",
								(others=>'0') 	when others; -- "00"

RFaddrMux:	with RFaddr select				--output conected to RFreadAddrInMux
				RFaddrFromIR<=	IRra when "01",
								IRrb when "10",
								IRrc when others;

RFreadAddrInMux:	with TBactive select 			-- output conected directly to RF
						RFreadAddr	<=	RFaddrFromIR when '0',
										RFreadAddrTB when others;
RFwriteAddrINMux:	with TBactive select 			-- output conected directly to RF
						RFwriteAddr	<=	RFaddrFromIR	when '0',
										RFwriteAddrTB 	when others;							
RFdataInMux:		with TBactive select 			-- output conected directly to RF
						RFdataIn	<=	dataBus		when '0',
										RFdataInTB when others;
RFwriteEnableMux:	with TBactive select 			-- output conected directly to RF
						RFwriteEnable	<=	wrRFenable		when '0',
										TBwriteRFenable when others;

-----------------------------------------------
-- dataBus tristates
-----------------------------------------------

CoutTriState: 	dataBus	<=	ALUOut 				when Cout = '1' else 	(others => 'Z');
ImmInTristate:	dataBus	<=	immadiateExtended	when (immIn = '1') else (others => 'Z');
RFoutTristate:	dataBus	<=	RFdataOut 			when (RFOut = '1') else (others => 'Z');

-----------------------------------------------
-- Registers
-----------------------------------------------

PC_Reg: process(clock,rst)
begin
	if(rst='1') then
		PC	<= 	(others=>'0');
	elsif(clock'event and clock = '1' and PCin = '1') then	-- rising edge +enable
		PC 	<=	PCinput;
	end if;
end process;

IR_Reg: process(clock)
begin
	if(clock'event and clock = '1' and IRin = '1') then	-- rising edge +enable
		IR 	<=	PM_dataOut;
	end if;
end process;




END behavior;	 