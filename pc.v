module pc(clk, rst, pc_out);
    input clk, rst;
    output reg [3:0] pc_out;

    always @(posedge clk or posedge rst) begin
        if(rst) pc_out <= 4'b0000;
        else pc_out <= pc_out + 1'b1;
    end
endmodule