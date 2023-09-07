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

wire [ASIZE-1:0] rptr;
wire [ASIZE-1:0] wptr;
wire [ASIZE-1:0] wq2_rptr;
wire [ASIZE-1:0] rq2_wptr;
wire aempty_n;
wire afull_n;

async_cmp #(ASIZE) async_cmp_inst (
  .wrst_n(wrst_n),
  .wptr(wptr),
  .rptr(rptr),
  .aempty_n(aempty_n),
  .afull_n(afull_n)
);


rptr_empty #(ASIZE) rptr_empty_inst (
  .rclk(rclk),
  .rrst_n(rrst_n),
  .rinc(rinc),
  .aempty_n(aempty_n),
  .raddr(raddr),
  .rempty(rempty),
  .rptr(rptr)
);

wptr_full #(ASIZE) wptr_full_inst (
  .wclk(wclk),
  .wrst_n(wrst_n),
  .winc(winc),
  .afull_n(afull_n),
  .waddr(waddr),
  .wfull(wfull),
  .wptr(wptr)
);


endmodule
