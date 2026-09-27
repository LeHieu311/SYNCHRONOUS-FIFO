class environment;

    generator  gen;
    driver     drv;
    monitor    mon;
    scoreboard sco;

    mailbox gdmbx;
    mailbox msmbx;

    event done;

    virtual tb_fifo_sync_inf #(DATA_WIDTH) vif;


    function new();

        gdmbx = new();
        msmbx = new();

        gen = new(gdmbx);
        drv = new(gdmbx);

        mon = new(msmbx);
        sco = new(msmbx);

    endfunction


    task run();

        // Generator and Driver share the same event.
        gen.done = done;
        drv.done = done;

        // Driver and Monitor share the same interface.
        drv.vif = vif;
        mon.vif = vif;

        fork
            drv.run();
            mon.run();
            sco.run();
        join_none

    endtask

endclass
