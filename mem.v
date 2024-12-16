
`include "defines.v"

module mem(
    input rst,
    
    //ִ�н׶���Ϣ
    input wire[`RegAddrBus] waddr_reg_i,
    input wire we_reg_i,
    input wire[`RegBus] wdata_i,

    //�ô����
    output reg[`RegAddrBus] waddr_reg_o,
    output reg we_reg_o,
    output reg[`RegBus] wdata_o

);

always@(*) begin
    waddr_reg_o = waddr_reg_i;
    we_reg_o = we_reg_i;
    wdata_o = wdata_i;
end


endmodule