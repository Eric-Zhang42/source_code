`include "defines.v"

module sopc(
    input clk,
    input rst,
    input wire in,
    output reg [1:0] led
);

wire[`InstAddrBus] inst_addr;
(*keep = "true"*) wire[`InstBus] inst;
wire rom_ce;

wire out;

//实例化my_mips_cpu
my_mips_cpu my_mips_cpu_inst0(
    .clk(clk),
    .rst(rst),
    .rom_data_i(inst),
    .rom_addr_o(inst_addr),
    .rom_ce_o(rom_ce),
    .in(in),
    .out(out)
);


//实例化ROM
rom_program rom_program_inst0(
    .clk(clk),
    .rom_addr_i(inst_addr),
    .rom_ce_i(rom_ce),
    .rom_data_o(inst)
);

always @(posedge(clk)) begin
    case (out) //取数据的高四位，相当于除以2的12次方
    1:  led[1:0] <= 2'b11; 
    default: led[1:0] <= 2'b10; 
    endcase
end

endmodule