module sync_w2r #(
  parameter ASIZE = 4
)(
  input                rclk,
  input                rrst_n,
  input [ASIZE:0]      wptr,
  output reg [ASIZE:0] rq2_wptr
);

reg [ASIZE:0] rq1_wptr;

always @(posedge rclk or negedge rrst_n) begin
  if(!rrst_n) begin
    {rq2_wptr,rq1_wptr} <= 0;
  end
  else begin
    {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
  end
end
endmodule
