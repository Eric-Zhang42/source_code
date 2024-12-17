`include "defines.v"

module ex_mem(
    input clk,
    input rst,

    //ȡִ�н׶ν��
    input wire[`RegAddrBus] ex_waddr_reg_i,
    input wire ex_we_reg_i,
    input wire[`RegBus] ex_wdata_i,
    input wire[`StallBus] stall,

    //���ô�׶�
    output reg[`RegAddrBus] mem_waddr_reg_o,
    output reg mem_we_reg_o,
    output reg[`RegBus] mem_wdata_o

);

always@(posedge clk) begin
    if(rst == `RstEnable) begin
        mem_waddr_reg_o <= `NOPRegAddr;
        mem_we_reg_o <= `WriteDisable;
        mem_wdata_o <= `ZeroWord;
    end
    else if(stall[3] == `Stop) begin        //�ô�׶���ͣ
        if(stall[4] == `NoStop)begin        //��ִ�н׶β���ͣ
            mem_waddr_reg_o <= `NOPRegAddr;
            mem_we_reg_o <= `WriteDisable;
            mem_wdata_o <= `ZeroWord;
        end
        else begin                          //��ִ�н׶���ͣ
            mem_waddr_reg_o <= mem_waddr_reg_o;
            mem_we_reg_o <= mem_we_reg_o;
            mem_wdata_o <= mem_wdata_o;
        end
    end
    else begin
        mem_waddr_reg_o <= ex_waddr_reg_i;
        mem_we_reg_o <= ex_we_reg_i;
        mem_wdata_o <= ex_wdata_i;
    end
end

endmodule