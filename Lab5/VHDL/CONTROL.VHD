		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	
	Opcode 			: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	Function_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	RegDst 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	ALUSrc 			: OUT 	STD_LOGIC;
	MemtoReg 		: OUT 	STD_LOGIC;
	RegWrite 		: OUT 	STD_LOGIC;
	MemRead 		: OUT 	STD_LOGIC;
	MemWrite 		: OUT 	STD_LOGIC;
	Branch 			: OUT 	STD_LOGIC;
	ALUoperation 	: OUT 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	Jump			: OUT 	STD_LOGIC
	);

END control;

ARCHITECTURE behavior OF control IS

	signal  Rformat, Lw, Sw, Beq, Addi, J, Jal, Xori,
	 		Bne, Lui, Ori, Andi, Slti, Multiply 		: STD_LOGIC;
	signal 	ALUoperationRegType 			: std_logic_vector (4 downto 0); --muxes outputs

BEGIN 
-----------------------------------------------
-- Generate operation signals using opcode
-----------------------------------------------
				
	Rformat 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0'; -- including jr
	Lw          <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw          <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
   	Beq         <=  '1'  WHEN  Opcode = "000100"  ELSE '0';
	Addi		<=	'1'  WHEN  Opcode = "001000"  ELSE '0';
	J			<=	'1'  WHEN  Opcode = "000010"  ELSE '0';	
	Jal			<=	'1'  WHEN  Opcode = "000011"  ELSE '0';
  	Xori		<=	'1'  WHEN  Opcode = "001110"  ELSE '0';
	Bne			<=	'1'  WHEN  Opcode = "000101"  ELSE '0';
	Lui			<=	'1'  WHEN  Opcode = "001111"  ELSE '0';
	Ori			<=	'1'  WHEN  Opcode = "001101"  ELSE '0';
	Andi		<=	'1'  WHEN  Opcode = "001100"  ELSE '0';
	Slti		<=	'1'  WHEN  Opcode = "001010"  ELSE '0';
	Multiply	<=	'1'  WHEN  Opcode = "011100"  ELSE '0';
-----------------------------------------------
-- Generate control signals using operation signals
-----------------------------------------------
	RegDst(0)   <=  Rformat or Multiply ;
	RegDst(1)   <=  Jal;
	Branch      <=  Beq or Bne;
	MemRead 	<=  Lw ;
	MemtoReg 	<=  Lw ;
	MemWrite 	<=  Sw;
 	ALUSrc  	<=  Lw OR Sw OR addi OR Xori OR Lui OR Ori OR Andi OR Slti; -- immadiate or Lw
  	RegWrite 	<=  Lw OR Rformat OR Multiply OR addi OR Xori OR Lui OR Ori OR Andi OR Slti OR Jal;
  	Jump        <=  J or Jal;


-----------------------------------------------
--ALU operation - reg type mux
-----------------------------------------------

RegTypeALUopMUX: with Function_opcode select				

	ALUoperationRegType	<=	"00000" when "000000", -- shift left, sll
							"00001" when "000010", -- shift right, srl
							"00010" when "011000", -- X unused operation X : mult (mul is the right operation for multiplication)
							"00011" when "100000", -- adder for ADD 
							"01000" when "100001", -- adder for move
							"01001" when "001000", -- adder for jr ($ra +$0)
							"01010" when "100010", -- subtractor for Sub
							"01011" when "101010", -- subtractor for slt
							"01100" when "100100", -- AND 
							"01101" when "100101", -- OR
							"01110" when others  ;-- XOR (Function_opcode ="100110") 

-----------------------------------------------
--ALU operation mux
-----------------------------------------------

ALUopMUX: with Opcode select				

	ALUoperation	<=	"01111" when "011100", -- mul (multiplication)
						"10000" when "001000", -- adder for addi (add immadiate)
						"10001" when "100011", -- adder for lw (load word)
						"10010" when "101011", -- adder for sw (store word)
						"10011" when "000010", -- adder for j (jump)
						"10100" when "000011", -- adder for jal (jump and link) 
						"10101" when "000100", -- subtractor for beq (branch equal)
						"10110" when "001010", -- subtractor for slti (set less than immadiate)
						"10111" when "001100", -- AND for andi (and immadiate) 
						"11000" when "001101", -- OR for ori (or immadiate)
						"11001" when "001110", -- XOR for xori (xor immadiate)
						"11010" when "000101", -- XOR for bne (branch not equal)
						"11011" when "001111", -- Lui (load upper immadiate)
						ALUoperationRegType when others  ;-- Reg Type operation opcode = "000000"

						

   END behavior;
