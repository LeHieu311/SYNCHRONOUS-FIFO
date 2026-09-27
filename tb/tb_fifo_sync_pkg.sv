package tb_fifo_sync_pkg;

    parameter int DATA_WIDTH = 8;
    parameter int DEPTH      = 8;

    `include "tb_fifo_sync_trans.sv"
    `include "tb_fifo_sync_gen.sv"
    `include "tb_fifo_sync_drv.sv"
    `include "tb_fifo_sync_mon.sv"
    `include "tb_fifo_sync_sco.sv"
    `include "tb_fifo_sync_env.sv"

endpackage
