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
	ALUoperation 	: OUT 	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	Jump			: OUT 	STD_LOGIC;
	Mul				: OUT 	STD_LOGIC;
	jal_c			: OUT 	STD_LOGIC;
	clock, reset	: IN 	STD_LOGIC );

END control;

ARCHITECTURE behavior OF control IS

	signal  R_format, Lw, Sw, Beq, Addi, J, Jal, Xori, Bne, Lui, Ori, Andi, Slti, Multiply 	: STD_LOGIC;
	signal ALUoperation, ALUoperationRegType : std_logic_vector (3 down to 0); --muxes outputs

BEGIN      
	Mul   <= Multiply;
	jal_c <= Jal;
				-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0'; -- including jr
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
	
	RegDst(0)    	<=  R_format or Multiply ;
	RegDst(1)    	<=  Jal;
	
	Branch      <=  Beq or Bne;
	MemRead 	<=  Lw ;
	MemtoReg 	<=  Lw ;
	MemWrite 	<=  Sw;
 	ALUSrc  	<=  Lw OR Sw OR addi OR Xori OR Lui OR Ori OR Andi OR Slti;
  	RegWrite 	<=  Lw OR R_format OR Multiply OR addi OR Xori OR Lui OR Ori OR Andi OR Slti OR Jal;
  	Jump        <=  J or Jal;

	--TODO: make it readable/portable
	ALUOp( 0 ) 	<=  (not(R_format))and (not(Multiply))and (not(Beq))and (not(Lui)) and (not(andi)); 
	ALUOp( 1 ) 	<=  Beq or Xori or Bne or Andi or Slti; 
	ALUOp( 2 )  <=  Lui or Ori or Andi or Slti;
-----------------------------------------------
-- muxes
-----------------------------------------------
RegTypeALUopMUX:with Function_opcode select				--ALU operation - reg type mux

	ALUoperationRegType	<=	"0000" when "000000", -- shift left, sll
							"0001" when "000010", -- shift right, srl
							"0010" when "011000", -- X unused operation X : mult (mul is the right operation for multiplication)
							"0011" when "100000", -- adder for ADD 
							"0011" when "100001", -- adder for move
							"0011" when "001000", -- adder for jr ($ra +$0)
							"0100" when "100010", -- subtractor for Sub
							"0100" when "101010", -- subtractor for slt
							"0101" when "100100", -- AND 
							"0110" when "100101", -- OR
							"0111" when others  ;-- XOR (Function_opcode ="100110") 


RegTypeALUopMUX:with Opcode select				--ALU operation mux

	ALUoperation	<=	"0010" when "011100", -- mul (multiplication)
						"0011" when "001000", -- adder for addi (add immadiate)
						"0011" when "100011", -- adder for lw (load word)
						"0011" when "101011", -- adder for sw (store word)
						"0011" when "101011", -- adder for j (jump)
						"0100" when "000100", -- subtractor for beq (branch equal)
						"0100" when "001010", -- subtractor for slti (set less than immadiate)
						"0101" when "001100", -- AND for andi (and immadiate) 
						"0110" when "001101", -- OR for ori (or immadiate)
						"0111" when "001110", -- XOR for xori (xor immadiate)
						"0111" when "000101", -- XOR for bne (branch not equal)
						"1000" when "001111", -- Lui (load upper immadiate)
						"1001" when "000011", -- jal jump and link 
						ALUoperationRegType when others  ;-- Reg Type operation opcode = "000000"

						

   END behavior;
