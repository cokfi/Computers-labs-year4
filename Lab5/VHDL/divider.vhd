-- frequency divider
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
 
entity divider is port (
	CLKin : in std_logic;	 
	CLKout : out std_logic );
end divider;

architecture div of divider is
    signal q_int : std_logic_vector (25 downto 0):= "00000000000000000000000000";
begin
    counter : process (CLKin) 
    begin
        if (rising_edge(CLKin)) then
		    q_int <= q_int + 1;

	    end if;
    end process;
	
	
-- T_clkout = 2T_clkin
	
    CLKout <= q_int(0);
				
end div;



