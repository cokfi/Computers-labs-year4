-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY peripherial IS
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
END peripherial;

ARCHITECTURE peri OF peripherial IS
	SIGNAL CS 												: STD_LOGIC_VECTOR( 7 DOWNTO 1 ); --chip select
	SIGNAL DATA_BUS,D_LG,D_LR,D_H0,D_H1,D_H2,D_H3,D_SW		: STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- FOR REGISTERS
	SIGNAL EN_LG,EN_LR,EN_H0,EN_H1,EN_H2,EN_H3  			: STD_LOGIC; --enable writing to DFFs
	SIGNAL R_LG,R_LR,R_H0,R_H1,R_H2,R_H3,R_SW  			    : STD_LOGIC; --enable reading from DFFs
	SIGNAL en_read_sw										: STD_LOGIC; --enable reading switches
	signal write_clock : STD_LOGIC;
	
--------------------- MEMORY Mapped I/O ----------------------
--define PORT_LEDG[7-0] 0x800 - LSB byte (Output Mode)	
--define PORT_LEDR[7-0] 0x804 - LSB byte (Output Mode)	
--define PORT_HEX0[7-0] 0x808 - LSB byte (Output Mode)
--define PORT_HEX1[7-0] 0x80C - LSB byte (Output Mode)
--define PORT_HEX2[7-0] 0x810 - LSB byte (Output Mode)
--define PORT_HEX3[7-0] 0x814 - LSB byte (Output Mode)
--define PORT_SW[7-0]   0x818 - LSB byte (Input Mode)
--------------------------------------------------------------
BEGIN
write_clock <= not clock;
CS(1) <= '1' WHEN Address = "1000" ELSE '0'; -- LEDG
CS(2) <= '1' WHEN Address = "1001" ELSE '0'; -- LEDR
CS(3) <= '1' WHEN Address = "1010" ELSE '0'; -- HEX0
CS(4) <= '1' WHEN Address = "1011" ELSE '0'; -- HEX1
CS(5) <= '1' WHEN Address = "1100" ELSE '0'; -- HEX2
CS(6) <= '1' WHEN Address = "1101" ELSE '0'; -- HEX3
CS(7) <= '1' WHEN Address = "1110" ELSE '0'; -- SW

EN_LG <= CS(1)AND MemWrite;
EN_LR <= CS(2)AND MemWrite;
EN_H0 <= CS(3)AND MemWrite;
EN_H1 <= CS(4)AND MemWrite;
EN_H2 <= CS(5)AND MemWrite;
EN_H3 <= CS(6)AND MemWrite;

R_LG <= CS(1)AND MemRead;
R_LR <= CS(2)AND MemRead;
R_H0 <= CS(3)AND MemRead;
R_H1 <= CS(4)AND MemRead;
R_H2 <= CS(5)AND MemRead;
R_H3 <= CS(6)AND MemRead;
R_SW <= CS(7)AND MemRead;

DATA  <= D_LG 	WHEN R_LG = '1' ELSE "ZZZZZZZZ";
DATA  <= D_LR 	WHEN R_LR = '1' ELSE "ZZZZZZZZ";
DATA  <= D_H0 	WHEN R_H0 = '1' ELSE "ZZZZZZZZ";
DATA  <= D_H1 	WHEN R_H1 = '1' ELSE "ZZZZZZZZ";
DATA  <= D_H2 	WHEN R_H2 = '1' ELSE "ZZZZZZZZ";
DATA  <= D_H3 	WHEN R_H3 = '1' ELSE "ZZZZZZZZ";
DATA  <= SW 	WHEN R_SW = '1' ELSE "ZZZZZZZZ";

