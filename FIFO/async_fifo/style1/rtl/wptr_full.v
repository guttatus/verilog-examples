module wptr_full #(
  parameter ASIZE = 4
) (
  input                wclk,
  input                wrst_n,
  input                winc,
  input [ASIZE:0]      wq2_rptr,
  output [ASIZE-1:0]   waddr,
  output reg           wfull,
  output reg [ASIZE:0] wptr
);

reg [ASIZE:0] wbin;
wire [ASIZE:0] wgraynext;
wire [ASIZE:0] wbinnext;

assign waddr = wbin[ASIZE-1:0];

always @(posedge wclk or negedge wrst_n) begin
  if(!wrst_n) begin
    {wbin,wptr} <= 0;
  end
  else begin
    {wbin,wptr} <= {wbinnext,wgraynext};
  end
end

assign wbinnext = wbin + (winc && ~wfull);
assign wgraynext = (wbinnext>>1) ^ wbinnext;

wire wfull_val;
assign wfull_val = (wgraynext == {~wq2_rptr[ASIZE:ASIZE-1],wq2_rptr[ASIZE-2:0]});

always @(posedge wclk or negedge wrst_n) begin
  if(!wrst_n) begin
    wfull <= 0;
  end
  else begin
    wfull <= wfull_val;
  end
end

endmodule
