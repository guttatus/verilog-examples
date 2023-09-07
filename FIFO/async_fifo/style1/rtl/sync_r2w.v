module sync_r2w #(
  parameter ASIZE = 4
) (
  input                wclk,
  input                wrst_n,
  input [ASIZE:0]      rptr,
  output reg [ASIZE:0] wq2_rptr
);
reg [ASIZE:0] wq1_rptr;

always @(posedge wclk or negedge wrst_n) begin
  if(!wrst_n) begin
    {wq2_rptr,wq1_rptr} <= 0;
  end
  else begin
    {wq2_rptr, wq1_rptr} <= {wq1_rptr,rptr};
  end
end
endmodule
