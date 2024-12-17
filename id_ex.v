
`include "defines.v"

module id_ex(
    input clk,
    input rst,

    //取译码阶段信息
    input wire[`AluOpBus] id_aluop_i,
    input wire[`AluSelBus] id_alusel_i,
    input wire[`RegBus] id_rdata1_i,
    input wire[`RegBus] id_rdata2_i,
    input wire[`RegAddrBus] id_waddr_reg_i,
    input wire id_we_reg_i,

    input wire id_now_in_delayslot_i,   //当前指令是否是延迟槽指令
    input wire id_next_in_delayslot_i,  //下一条指令是否是延迟槽指令
    input wire [`InstAddrBus] id_return_addr_i,        //返回地址

    //给执行阶段信息
    output reg[`AluOpBus] ex_aluop_o,
    output reg[`AluSelBus] ex_alusel_o,
    output reg[`RegBus] ex_rdata1_o,
    output reg[`RegBus] ex_rdata2_o,
    output reg[`RegAddrBus] ex_waddr_reg_o,
    output reg ex_we_reg_o,

    output reg ex_now_in_delayslot_o,   //当前指令是否是延迟槽指令，传递给执行阶段
    output reg [`InstAddrBus] ex_return_addr_o,        //返回地址

    //返回给译码阶段信息
    output reg now_in_delayslot_o       //当前指令是否是延迟槽指令，返回给译码阶段

);

always@(posedge clk) begin
    if(rst == `RstEnable) begin
        ex_aluop_o <= `EXE_NOP_OP;
        ex_alusel_o <= `EXE_RES_NOP;
        ex_rdata1_o <= `ZeroWord;
        ex_rdata2_o <= `ZeroWord;
        ex_waddr_reg_o <= `NOPRegAddr;
        ex_we_reg_o <= `WriteDisable;

        ex_return_addr_o <= `ZeroWord;
        ex_now_in_delayslot_o <= `IsNotDelaySlot;
        now_in_delayslot_o <= `IsNotDelaySlot;
    end
    else begin//stall == Nostop
        ex_aluop_o <= id_aluop_i;
        ex_alusel_o <= id_alusel_i;
        ex_rdata1_o <= id_rdata1_i;
        ex_rdata2_o <= id_rdata2_i;
        ex_waddr_reg_o <= id_waddr_reg_i;
        ex_we_reg_o <= id_we_reg_i;

        ex_return_addr_o <= id_return_addr_i;
        ex_now_in_delayslot_o <= id_now_in_delayslot_i;     //传递给执行阶段
        now_in_delayslot_o <= id_next_in_delayslot_i;       //返回给译码阶段
    end
end

endmodule