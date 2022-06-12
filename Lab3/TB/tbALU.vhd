library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tbALU is
	generic (
        Dwidth: integer:=16;
		n : positive := 16 
	);
end tbALU;

architecture dtb of tbALU is
	signal clk, rst, Cin, Ain,ALUctl            : std_logic;
	signal x,y,dataBus                          : std_logic_vector(n-1 downto 0);
    signal Zflag,Cflag,Nflag                    : std_logic;
    signal ALUOut                               : std_logic_vector(n-1 downto 0);
    --signal i                                    : integer:=0;
begin

    L0 : ALU generic map(Dwidth)PORT MAP (	clk         	=> clk,
                rst         	=> rst,
				Cin 	    	=> Cin,
				Ain 			=> Ain,
                ALUctl          => ALUctl,
				operandA		=> dataBus,
				operandB		=> dataBus,
				Zflag 			=> Zflag,
				Cflag 			=> Cflag,        		
				Nflag 			=> Nflag,  
				ALUOut 			=> ALUOut );
--------- start of stimulus section ---------

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
---------Control Simulation ------------------	State Path: Idle => SetN => First => ALU(x7) => Done
    -- add 4 cycles in the top module
    ctrSim: process
    variable j : integer := 0;
    variable fullInt : integer :=4096 ;
    begin
        Ain<='0';
        Cin<='0';
        ALUctl<='0';
        x<= x"7fff";
        y<= (others=>'0');
        wait for 50 ns; -- falling edge
        ALUctl<= '0'; --addition
        for i in 0 to 9 loop
            dataBus<=x;
            Ain<='1';
            wait for 50 ns;
            Ain<='0';
            dataBus<=y;
            Cin<='1';
            wait for 50 ns;
            Cin<='0';
            x<= x- (j+2);
            y<= y+(j+2);
            wait for 50 ns;
            j:=j+1;
        end loop;

        ALUctl<= '1'; --subtraction
        j:=0;
        y<= (others=>'0');
        x<= x"7fff"; 
        wait for 50 ns;
        for i in 0 to 9 loop
            y<= y+(j+2);
            dataBus<=x;
            Ain<='1';
            wait for 50 ns;
            Ain<='0';
            dataBus<=y;
            Cin<='1';
            wait for 50 ns;
            Cin<='0';
            wait for 50 ns;
            j:=j+1;
        end loop;

            --check flags
            Ain<='0';
            Cin<='0';
            ALUctl<='0';
            x<= (others=>'0');
            y<= (others=>'0');
            j:=0;
            wait for 50 ns; -- falling edge
            ALUctl<= '0'; --addition
            for i in 0 to 9 loop
                dataBus<=x;
                Ain<='1';
                wait for 50 ns;
                Ain<='0';
                dataBus<=y;
                Cin<='1';
                wait for 50 ns;
                Cin<='0';
                y<= y-(j+1);
                wait for 50 ns;
                j:=j+1;
            end loop;
        

        wait;
    end process;

end dtb;