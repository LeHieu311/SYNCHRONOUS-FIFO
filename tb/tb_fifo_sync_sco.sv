class scoreboard;

    mailbox mbx;
    transaction t;

    // FIFO giả của Scoreboard
    bit [DATA_WIDTH-1:0] fifo_model[$];

    bit [DATA_WIDTH-1:0] expected_dout;

    bit read_ok;
    bit write_ok;

    integer error_count = 0;


    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction


    task run();

        forever begin

            // Nhận transaction từ Monitor
            mbx.get(t);


            // ====================================================
            // RESET
            // ====================================================
            if (t.rst_n == 1'b0) begin

                // Sau reset, FIFO phải rỗng
                fifo_model.delete();

                if (t.dout !== 0) begin
                    $display("[SCO] RESET FAIL: dout should be 0");
                    error_count++;
                end

                if (t.empty !== 1'b1) begin
                    $display("[SCO] RESET FAIL: empty should be 1");
                    error_count++;
                end

                if (t.full !== 1'b0) begin
                    $display("[SCO] RESET FAIL: full should be 0");
                    error_count++;
                end

            end


            // ====================================================
            // NORMAL OPERATION
            // ====================================================
            else begin

                // ------------------------------------------------
                // STEP 1:
                // Dựa vào FIFO giả để quyết định operation
                // có hợp lệ hay không
                // ------------------------------------------------

                read_ok =
                    t.rd_en &&
                    (fifo_model.size() > 0);

                write_ok =
                    t.wr_en &&
                    (fifo_model.size() < DEPTH);


                // ------------------------------------------------
                // STEP 2: READ
                // ------------------------------------------------

                if (read_ok) begin

                    // Lấy dữ liệu cũ nhất trong FIFO giả
                    expected_dout = fifo_model.pop_front();

                    // So sánh với DUT
                    if (t.dout === expected_dout) begin

                        $display(
                            "[SCO] READ PASS: dout = %h",
                            t.dout
                        );

                    end
                    else begin

                        $display(
                            "[SCO] READ FAIL: expected = %h, actual = %h",
                            expected_dout,
                            t.dout
                        );

                        error_count++;

                    end

                end


                // ------------------------------------------------
                // READ WHILE EMPTY
                // ------------------------------------------------

                else if (t.rd_en) begin

                    // Theo spec của bài này:
                    // read khi empty -> dout = 0

                    if (t.dout === 0) begin

                        $display(
                            "[SCO] READ EMPTY PASS"
                        );

                    end
                    else begin

                        $display(
                            "[SCO] READ EMPTY FAIL: dout should be 0"
                        );

                        error_count++;

                    end

                end


                // ------------------------------------------------
                // STEP 3: WRITE
                // ------------------------------------------------

                if (write_ok) begin

                    // Thêm dữ liệu vào cuối FIFO giả
                    fifo_model.push_back(t.din);

                    $display(
                        "[SCO] WRITE: %h",
                        t.din
                    );

                end


                // ------------------------------------------------
                // WRITE WHILE FULL
                // ------------------------------------------------

                else if (t.wr_en) begin

                    $display(
                        "[SCO] WRITE REJECTED: FIFO FULL"
                    );

                end


                // ------------------------------------------------
                // STEP 4:
                // Sau khi cập nhật FIFO giả,
                // check trạng thái EMPTY của DUT
                // ------------------------------------------------

                if (
                    t.empty !==
                    (fifo_model.size() == 0)
                ) begin

                    $display(
                        "[SCO] EMPTY FLAG FAIL"
                    );

                    error_count++;

                end


                // ------------------------------------------------
                // Check trạng thái FULL của DUT
                // ------------------------------------------------

                if (
                    t.full !==
                    (fifo_model.size() == DEPTH)
                ) begin

                    $display(
                        "[SCO] FULL FLAG FAIL"
                    );

                    error_count++;

                end

            end

        end

    endtask


    // ============================================================
    // FINAL REPORT
    // ============================================================

    function void report();

        $display("");
        $display("----------------------------------------");

        if (error_count == 0)
            $display("TEST RESULT: PASS");
        else
            $display(
                "TEST RESULT: FAIL - %0d error(s)",
                error_count
            );

        $display("----------------------------------------");
        $display("");

    endfunction


endclass