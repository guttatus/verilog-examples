module rptr_empty #(
  parameter ASIZE  = 4
) (
  input                rclk,
  input                rrst_n,
  input                rinc,
  input  [ASIZE:0]     rq2_wptr,
  output [ASIZE-1:0]   raddr,
  output reg           rempty,
  output reg [ASIZE:0] rptr
);

reg [ASIZE:0] rbin;
wire [ASIZE:0] rgraynext;
wire [ASIZE:0] rbinnext;

always @(posedge rclk or negedge rrst_n) begin
  if(!rrst_n) begin
    {rbin, rptr} <= 0;
  end
  else begin
    {rbin, rptr} <= {rbinnext, rgraynext};
  end
end

assign raddr = rbin[ASIZE-1:0];
assign rgraynext = (rbinnext>>1) ^ rbinnext;
assign rbinnext = rbin + (rinc && ~rempty);

wire rempty_val;
assign rempty_val = (rgraynext == rq2_wptr);
  
always @(posedge rclk or negedge rrst_n) begin
  if(!rrst_n) begin
    rempty <= 1'b1;
  end
  else begin
    rempty <= rempty_val;
  end
end


endmodule
