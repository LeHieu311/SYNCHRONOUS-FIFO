package tc_package;

    import tb_fifo_sync_pkg::*;


    // ============================================================
    // TC-01: RESET
    // ============================================================
    task tc_01_reset(generator gen);

        $display("");
        $display("=================================");
        $display(" TC-01: RESET");
        $display("=================================");

        // Đưa FIFO về trạng thái ban đầu
        gen.reset_fifo();

        // Ghi một ít dữ liệu
        gen.write(8'hA5);
        gen.write(8'hB6);

        // Reset lại
        // Dữ liệu A5, B6 phải bị mất hiệu lực
        gen.reset_fifo();

        // Thử đọc sau reset
        // FIFO đang empty nên dout phải = 0
        gen.read();

    endtask



    // ============================================================
    // TC-02: NORMAL WRITE
    // ============================================================
    task tc_02_normal_write(generator gen);

        $display("");
        $display("=================================");
        $display(" TC-02: NORMAL WRITE");
        $display("=================================");

        gen.reset_fifo();

        gen.write(8'hA5);
        gen.write(8'hB6);
        gen.write(8'hC7);

    endtask



    // ============================================================
    // TC-03: FILL FIFO TO FULL
    // ============================================================
    task tc_03_fill_to_full(generator gen);

        $display("");
        $display("=================================");
        $display(" TC-03: FILL FIFO TO FULL");
        $display("=================================");

        gen.reset_fifo();

        // Ghi đúng DEPTH phần tử
        for (int i = 0; i < DEPTH; i++) begin
            gen.write(i);
        end

        // Sau lần write cuối:
        // full phải = 1

    endtask



    // ============================================================
    // TC-04: WRITE WHILE FULL
    // ============================================================
    task tc_04_write_while_full(generator gen);

        $display("");
        $display("=================================");
        $display(" TC-04: WRITE WHILE FULL");
        $display("=================================");

        gen.reset_fifo();

        // Fill FIFO
        for (int i = 0; i < DEPTH; i++) begin
            gen.write(i);
        end

        // FIFO đã full
        // Write này phải bị reject
        gen.write(8'hFF);

    endtask



    // ============================================================
    // TC-05: NORMAL READ
    // ============================================================
    task tc_05_normal_read(generator gen);

        $display("");
        $display("=================================");
        $display(" TC-05: NORMAL READ");
        $display("=================================");

        gen.reset_fifo();

        gen.write(8'hA5);
        gen.write(8'hB6);
        gen.write(8'hC7);

        // Expected order:
        // A5 -> B6 -> C7
        gen.read();
        gen.read();
        gen.read();

    endtask



    // ============================================================
    // TC-06: READ WHILE EMPTY
    // ============================================================
    task tc_06_read_while_empty(generator gen);

        $display("");
        $display("=================================");
        $display(" TC-06: READ WHILE EMPTY");
        $display("=================================");

        gen.reset_fifo();

        // FIFO đang empty
        // Read này phải bị reject
        // dout phải = 0
        gen.read();

    endtask



    // ============================================================
    // TC-07: SIMULTANEOUS READ + WRITE
    // ============================================================
    task tc_07_simultaneous_rw(generator gen);

        $display("");
        $display("=================================");
        $display(" TC-07: SIMULTANEOUS READ/WRITE");
        $display("=================================");

        gen.reset_fifo();

        gen.write(8'hA5);
        gen.write(8'hB6);

        // Trước:
        // FIFO = [A5, B6]
        //
        // read  -> A5
        // write -> C7
        //
        // Sau:
        // FIFO = [B6, C7]

        gen.read_write(8'hC7);

    endtask



    // ============================================================
    // TC-08: READ + WRITE WHEN FULL
    // ============================================================
    task tc_08_rw_when_full(generator gen);

        $display("");
        $display("=================================");
        $display(" TC-08: READ/WRITE WHEN FULL");
        $display("=================================");

        gen.reset_fifo();

        // Fill FIFO
        for (int i = 0; i < DEPTH; i++) begin
            gen.write(i);
        end

        // FIFO đang full
        //
        // read  -> accepted
        // write -> rejected
        gen.read_write(8'hFF);

    endtask



    // ============================================================
    // TC-09: READ + WRITE WHEN EMPTY
    // ============================================================
    task tc_09_rw_when_empty(generator gen);

        $display("");
        $display("=================================");
        $display(" TC-09: READ/WRITE WHEN EMPTY");
        $display("=================================");

        gen.reset_fifo();

        // FIFO đang empty
        //
        // read  -> rejected
        // write -> accepted
        //
        // Sau operation:
        // FIFO chứa A5
        gen.read_write(8'hA5);

    endtask



    // ============================================================
    // TC-10: FIFO ORDER / WRAP-AROUND
    // ============================================================
    task tc_10_ordering_wraparound(generator gen);

        $display("");
        $display("=================================");
        $display(" TC-10: ORDERING / WRAP-AROUND");
        $display("=================================");

        gen.reset_fifo();


        // --------------------------------
        // Fill FIFO
        // --------------------------------
        for (int i = 0; i < DEPTH; i++) begin
            gen.write(i);
        end


        // --------------------------------
        // Read một nửa FIFO
        // --------------------------------
        for (int i = 0; i < DEPTH/2; i++) begin
            gen.read();
        end


        // --------------------------------
        // Write thêm dữ liệu
        // Pointer bên trong DUT có thể wrap
        // --------------------------------
        for (int i = 0; i < DEPTH/2; i++) begin
            gen.write(8'h80 + i);
        end


        // --------------------------------
        // Read hết dữ liệu còn lại
        // Scoreboard kiểm tra ordering
        // --------------------------------
        for (int i = 0; i < DEPTH; i++) begin
            gen.read();
        end

    endtask


endpackage