module cpu_top(clk, rst, PC_Out, Opcode_Out, RAM_Addr_Out, RAM_Data_Out, ACC_Out, Mem_Write_Out);
    input clk, rst;
    output [3:0] PC_Out;
    output [3:0] Opcode_Out;
    output [3:0] RAM_Addr_Out;
    output [3:0] RAM_Data_Out;
    output [3:0] ACC_Out;
    output Mem_Write_Out;

    wire [3:0] pc_val; // Renamed to avoid conflicting with the module named 'pc'
    wire [7:0] instruction;
    wire [3:0] opcode;
    wire [3:0] ram_addr;
    wire [3:0] ram_data_out;
    wire [3:0] alu_result;
    wire mem_write;
    wire acc_write;
    reg [3:0] ACC;

    assign opcode = instruction[7:4];
    assign ram_addr = instruction[3:0];

    // UPDATED INSTANTIATION NAMES HERE:
    pc PC_inst(.clk(clk), .rst(rst), .pc_out(pc_val));
    rom ROM_inst(.addr(pc_val), .instruction(instruction));
    ram RAM_inst(.clk(clk), .addr(ram_addr), .data_in(ACC), .Mem_Write(mem_write), .data_out(ram_data_out));
    alu ALU_inst(.ACC(ACC), .RAM_Data(ram_data_out), .Opcode(opcode), .ALU_Result(alu_result));
    control_unit CU_inst(.Opcode(opcode), .Mem_Write(mem_write), .ACC_Write(acc_write));

    always @(posedge clk or posedge rst) begin
        if(rst) ACC <= 4'b0000;
        else if(acc_write) ACC <= alu_result;
    end

    assign PC_Out = pc_val;
    assign Opcode_Out = opcode;
    assign RAM_Addr_Out = ram_addr;
    assign RAM_Data_Out = ram_data_out;
    assign ACC_Out = ACC;
    assign Mem_Write_Out = mem_write;

endmodule