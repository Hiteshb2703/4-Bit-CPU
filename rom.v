module rom(addr, instruction);
    input [3:0] addr;
    output [7:0] instruction;
    
    reg [7:0] rom [0:15];
    integer i;
    
    initial begin
        rom[0] = 8'h00;
        rom[1] = 8'h21;
        rom[2] = 8'h32;
        rom[3] = 8'h40;
        rom[4] = 8'h51;
        rom[5] = 8'h13;
        for(i=6; i<16; i=i+1) rom[i] = 8'h00;
    end
    
    assign instruction = rom[addr];
endmodule