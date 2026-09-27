# FIFO Sync - Simple Class-Based SystemVerilog Testbench

Mục tiêu của project này là giúp sinh viên nhìn rõ toàn bộ flow trước khi học UVM.



## Thư mục

```text
rtl/
  fifo_sync.sv

tb/
  tb_fifo_sync.sv       # top
  tb_fifo_sync_inf.sv   # interface
  tb_fifo_sync_trans.sv # transaction
  tb_fifo_sync_gen.sv   # generator
  tb_fifo_sync_drv.sv   # driver
  tb_fifo_sync_mon.sv   # monitor
  tb_fifo_sync_sco.sv   # scoreboard
  tb_fifo_sync_env.sv   # environment
  tb_fifo_sync_pkg.sv   # gom các class TB

tc/
  tc_00_template.sv
  tc_01_reset.sv
  ...
  tc_10_ordering_wraparound.sv
```

## Chạy

Lần đầu:

```bash
make init
```

Chạy một testcase:

```bash
make all TESTNAME=tc_01_reset
make all TESTNAME=tc_04_write_while_full
make all TESTNAME=tc_07_simultaneous_rw
```

Mở waveform:

```bash
make all_wave TESTNAME=tc_07_simultaneous_rw
```

## Ý nghĩa từng khối

- Transaction: chứa thông tin của một giao dịch.
- Generator: tạo transaction.
- Driver: transaction -> signal.
- Interface: bó tín hiệu nối testbench với DUT.
- Monitor: signal -> transaction.
- Scoreboard: so sánh DUT với reference model.
- Environment: gom Generator/Driver/Monitor/Scoreboard.
- Testcase: mô tả scenario cần test.

## Ghi chú timing của Monitor

`full` và `empty` được Monitor lấy ngay tại `posedge`, tức trạng thái trước khi DUT cập nhật register ở NBA.
`dout` được lấy sau `#1ps` để thấy output sau clock edge.

Điều này giúp các case biên như "write while full" và "read while empty" được kiểm tra đúng mà không cần nhìn bộ nhớ bên trong DUT.
