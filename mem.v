
`include "defines.v"

module mem(
    input rst,
    
    //执行阶段信息
    input wire[`RegAddrBus] waddr_reg_i,
    input wire we_reg_i,
    input wire[`RegBus] wdata_i,

    input wire[`DataAddrBus] mem_addr_i,
    input wire [`AluOpBus]aluop_i,      //8bits
    input wire [`DataBus]mem_data_i,
    input wire [`RegBus]reg2_i,         //叫reg是因为数据来自于寄存器堆，这里`RegBus 和 `DataBus 其实是一样的

    //访存后结果
    output reg[`RegAddrBus] waddr_reg_o,
    output reg we_reg_o,
    output reg[`RegBus] wdata_o,

    output reg [`DataAddrBus] mem_addr_o,
    output reg[`DataBus] mem_data_o,
    output reg [`SelBus] mem_sel_o,     //4bits
    output reg mem_ce_o,
    output reg mem_we_o

);

always@(*)begin     //与reg和ram交互
    if(rst == `RstEnable) begin
        waddr_reg_o = `NOPRegAddr;
        we_reg_o = `WriteDisable;
        wdata_o = `ZeroWord;

        mem_addr_o = `ZeroWord;
        mem_data_o = `ZeroWord;
        mem_sel_o = 4'b0000;
        mem_ce_o = `ChipDisable;
        mem_we_o = `WriteDisable;
        
    end
    else begin      //设置默认状态，默认不读写ram，而是只与寄存器堆regfile交互
        waddr_reg_o = waddr_reg_i;
        we_reg_o = we_reg_i;
        wdata_o = wdata_i;

        mem_ce_o = `ChipDisable;    //默认不与ram进行读写
        mem_we_o = `WriteDisable;   //默认读
        mem_addr_o = `ZeroWord;
        mem_data_o = `ZeroWord;
        mem_sel_o = 4'b1111;        //默认读写整个字4Byte
        case (aluop_i)
            `MEM_LB_OP:begin
                mem_ce_o = `ChipEnable;
                mem_we_o = `WriteDisable;
                mem_addr_o = mem_addr_i;
                case(mem_addr_i[1:0])
                    2'b00:begin
                        mem_sel_o = 4'b1000;
                        wdata_o = {{24{mem_data_i[31]}}, mem_data_i[31:24]};
                    end
                    2'b01:begin
                        mem_sel_o = 4'b0100;
                        wdata_o = {{24{mem_data_i[23]}}, mem_data_i[23:16]};
                    end
                    2'b10:begin
                        mem_sel_o = 4'b0010;
                        wdata_o = {{24{mem_data_i[15]}}, mem_data_i[15:8]};
                    end
                    2'b11:begin
                        mem_sel_o = 4'b0001;
                        wdata_o = {{24{mem_data_i[7]}}, mem_data_i[7:0]};
                    end
                    default:wdata_o = `ZeroWord;   //这里理论是不会执行的
                endcase
            end
            `MEM_LBU_OP:begin
                mem_ce_o = `ChipEnable;
                mem_we_o = `WriteDisable;
                mem_addr_o = mem_addr_i;
                case(mem_addr_i[1:0])
                    2'b00:begin
                        mem_sel_o = 4'b1000;
                        wdata_o = {24'b0, mem_data_i[31:24]};
                    end
                    2'b01:begin
                        mem_sel_o = 4'b0100;
                        wdata_o = {24'b0, mem_data_i[23:16]};
                    end
                    2'b10:begin
                        mem_sel_o = 4'b0010;
                        wdata_o = {24'b0, mem_data_i[15:8]};
                    end
                    2'b11:begin
                        mem_sel_o = 4'b0001;
                        wdata_o = {24'b0, mem_data_i[7:0]};
                    end
                    default:wdata_o = `ZeroWord;   //这里理论是不会执行的
                endcase
            end
            `MEM_LH_OP:begin
                mem_ce_o = `ChipEnable;
                mem_we_o = `WriteDisable;
                mem_addr_o = mem_addr_i;
                case(mem_addr_i[1:0])
                    2'b00:begin
                        mem_sel_o = 4'b1100;
                        wdata_o = {{16{mem_data_i[31]}}, mem_data_i[31:16]};
                    end
                    2'b10:begin
                        mem_sel_o = 4'b0011;
                        wdata_o = {{16{mem_data_i[15]}}, mem_data_i[15:0]};
                    end
                    default:wdata_o = `ZeroWord;   //这里理论是不会执行的
                endcase
            end
            `MEM_LHU_OP:begin
                mem_ce_o = `ChipEnable;
                mem_we_o = `WriteDisable;
                mem_addr_o = mem_addr_i;
                case(mem_addr_i[1:0])
                    2'b00:begin
                        mem_sel_o = 4'b1100;
                        wdata_o = {16'b0, mem_data_i[31:16]};
                    end
                    2'b10:begin
                        mem_sel_o = 4'b0011;
                        wdata_o = {16'b0, mem_data_i[15:0]};
                    end
                    default:wdata_o = `ZeroWord;   //这里理论是不会执行的
                endcase
            end
            `MEM_LW_OP:begin
                mem_ce_o = `ChipEnable;
                mem_we_o = `WriteDisable;
                mem_addr_o = mem_addr_i;
                mem_sel_o = 4'b1111;
            end
            `MEM_SB_OP:begin
                mem_addr_o = mem_addr_i;
                mem_ce_o = `ChipEnable;
                mem_we_o = `WriteEnable;
                mem_data_o = {reg2_i[7:0],reg2_i[7:0],reg2_i[7:0],reg2_i[7:0]};
                case(mem_addr_i[1:0])
                    2'b00:mem_sel_o = 4'b1000;
                    2'b01:mem_sel_o = 4'b0100;
                    2'b10:mem_sel_o = 4'b0010;
                    2'b11:mem_sel_o = 4'b0001;
                    default:mem_sel_o = 4'b0000;    //这里理论是不会执行的
                endcase
            end
            `MEM_SH_OP:begin
                mem_addr_o = mem_addr_i;
                mem_ce_o = `ChipEnable;
                mem_we_o = `WriteEnable;
                mem_data_o = {reg2_i[15:0],reg2_i[15:0]};
                case(mem_addr_i[1:0])
                    2'b00:mem_sel_o = 4'b1100;
                    2'b10:mem_sel_o = 4'b0011;
                    default:mem_sel_o = 4'b0000;    //这里理论是不会执行的
                endcase
            end
            `MEM_SW_OP:begin
                mem_addr_o = mem_addr_i;
                mem_sel_o = 4'b1111;
                mem_ce_o = `ChipEnable;
                mem_we_o = `WriteEnable;
                mem_data_o = reg2_i;
            end
            default:begin   
            end
        endcase
    end
end

endmodule