System Description

MIPS: a single-cycle MIPS processor utilizing Harvard arch. with separated data/program memories and 3 BUSs.

FETCH: Holds the PC register and program memory, responsible for fetching the next instruction to kickstart the processing of the instruction.

DECODE: Holds the register file. Responsible for decoding the fetched instruction in each cycle and providing access to the desired registers and their data.

EXECUTE: Contains an ALU that operates on the operands in the inputs: Ainput,Binput.

DMEMORY: data memory. Memory is RAM, read and write.