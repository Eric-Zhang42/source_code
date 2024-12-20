`include "defines.v"

module sopc(
    input clk,
    input rst
);

wire[`InstAddrBus] inst_addr;
(*keep = "true"*) wire[`InstBus] inst;
wire rom_ce;

wire[`DataAddrBus] data_addr;
wire[`DataBus] cpu2ram__data;
wire[`DataBus] ram2cpu__data;
wire[`SelBus] ram_sel;
wire ram_we;
wire ram_ce;

//实例化my_mips_cpu
my_mips_cpu my_mips_cpu_inst0(
    .clk(clk),
    .rst(rst),
    .ram_data_i(ram2cpu__data),
    .rom_data_i(inst),
    //<-in out->
    .rom_addr_o(inst_addr),
    .rom_ce_o(rom_ce),
    .ram_addr_o(data_addr),
    .ram_data_o(cpu2ram__data),
    .ram_we_o(ram_we),
    .ram_sel_o(ram_sel),
    .ram_ce_o(ram_ce)
);


//实例化ROM
rom_program rom_program_inst0(
    .clk(clk),
    .rom_addr_i(inst_addr),
    .rom_ce_i(rom_ce),
    .rom_data_o(inst)
);

//实例化RAM
ram_data ram_data_inst0(
    .clk(clk),
    .ram_addr_i(data_addr),
    .ram_data_i(cpu2ram__data),
    .ram_we_i(ram_we),
    .ram_sel_i(ram_sel),
    .ram_ce_i(ram_ce),
    //<-in out->
    .ram_data_o(ram2cpu__data)
);

endmodule