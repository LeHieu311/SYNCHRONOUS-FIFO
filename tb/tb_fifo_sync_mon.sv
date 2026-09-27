class monitor;

    mailbox mbx;

    virtual tb_fifo_sync_inf #(DATA_WIDTH) vif;

    transaction t;


    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction


    task run();

        forever begin

            @(posedge vif.clk);

            t = new();

            // Request được DUT sample tại posedge
            t.rst_n = vif.rst_n;
            t.wr_en = vif.wr_en;
            t.rd_en = vif.rd_en;
            t.din   = vif.din;

            // Chờ DUT update register
            #1ps;

            // Kết quả SAU operation
            t.dout  = vif.dout;
            t.full  = vif.full;
            t.empty = vif.empty;

            mbx.put(t);

        end

    endtask

endclass