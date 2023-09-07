module rptr_empty #(
  parameter ASIZE  = 4
) (
  input                rclk,
  input                rrst_n,
  input                rinc,
  input                aempty_n,
  output [ASIZE-1:0]   raddr,
  output reg           rempty,
  output reg [ASIZE-1:0] rptr
);

reg [ASIZE-1:0] rbin;
wire [ASIZE-1:0] rgraynext;
wire [ASIZE-1:0] rbinnext;

always @(posedge rclk or negedge rrst_n) begin
  if(!rrst_n) begin
    {rbin, rptr} <= 0;
  end
  else begin
    {rbin, rptr} <= {rbinnext, rgraynext};
  end
end

assign raddr = rbin;
assign rgraynext = (rbinnext>>1) ^ rbinnext;
assign rbinnext = !rempty ? rbin + rinc : rbin;

  
reg rempty2;
always @(posedge rclk or negedge aempty_n) begin
  if(!aempty_n) begin
    {rempty,rempty2} <= 2'b11;
  end
  else begin
    {rempty,rempty2} <= {rempty2,~aempty_n};
  end
end


endmodule
