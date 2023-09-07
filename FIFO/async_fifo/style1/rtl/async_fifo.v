module async_fifo #(
  parameter DSIZE  = 16,
  parameter ASIZE = 256
) (
  // write
  input                  wclk,
  input                  wrst_n,
  input                  winc,
  input [DSIZE-1:0]      wdata,
  output                 wfull,

  // read 
  input                  rclk,
  input                  rrst_n,
  input                  rinc,
  output                 rempty,
  output [DSIZE-1:0]     rdata
);

wire [ASIZE-1:0] waddr;
wire [ASIZE-1:0] raddr;
wire [DSIZE-1:0] rdata_val;

assign rdata = rempty ? 0 : rdata_val;

fifomem #(
    .DSIZE(DSIZE),
    .ASIZE(ASIZE) 
) fifomem_inst (
  .wclk(wclk),
  .wen(winc),
  .wfull(wfull),
  .wdata(wdata),
  .waddr(waddr),
  .raddr(raddr),
  .rdata(rdata_val)
);

wire [ASIZE:0] rptr;
wire [ASIZE:0] wptr;
wire [ASIZE:0] wq2_rptr;
wire [ASIZE:0] rq2_wptr;

sync_r2w #(ASIZE) sync_r2w_inst (
  .wclk(wclk),
  .wrst_n(wrst_n),
  .rptr(rptr),
  .wq2_rptr(wq2_rptr)
);
          

sync_w2r #(ASIZE) sync_w2r_inst (
  .rclk(rclk),
  .rrst_n(rrst_n),
  .wptr(wptr),
  .rq2_wptr(rq2_wptr)
);

rptr_empty #(ASIZE) rptr_empty_inst (
  .rclk(rclk),
  .rrst_n(rrst_n),
  .rinc(rinc),
  .rq2_wptr(rq2_wptr),
  .raddr(raddr),
  .rempty(rempty),
  .rptr(rptr)
);

wptr_full #(ASIZE) wptr_full_inst (
  .wclk(wclk),
  .wrst_n(wrst_n),
  .winc(winc),
  .wq2_rptr(wq2_rptr),
  .waddr(waddr),
  .wfull(wfull),
  .wptr(wptr)
);


endmodule
