module wptr_full #(
  parameter ASIZE = 4
) (
  input                  wclk,
  input                  wrst_n,
  input                  winc,
  input                  afull_n,
  output [ASIZE-1:0]     waddr,
  output reg             wfull,
  output reg [ASIZE-1:0] wptr
);

reg  [ASIZE-1:0] wbin;
wire [ASIZE-1:0] wgraynext;
wire [ASIZE-1:0] wbinnext;

assign waddr = wbin;

always @(posedge wclk or negedge wrst_n) begin
  if(!wrst_n) begin
    {wbin,wptr} <= 0;
  end
  else begin
    {wbin,wptr} <= {wbinnext,wgraynext};
  end
end

assign wbinnext = !wfull ? wbin + winc : wbin;
assign wgraynext = (wbinnext>>1) ^ wbinnext;


reg wfull2;
always @(posedge wclk or negedge afull_n or negedge wrst_n) begin
  if(!wrst_n) begin
    {wfull, wfull2} <= 2'b00;
  end
  if(!afull_n) begin
    {wfull, wfull2} <= 2'b11;
  end
  else begin
    {wfull, wfull2} <= {wfull2,~afull_n};
  end
end

endmodule
