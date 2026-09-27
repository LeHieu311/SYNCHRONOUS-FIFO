class generator;

    mailbox mbx;
    event   done;

    transaction t;

    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction


    task send(
        bit                  rst_n,
        bit                  wr_en,
        bit                  rd_en,
        bit [DATA_WIDTH-1:0] din
    );

        t = new();

        t.rst_n = rst_n;
        t.wr_en = wr_en;
        t.rd_en = rd_en;
        t.din   = din;

        mbx.put(t);

        // Wait until Driver has applied this transaction to DUT.
        @(done);

    endtask


    task reset_fifo();
        send(1'b0, 1'b0, 1'b0, '0);
        send(1'b0, 1'b0, 1'b0, '0);
        send(1'b1, 1'b0, 1'b0, '0);
    endtask


    task write(bit [DATA_WIDTH-1:0] data);
        send(1'b1, 1'b1, 1'b0, data);
    endtask


    task read();
        send(1'b1, 1'b0, 1'b1, '0);
    endtask


    task read_write(bit [DATA_WIDTH-1:0] data);
        send(1'b1, 1'b1, 1'b1, data);
    endtask


    task idle();
        send(1'b1, 1'b0, 1'b0, '0);
    endtask

endclass
