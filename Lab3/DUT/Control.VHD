----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Kfir Cohen
-- 
-- Create Date:  13/05/22 
-- Design Name:  Control
-- Module Name:  controller 
-- Project Name: LAB3 - CPU
-- Target Devices: 
-- Tool versions: 
-- Description: control unit for a multicycle CPU based on a mealy finite state machine sync -falling edge
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

ENTITY control IS
   PORT( 	
	Opcode 							: IN 	STD_LOGIC_VECTOR(3 downto 0);
	Nflag,Zflag,Cflag				: IN 	STD_LOGIC;
	clk, rst,enableTB				: IN 	STD_LOGIC; -- TODO: check enable didn't ruin everything
	ALUctl 							: OUT 	STD_LOGIC;
	Ain, Cin, Cout 					: OUT 	STD_LOGIC; -- ALU registers enables
	immIn, RFOut, wrRFenable 		: OUT 	STD_LOGIC;
	RFaddr,PCsel					: OUT 	STD_LOGIC_VECTOR(1 downto 0);
	PCin, IRin			 			: OUT 	STD_LOGIC;
	tbDone							: OUT 	STD_LOGIC
	);

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  add, sub, nop, jmp, jc, jnc, mov, done  	: STD_LOGIC;-- 8 instractions
	type state_type is(fetch, decode, regType1, regType2); -- regType2 is the 3rd cycle of regOperation, regType2 is the 4th
	signal next_state, state : state_type;

BEGIN      

	-- Code to generate operations signals using opcode bits
	add 		<=  '1'  WHEN  Opcode = "0000"  ELSE '0'; 
	sub 		<=  '1'  WHEN  Opcode = "0001"  ELSE '0';
	nop 		<=  '1'  WHEN  Opcode = "0010"  ELSE '0';
	jmp 		<=  '1'  WHEN  Opcode = "0100"  ELSE '0';
	jc 			<=  '1'  WHEN  Opcode = "0101"  ELSE '0';
	jnc			<=  '1'  WHEN  Opcode = "0110"  ELSE '0';
	mov 		<=  '1'  WHEN  Opcode = "1000"  ELSE '0';
	done 		<=  '1'  WHEN  Opcode = "1001"  ELSE '0';   


	--combinational part of the state machine
	fsm_comb: process (state, Opcode)
	begin
		-- defult values are used when they are not mentioned inside case state block
		next_state <= state;  
		Ain 		<= '0';
		Cin 		<= '0';
		Cout 		<= '0';
		immIn 		<= '0';
		RFOut 		<= '0';
		wrRFenable 	<= '0';
		RFaddr 		<= "00"; 
		PCsel		<= "00";
		PCin 		<= '0';
		IRin		<= '0';
		tbDone		<= '0';
		ALUctl		<= '0';

		case state is
			when fetch =>
				IRin 		<= '1';
				next_state 	<= decode;

			when decode =>
				if (add ='1' or nop ='1') then
					next_state 	<= regType1;
					RFOut	   	<= '1';
					RFaddr		<= "10"; -- nop instruction has 3 quartets of "0000"
					Ain			<= '1';
					PCin		<= '1';
					PCsel		<= "10"; -- PC+1	
				elsif (sub='1') then
					next_state	<= regType1;
					RFOut	   	<= '1';
					RFaddr		<= "10";
					Ain			<= '1';
					PCin		<= '1';
					PCsel		<= "10"; -- PC+1		
				elsif (jmp ='1') then
					next_state	<= fetch; --jmpType isn't required because the instruction takes only 2 cycles
					PCsel		<= "01"; -- PC+1+offset
					PCin		<= '1';
				elsif (jc ='1' ) then
					next_state	<= fetch;
					if (Cflag = '1') then
						PCsel		<= "01"; -- PC+1+offset
						PCin		<= '1';
					else 
						PCin		<= '1';
						PCsel		<= "10"; -- PC+1
					end if;
				elsif (jnc ='1' ) then
					next_state	<= fetch;
					if (Cflag = '0') then
						PCsel		<= "01"; -- PC+1+offset
						PCin		<= '1';
					else
						PCin		<= '1';
						PCsel		<= "10"; -- PC+1
					end if;
				elsif (mov='1')	then
					next_state 	<= fetch;
					immIn		<= '1';
					RFaddr		<= "01";
					wrRFenable  <= '1';
					PCin		<= '1';
					PCsel		<= "10"; -- PC+1
				elsif (done ='1') then
					next_state 	<= fetch;
					tbDone		<= '1';
				else 
					next_state 	<= fetch;
				end if;

			when regType1 =>
				next_state <= regType2;
				RFaddr		<= "11";
				RFOut	   	<= '1';
				Cin			<= '1';
				if (sub='1') then
					ALUctl 	   	<= '1';
				--elsif (add='1' or nop= '1') then ALUctl 	   <= '0'; --defult anyway
				end if;	

			when regType2 =>
				next_state		<= fetch;
				RFaddr		<= "01";
				wrRFenable  	<= '1';
				Cout			<= '1';
				
			when others =>
				
		end case;

	end process;	
	
	--sequential part of the state machine
	fsm_seq: process (clk, rst)
	begin
		if (rst = '1') then
			state <= fetch; 
		elsif (clk'event and clk = '0' and enableTB='1') then -- falling edge
			state <= next_state;
		end if;
	end process;


END behavior;


