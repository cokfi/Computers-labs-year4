----------------------------------------------------------------------------------
-- Company: BGU
-- Engineer: Kfir Cohen
-- 
-- Create Date:  21/05/22 
-- Design Name:  tbTop
-- Module Name:  
-- Project Name: LAB3 - CPU
-- Target Devices: 
-- Tool versions: 
-- Description: testbench for the top entity of a multicycle CPU
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- Synopsys

entity tbTop is
	generic (
        Dwidth: integer:=16;
        Awidth: integer:=6;
        dept:  integer:=64;
		n : positive := 16 
	);
end tbTop;

architecture dtb of tbTop is
    signal fileGen                              : boolean := true;
    signal initFilesIsDone                      : boolean := false;
    --constant RFgeneratorFileLocation            : string(1 to 63) :="C:\Users\kfir\Documents\GitHub\CompLabs\Lab3\txtFile\RFinit.txt";
	constant MEMgeneratorFileLocation           : string(1 to 64) :="C:\Users\kfir\Documents\GitHub\CompLabs\Lab3\txtFile\RAMinit.txt";
    constant RFoutputFileLocation            : string(1 to 65) :="C:\Users\kfir\Documents\GitHub\CompLabs\Lab3\txtFile\RFoutput.txt";
    signal clk, rst, enable,TBactive,done       : std_logic;
	signal RFdataIn,MEMdataIn,RFdataOut         : std_logic_vector(Dwidth-1 downto 0);
    signal MEMwriteEnable,RFwriteEnable         : std_logic;
    signal RFreadAddress,RFwriteAddress         : std_logic_vector(3 downto 0);
    signal MEMwriteAddress                      : std_logic_vector(Awidth-1 downto 0);

begin

    topInst: TOP generic map(Dwidth=>Dwidth,Awidth => Awidth,dept => dept)
             PORT MAP (	clock         	=> clk,
                        reset         	=> rst,
                        enable 	    	=> enable,
                        TBactive 		=> TBactive,
                        RFdataIn        => RFdataIn,
                        MEMdataIn		=> MEMdataIn,
                        RFreadAddr		=> RFreadAddress,
                        RFwriteAddr 	=> RFwriteAddress,
                        MEMwriteEnable 	=> MEMwriteEnable,        		
                        RFwriteEnable 	=> RFwriteEnable,  
                        MEMwriteAddress => MEMwriteAddress, 
                        RFdataOut       => RFdataOut,
                        done            => done
                        );

--------- start of stimulus section ---------
initRFandMEMfiles : process
    file RFinfile                  :  text open read_mode is "C:\Users\kfir\Documents\GitHub\CompLabs\Lab3\txtFile\RFinit.txt";
    file MEMinfile                 :  text open read_mode is MEMgeneratorFileLocation;
    variable L                  :  line;
    variable numberOfLine       :  integer :=0;
    variable lineEntry          :  std_logic_vector(Dwidth-1 downto 0);
    --variable lineEntry2         :  bit_vector(7 downto 0);
    variable readIsGood         :   boolean;
begin
    --------- start of RF init ---------
    wait for 1 ns;
    wait until rst ='0';
    TBactive <='1';
    
    wait for 1 ns;
    while not endfile(RFinfile) loop
        
        readline(RFinfile,L); -- read a line to L
        ---------------------------------------
        hread(L,lineEntry,readIsGood); -- read entry type from L
        next when not readIsGood; -- skip on a comment line
        wait until clk'event and clk = '0';
        RFwriteAddress <= conv_std_logic_vector(numberOfLine,RFwriteAddress'length);
        RFdataIn <= lineEntry;
        numberOfLine := numberOfLine+1;
        RFwriteEnable<='1';
    end loop;
    file_close(RFinfile);
    report "End of RF writing" severity note;
    wait until clk'event and clk = '0';
    RFwriteEnable <= '0';
    --------- start of RF init ---------
    numberOfLine := 0;
    while not endfile(MEMinfile) loop
        
        readline(MEMinfile,L); -- read a line to L
        ---------------------------------------
        hread(L,lineEntry,readIsGood); -- read entry type from L
        next when not readIsGood; -- skip on a comment line
        wait until clk'event and clk = '0';
        MEMwriteAddress <= conv_std_logic_vector(numberOfLine,MEMwriteAddress'length);
        MEMdataIn <= lineEntry;
        numberOfLine := numberOfLine+1;
        MEMwriteEnable <= '1';
    end loop;
    file_close(MEMinfile);
    report "End of MEM writing" severity note;
    wait until clk'event and clk = '0';
    MEMwriteEnable <= '0';
    TBactive <= '0';
    wait until done ='1';
    TBactive <= '1';
    wait;
    end process;
        



--------- start of stimulus section ---------
    gen_rst : process
    begin
        rst <= '1';
        wait for 45 ns;
        rst <= '0';
        wait until TBactive = '0';
        --wait for 1.5 ns; -- random
        rst <= '1';
        --wait until clk'event and clk ='1';
        wait for 45 ns;
        rst <= '0';
        wait;
    end process;

    gen_enable : process
    begin
        enable <= '0';
        wait for 2 ns;
        wait until TBactive='0';
        enable <= '1';
        wait until TBactive='1';
        enable <= '0';
        wait;
    end process;
    gen_clk : process
    begin
        clk <= '0';
        wait for 25 ns;
        clk <= not clk;
        wait for 25 ns;
    end process;
---------top simulation ------------------	
    cpuSim: process
        file outfile : text open write_mode is RFoutputFileLocation;
        variable L                  :  line;
        variable numberOfLine       :  integer :=0;
     begin 
        wait for 2 ns;
        wait until done = '1';
        report "End of processing" severity note;
        -- TBactive on reading procces
        wait for 1 ns;
        loop 
            wait until (clk'event and clk ='1');
            RFreadAddress <= conv_std_logic_vector(numberOfLine,RFreadAddress'length);
            wait for 1 ns;
            hwrite(L,RFdataOut);
            writeline(outfile,L);
            numberOfLine := numberOfLine+1;
            exit when numberOfLine = 16;
        end loop;
        report "End of writing" severity note;
        wait;
    end process;

end dtb;