`include "defines.v"

module ex_mem(
    input clk,
    input rst,

    //ȡִ�н׶ν��
    input wire[`RegAddrBus] ex_waddr_reg_i,
    input wire ex_we_reg_i,
    input wire[`RegBus] ex_wdata_i,
    input wire[`StallBus] stall,
    input wire[`RegBus] ex_hi_i,
    input wire[`RegBus] ex_lo_i,
    input wire ex_whilo_i,

    //���ô�׶�
    output reg[`RegAddrBus] mem_waddr_reg_o,
    output reg mem_we_reg_o,
    output reg[`RegBus] mem_wdata_o,
    output reg[`RegBus] mem_hi_o,
    output reg[`RegBus] mem_lo_o,
    output reg mem_whilo_o
);

always@(posedge clk) begin
    if(rst == `RstEnable) begin
        mem_waddr_reg_o <= `NOPRegAddr;
        mem_we_reg_o <= `WriteDisable;
        mem_wdata_o <= `ZeroWord;
        mem_hi_o <= `ZeroWord;
        mem_lo_o <= `ZeroWord;
        mem_whilo_o <= `WriteDisable;
    end
    else if(stall[3] == `Stop) begin        //�ô�׶���ͣ
        if(stall[4] == `NoStop)begin        //��ִ�н׶β���ͣ
            mem_waddr_reg_o <= `NOPRegAddr;
            mem_we_reg_o <= `WriteDisable;
            mem_wdata_o <= `ZeroWord;
            mem_hi_o <= `ZeroWord;                                                                  //�������
            mem_lo_o <= `ZeroWord;
            mem_whilo_o <= `WriteDisable;
        end
        else begin                          //��ִ�н׶���ͣ
            mem_waddr_reg_o <= mem_waddr_reg_o;
            mem_we_reg_o <= mem_we_reg_o;
            mem_wdata_o <= mem_wdata_o;
            mem_hi_o <= mem_hi_o;                                                                  //�������
            mem_lo_o <= mem_lo_o;
            mem_whilo_o <= mem_whilo_o;
        end
    end
    else begin
        mem_waddr_reg_o <= ex_waddr_reg_i;
        mem_we_reg_o <= ex_we_reg_i;
        mem_wdata_o <= ex_wdata_i;
        mem_hi_o <= ex_hi_i;                                                          
        mem_lo_o <= ex_lo_i;
        mem_whilo_o <= ex_whilo_i;
    end
end

endmodule