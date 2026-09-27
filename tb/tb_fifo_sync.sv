`timescale 1ns/1ps

module tb_fifo_sync;

    import tb_fifo_sync_pkg::*;

    environment env;

    tb_fifo_sync_inf #(.DATA_WIDTH(DATA_WIDTH)) vif();


    fifo_sync #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk   (vif.clk),
        .rst_n (vif.rst_n),
        .wr_en (vif.wr_en),
        .rd_en (vif.rd_en),
        .din   (vif.din),
        .dout  (vif.dout),
        .full  (vif.full),
        .empty (vif.empty)
    );


    always #5ns vif.clk = ~vif.clk;


    initial begin

        vif.clk   = 0;
        vif.rst_n = 0;
        vif.wr_en = 0;
        vif.rd_en = 0;
        vif.din   = 0;

        env = new();

        env.vif = vif;

        env.run();

        // Run testcase
        tc_package::tc_04_write_while_full(env.gen);


        env.gen.idle();

        #1ns;

        env.sco.report();

        $finish;

    end

endmodule