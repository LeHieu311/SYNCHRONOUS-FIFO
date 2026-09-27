class transaction;

    // Request sent to DUT
    bit                  rst_n;
    bit                  wr_en;
    bit                  rd_en;
    bit [DATA_WIDTH-1:0] din;

    // Values observed by Monitor
    // full/empty are sampled at the clock edge BEFORE DUT updates its state.
    bit                  full;
    bit                  empty;
    bit [DATA_WIDTH-1:0] dout;

endclass
