module control_unit(Opcode, Mem_Write, ACC_Write);
    input [3:0] Opcode;
    output reg Mem_Write;
    output reg ACC_Write;
    
    always @(*) begin
        case(Opcode)
            4'b0000: begin Mem_Write = 1'b0; ACC_Write = 1'b1; end
            4'b0001: begin Mem_Write = 1'b1; ACC_Write = 1'b0; end
            4'b0010: begin Mem_Write = 1'b0; ACC_Write = 1'b1; end
            4'b0011: begin Mem_Write = 1'b0; ACC_Write = 1'b1; end
            4'b0100: begin Mem_Write = 1'b0; ACC_Write = 1'b1; end
            4'b0101: begin Mem_Write = 1'b0; ACC_Write = 1'b1; end
            default: begin Mem_Write = 1'b0; ACC_Write = 1'b0; end
        endcase
    end
endmodule