`timescale 1ns/1ps

interface tb_fifo_sync_inf #(
    parameter int DATA_WIDTH = 8
)();

    logic clk;
    logic rst_n;

    logic wr_en;
    logic rd_en;

    logic [DATA_WIDTH-1:0] din;
    logic [DATA_WIDTH-1:0] dout;

    logic full;
    logic empty;

endinterface