-------------- writing to dffs-------------------------
GPIO: PROCESS ( write_clock,reset )
	BEGIN
	if  (reset= '1') then 
		D_LG  <= "00000000";
		D_LR  <= "00000000";
		D_H0  <= "00000000";
		D_H1  <= "00000000";
		D_H2  <= "00000000";
		D_H3  <= "00000000";
	elsif (write_clock'event and write_clock='1') then
		if (EN_LG= '1') then
			D_LG  <= DATA;
		elsif (EN_LR= '1') then
			D_LR  <= DATA;
		elsif EN_H0='1' then
			D_H0  <= DATA;
		elsif EN_H1='1' then
			D_H1  <= DATA;
		elsif EN_H2='1' then
			D_H2  <= DATA;
		elsif EN_H3='1' then
			D_H3  <= DATA;
		END IF;
	END IF;
END PROCESS;

-----------------------------LEDS------------------------------------------
LEDG <= D_LG;
LEDR <= D_LR;
-----------------------------HEX SCREEN------------------------------------
	process(D_H0(3 downto 0))
begin
    case D_H0(3 downto 0) is
    when "0000" => HEX0 <= "0000001"; -- "0"     
    when "0001" => HEX0 <= "1001111"; -- "1" 
    when "0010" => HEX0 <= "0010010"; -- "2" 
    when "0011" => HEX0 <= "0000110"; -- "3" 
    when "0100" => HEX0 <= "1001100"; -- "4" 
    when "0101" => HEX0 <= "0100100"; -- "5" 
    when "0110" => HEX0 <= "0100000"; -- "6" 
    when "0111" => HEX0 <= "0001111"; -- "7" 
    when "1000" => HEX0 <= "0000000"; -- "8"     
    when "1001" => HEX0 <= "0000100"; -- "9" 
    when "1010" => HEX0 <= "0000010"; -- a
    when "1011" => HEX0 <= "1100000"; -- b
    when "1100" => HEX0 <= "0110001"; -- C
    when "1101" => HEX0 <= "1000010"; -- d
    when "1110" => HEX0 <= "0110000"; -- E
    when others => HEX0 <= "0111000"; -- F
    end case;
end process;

	process(D_H1(3 downto 0))
begin
    case D_H1(3 downto 0) is
    when "0000" => HEX1 <= "0000001"; -- "0"     
    when "0001" => HEX1 <= "1001111"; -- "1" 
    when "0010" => HEX1 <= "0010010"; -- "2" 
    when "0011" => HEX1 <= "0000110"; -- "3" 
    when "0100" => HEX1 <= "1001100"; -- "4" 
    when "0101" => HEX1 <= "0100100"; -- "5" 
    when "0110" => HEX1 <= "0100000"; -- "6" 
    when "0111" => HEX1 <= "0001111"; -- "7" 
    when "1000" => HEX1 <= "0000000"; -- "8"     
    when "1001" => HEX1 <= "0000100"; -- "9" 
    when "1010" => HEX1 <= "0000010"; -- a
    when "1011" => HEX1 <= "1100000"; -- b
    when "1100" => HEX1 <= "0110001"; -- C
    when "1101" => HEX1 <= "1000010"; -- d
    when "1110" => HEX1 <= "0110000"; -- E
    when others => HEX1 <= "0111000"; -- F
    end case;
end process;

	process(D_H2(3 downto 0))
begin
    case D_H2(3 downto 0) is
    when "0000" => HEX2 <= "0000001"; -- "0"     
    when "0001" => HEX2 <= "1001111"; -- "1" 
    when "0010" => HEX2 <= "0010010"; -- "2" 
    when "0011" => HEX2 <= "0000110"; -- "3" 
    when "0100" => HEX2 <= "1001100"; -- "4" 
    when "0101" => HEX2 <= "0100100"; -- "5" 
    when "0110" => HEX2 <= "0100000"; -- "6" 
    when "0111" => HEX2 <= "0001111"; -- "7" 
    when "1000" => HEX2 <= "0000000"; -- "8"     
    when "1001" => HEX2 <= "0000100"; -- "9" 
    when "1010" => HEX2 <= "0000010"; -- a
    when "1011" => HEX2 <= "1100000"; -- b
    when "1100" => HEX2 <= "0110001"; -- C
    when "1101" => HEX2 <= "1000010"; -- d
    when "1110" => HEX2 <= "0110000"; -- E
    when others => HEX2 <= "0111000"; -- F
    end case;
end process;

	process(D_H3(3 downto 0))
begin
    case D_H3(3 downto 0) is
    when "0000" => HEX3 <= "0000001"; -- "0"     
    when "0001" => HEX3 <= "1001111"; -- "1" 
    when "0010" => HEX3 <= "0010010"; -- "2" 
    when "0011" => HEX3 <= "0000110"; -- "3" 
    when "0100" => HEX3 <= "1001100"; -- "4" 
    when "0101" => HEX3 <= "0100100"; -- "5" 
    when "0110" => HEX3 <= "0100000"; -- "6" 
    when "0111" => HEX3 <= "0001111"; -- "7" 
    when "1000" => HEX3 <= "0000000"; -- "8"     
    when "1001" => HEX3 <= "0000100"; -- "9" 
    when "1010" => HEX3 <= "0000010"; -- a
    when "1011" => HEX3 <= "1100000"; -- b
    when "1100" => HEX3 <= "0110001"; -- C
    when "1101" => HEX3 <= "1000010"; -- d
    when "1110" => HEX3 <= "0110000"; -- E
    when others => HEX3 <= "0111000"; -- F
    end case;
end process;

END peri;



