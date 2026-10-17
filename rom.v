module rom(addr, instruction);
    input [3:0] addr;
    output [7:0] instruction;
    
    reg [7:0] rom [0:15];
    integer i;
    
        initial begin
        rom[0] = 8'h00;  // LOAD 0
        rom[1] = 8'h21;  // ADD 1
        rom[2] = 8'h32;  // SUB 2
        rom[3] = 8'h40;  // AND 0
        rom[4] = 8'h51;  // XOR 1
        rom[5] = 8'h13;  // STORE 3
        rom[6] = 8'h00;  // LOAD 0  (ACC=2, so ACC no longer holds 3)
        rom[7] = 8'h03;  // LOAD 3  (ACC=3 again, proves STORE worked)
        for(i=8; i<16; i=i+1) rom[i] = 8'h00;
    end
    
    assign instruction = rom[addr];
endmodule