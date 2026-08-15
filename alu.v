module alu(ACC, RAM_Data, Opcode, ALU_Result);
    input [3:0] ACC;
    input [3:0] RAM_Data;
    input [3:0] Opcode;
    output reg [3:0] ALU_Result;
    
    always @(*) begin
        case(Opcode)
            4'b0000: ALU_Result = RAM_Data;
            4'b0010: ALU_Result = ACC + RAM_Data;
            4'b0011: ALU_Result = ACC - RAM_Data;
            4'b0100: ALU_Result = ACC & RAM_Data;
            4'b0101: ALU_Result = ACC ^ RAM_Data;
            default: ALU_Result = ACC;
        endcase
    end
endmodule