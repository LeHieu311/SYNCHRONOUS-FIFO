class driver;

    mailbox mbx;
    event   done;

    transaction t;

    virtual tb_fifo_sync_inf #(DATA_WIDTH) vif;

    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction


    task run();

        forever begin

            mbx.get(t);

            // Drive signals at falling edge.
            // DUT samples them at the next rising edge.
            @(negedge vif.clk);

            vif.rst_n = t.rst_n;
            vif.wr_en = t.wr_en;
            vif.rd_en = t.rd_en;
            vif.din   = t.din;

            @(posedge vif.clk);

            -> done;

        end

    endtask

endclass
