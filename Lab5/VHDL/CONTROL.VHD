		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	
	Opcode 			: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	RegDst 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	ALUSrc 			: OUT 	STD_LOGIC;
	MemtoReg 		: OUT 	STD_LOGIC;
	RegWrite 		: OUT 	STD_LOGIC;
	MemRead 		: OUT 	STD_LOGIC;
	MemWrite 		: OUT 	STD_LOGIC;
	Branch 			: OUT 	STD_LOGIC;
	ALUop 			: OUT 	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	Jump			: OUT 	STD_LOGIC;
	Mul				: OUT 	STD_LOGIC;
	jal_c			: OUT 	STD_LOGIC;
	clock, reset	: IN 	STD_LOGIC );

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, Lw, Sw, Beq, Addi, J, Jal, Xori, Bne, Lui, Ori, Andi, Slti,Multiply 	: STD_LOGIC;

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

	
	ALUOp( 0 ) 	<=  (not(R_format))and (not(Multiply))and (not(Beq))and (not(Lui)) and (not(andi)); 
	ALUOp( 1 ) 	<=  Beq or Xori or Bne or Andi or Slti; 
	ALUOp( 2 )  <=  Lui or Ori or Andi or Slti;
   END behavior;


