`include "defines.v"

module ram_program(
    input clk,
    input wire [`SelBus] sel,

    input wire ram_ce_i,        //读写使能
    input wire ram_we_i,        //写使能
    input wire[`DataAddrBus] ram_addr_i,
    input wire [`DataBus] ram_data_i,

    output reg [`DataBus] ram_data_o
);

reg [`ByteWidth] data_mem0 [0:`DataMemNum-1];
reg [`ByteWidth] data_mem1 [0:`DataMemNum-1];
reg [`ByteWidth] data_mem2 [0:`DataMemNum-1];
reg [`ByteWidth] data_mem3 [0:`DataMemNum-1];

wire [`DataMemNumLog2-1 : 0] ram_addr_real_div4;
assign ram_addr_real_div4 = ram_addr_i[`DataMemNumLog2+1 : 2];

always @(posedge clk) begin
    if(ram_ce_i == `ChipDisable) ram_data_o <= `ZeroWord;
    else begin
        if(ram_we_i == `WriteEnable) begin  //写操作
            if(sel[3] == 1'b1) data_mem0[ram_addr_real_div4] <= ram_data_i[31:24];
            if(sel[2] == 1'b1) data_mem1[ram_addr_real_div4] <= ram_data_i[23:16];
            if(sel[1] == 1'b1) data_mem2[ram_addr_real_div4] <= ram_data_i[15:8];
            if(sel[0] == 1'b1) data_mem3[ram_addr_real_div4] <= ram_data_i[7:0];
        end //end of if(ram_we_i == `WriteEnable)
        else begin                          //读操作
            ram_data_o <= {data_mem3[ram_addr_real_div4],
                        data_mem2[ram_addr_real_div4],
                        data_mem1[ram_addr_real_div4],
                        data_mem0[ram_addr_real_div4]};
        end //end of else
    end     //end of if(ram_ce_i == `ChipDisable)
end


endmodule