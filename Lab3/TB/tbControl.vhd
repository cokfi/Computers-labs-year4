library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tbControl is
	generic (
        Dwidth: integer:=16;
		n : positive := 16 
	);
end tbControl;

architecture dtb of tbControl is
	signal clk, rst, Cin, Ain,ALUctl,Cout,enable: std_logic;
    signal Opcode 							    : STD_LOGIC_VECTOR(3 downto 0);
    signal Zflag,Cflag,Nflag                    : std_logic;
    signal immIn, RFOut, wrRFenable 		    : std_logic;
    signal RFaddr,PCsel					        : STD_LOGIC_VECTOR(1 downto 0);
    signal PCin, IRin, tbDone	 			    : STD_LOGIC;
begin



    L1 : Control PORT MAP 
            (	clk         	=> clk,
                rst         	=> rst,
                enableTB        => enable,
                Opcode          => Opcode,
				Cin 	    	=> Cin,
				Ain 			=> Ain,
                Cout            => Cout,
                ALUctl          => ALUctl,
                immIn           => immIn,
                RFOut           => RFOut,
                wrRFenable      => wrRFenable,
                RFaddr          => RFaddr,
                PCsel           => PCsel,
                PCin            => PCin,
                IRin            => IRin,
				Zflag 			=> Zflag,
				Cflag 			=> Cflag,        		
				Nflag 			=> Nflag,
                tbDone          => tbDone
                );

--------- start of stimulus section ---------
    gen_rst : process
    begin
        rst <= '1';
        wait for 45 ns;
        rst <= '0';
        wait;
    end process;
    gen_clk : process
    begin
        clk <= '0';
        wait for 25 ns;
        clk <= not clk;
        wait for 25 ns;
    end process;

---------Control Simulation ------------------	
    ctrSim: process
    variable j : integer := 0;
    variable fullInt : integer :=4096 ;
    begin
        enable      <=  '1';
        Opcode      <=  "0000";
        Nflag       <=  '0';  
        Zflag       <=  '0';
        Cflag       <=  '0';
        wait for 45 ns; -- reset ends
        Opcode      <=  Opcode+1; -- sub
        wait for 5 ns; -- falling edge
        wait for 25 ns;-- rising edge
        if (Opcode<3) then -- RegType
            wait for 150 ns; --3 cycles (fetch has already occured )
        else 
            wait for 50 ns;
        end if;
        for i in 0 to 6 loop            
            Opcode      <=  Opcode+1; 
            if (Opcode<3) then -- RegType
                wait for 200 ns; --4 cycles
            else 
                wait for 100 ns;
            end if;
        end loop;
              
    -- check Cflag =1
        Cflag       <=  '1';
        Opcode      <=  "0101";
        wait for 100 ns;
        Opcode      <=  "0110";
        wait for 100 ns;
        Opcode      <=  "0000"; -- check add instruction
        wait for 200 ns;
        Opcode      <=  "1001"; -- done
        wait;
    end process;

end dtb;