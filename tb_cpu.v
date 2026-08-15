`timescale 1ns / 1ps
module tb_cpu;
    reg clk;
    reg rst;
    wire [3:0] PC_Out;
    wire [3:0] Opcode_Out;
    wire [3:0] RAM_Addr_Out;
    wire [3:0] RAM_Data_Out;
    wire [3:0] ACC_Out;
    wire Mem_Write_Out;

    // UPDATED INSTANTIATION HERE:
    cpu_top DUT(
        .clk(clk), 
        .rst(rst), 
        .PC_Out(PC_Out), 
        .Opcode_Out(Opcode_Out), 
        .RAM_Addr_Out(RAM_Addr_Out), 
        .RAM_Data_Out(RAM_Data_Out), 
        .ACC_Out(ACC_Out), 
        .Mem_Write_Out(Mem_Write_Out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        #12;
        rst = 0;
    end

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_cpu);
    end

    initial begin
        $monitor("Time %0d PC %0d Opcode %0d RAM_Address %0d RAM_Data_Out %0d ACC %0d Mem_Write %0d", 
                 $time, PC_Out, Opcode_Out, RAM_Addr_Out, RAM_Data_Out, ACC_Out, Mem_Write_Out);
    end

    initial begin
        #150;
        $finish;
    end
endmodule