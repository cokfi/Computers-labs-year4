LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ;
		m : positive := 7 ;
		k : positive := 3
	); -- where k=log2(m+1)
	port(
		rst,ena,clk : in std_logic;
		x : in std_logic_vector(n-1 downto 0);
		DetectionCode : in integer range 0 to 3;
		detector : out std_logic
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is
	signal xMinus1,xMinus2,counter :std_logic_vector(n-1 downto 0);
	signal valid,subCarry :std_logic;
	signal subOperand,subResult :std_logic_vector(n-1 downto 0);
	signal detectorReg :std_logic;
	
	
	
begin
	subOperand <= not(xMinus2);
	detector <= detectorReg;

	subtract : Adder generic map(Length => n) port map(
	a => xMinus1,
	b => subOperand,
	cin => '1',
	s => subResult,
	cout => subCarry
	);

	process1: process(clk) -- save the last former inputs x(t-1), x(t-2)
	begin	
		if rst ='1' then
			xMinus1 <= (others=>'0');
			xMinus2 <= (others=>'0');
		elsif(clk'event and clk='0') then -- negedge)
			if ena = '1' then
				xMinus2 <=	xMinus1;
				xMinus1 <=	x;
			end if;
		end if;
	end process;

	process2: process(xMinus1, xMinus2) -- compute the subtration of x(t-1) - x(t-2)
	variable detectionCodePlusOne :integer range 1 to 4;
	begin
		
		detectionCodePlusOne:= DetectionCode+1;
		if subResult = detectionCodePlusOne then
			valid <='1';
		else
			valid <='0';
		end if;
	end process;

	process3: Process(rst,ena,clk)
	variable incCounter : std_logic;
	begin
			if(rst='1') then
				detectorReg <= '0';
				counter <= (others => '0');
				incCounter := '1';
			elsif (clk'event and clk='1' and ena = '1') then 
			-- On Rising Edge: Read counter, Write detector and incCounter
				if(counter = m-1 and valid = '1') then 
					detectorReg <= '1';
					incCounter := '0'; 
				else 
					detectorReg <= '0';
					incCounter := '1'; 
				end if;	
			elsif (clk'event and clk='0' and ena = '1') then 
			-- On Falling Edge: Read valid and incCounter, Write Counter
				if(valid = '0') then
					counter <= (others => '0');
				else 
					if(incCounter = '1') then
						counter <= counter + 1;
					end if;		
				end if;
			end if;
	end process;	

end arc_sys;







