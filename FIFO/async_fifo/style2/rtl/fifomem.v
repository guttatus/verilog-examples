module fifomem #(
  parameter DSIZE  = 16,
  parameter ASIZE = 256
) (
  input              wclk,
  input              wen,
  input              wfull,
  input  [DSIZE-1:0] wdata,
  input  [ASIZE-1:0] waddr,
  input  [ASIZE-1:0] raddr,
  output [DSIZE-1:0] rdata
);
localparam DEEPTH = 1<<ASIZE;

reg [DSIZE-1:0] mem [DEEPTH-1:0];

assign rdata = mem[raddr];

always @(posedge wclk) begin
  if(wen && !wfull) begin
    mem[waddr] <= wdata;
  end
end
endmodule
