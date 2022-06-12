FA - Full Adder.
AdderSub - adder and substractor.
Shifter - Barrerl shifter that use single shifters as components 
*contains also a single_shifter - shifter with option to shift 2^i times (i integer) right/left. 
Logical - Logical output of n bit vectors: XorY , XandY , XxorY , XnorY.
top - wire between the above three components, recive the ALU output and send the Shifter Logical and AdderSub inputs. 
*contains also ALU- decied which of the above three components output to get, and calculating N,C,Z flags.  
aux_package - component's declaraion package.

 

