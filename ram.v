module ram(clk, addr, data_in, Mem_Write, data_out);
    input clk;
    input [3:0] addr;
    input [3:0] data_in;
    input Mem_Write;
    output [3:0] data_out;
    
    reg [3:0] ram [0:15];
    integer i;
    
    initial begin
        ram[0] = 4'd2;
        ram[1] = 4'd3;
        ram[2] = 4'd4;
        for(i=3; i<16; i=i+1) ram[i] = 4'd0;
    end
    
    always @(posedge clk) begin
        if(Mem_Write) ram[addr] <= data_in;
    end
    
    assign data_out = ram[addr];
endmodule