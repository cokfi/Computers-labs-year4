top - top entity, connects between Digital system and the I/O of the board.
AdderSub - adder and substractor.
Shifter - Barrerl shifter that use single shifters as components 
SingleShifter - shifter with option to shift 2^i times (i integer) right/left. 
Logical - Logical output of n bit vectors: XorY , XandY , XxorY , XnorY.
ALU- decied which of the above three components output to get, and calculating N,C,Z flags. 
DigitalSystem- wire between the above four components, recive the ALU output and send the Shifter Logical and AdderSub inputs.
FA - Full Adder.
reg - register of n bits, synchronous rset active high, enable active high.
DFFwithEnable - D flip flop, synchronous rset active high, enable active high.
sevenSegments - transfom 4 bits signal into 7 bits for the HEX display.
aux_package - component's declaraion package.


 

