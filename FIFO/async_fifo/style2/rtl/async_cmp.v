module async_cmp #(
  parameter ASIZE = 4
) (
  input [ASIZE-1:0] wptr,
  input [ASIZE-1:0] rptr,
  input wrst_n,
  output aempty_n,
  output afull_n
);

localparam N = ASIZE - 1;
reg direction;
wire high;
assign high = 1'b1;

wire dirset_n;
wire dirclr_n;
assign dirset_n = ~(  (wptr[N]^rptr[N-1]) && ~(wptr[N-1]^rptr[N]));
assign dirclr_n = ~((~(wptr[N]^rptr[N-1]) &&  (wptr[N-1]^rptr[N])) | ~wrst_n);


always @(posedge high or negedge dirclr_n or negedge dirset_n) begin
  if(!dirclr_n) begin
    direction <= 1'b0;
  end
  else if(!dirset_n) begin
    direction <= 1'b1;
  end
  else begin
    direction <= high;
  end
end

assign aempty_n = ~((wptr == rptr) && !direction);
assign afull_n  = ~((wptr == rptr) &&  direction);

endmodule
