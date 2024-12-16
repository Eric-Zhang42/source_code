
`include "defines.v"

module if_id(   //ȡָ��׶� instruction fetch to instruction decode
    input clk,
    input rst,
    input wire[`InstAddrBus] if_pc, //ָ���ַ
    input wire[`InstBus] if_inst,   //ָ���ָ��洢���������ﻹû��ָ��洢����ģ�飿

    output reg[`InstAddrBus] id_pc, 
    output reg[`InstBus] id_inst
);
    always@(posedge clk) begin 
        if(rst == `RstEnable) begin
            id_pc <= 0;
            id_inst <= 0;
        end
        else begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end
    end

endmodule