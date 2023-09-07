module read_fast_write_slow();

localparam DSIZE = 8;
localparam ASIZE = 4;
reg wclk, rclk;
reg wrst_n, rrst_n;
reg winc, rinc;
reg wfull, rempty;
reg [DSIZE-1:0] wdata;
reg [DSIZE-1:0] rdata;

initial begin : wclk_gen
  wclk = 0;
  forever begin
    #5 wclk = ~wclk;
  end
end

initial begin : rclk_gen 
  rclk = 0;
  #1
  forever begin
    #2 rclk = ~rclk;
  end
end

initial begin : rst_n_gen
  wrst_n = 0;
  rrst_n = 0;
  #16;
  wrst_n = 1;
  rrst_n = 1;
end

always @(posedge wclk or negedge wrst_n) begin : write_data
  if(!wrst_n) begin
    wdata <= 0;
    winc <= 0;
  end
  else begin
    if(wfull) begin
      wdata <= wdata;
    end
    else begin
      wdata <= wdata+1;
    end
    winc <= 1;
  end
end

always @(posedge rclk or negedge rrst_n) begin : read_data
  if(!rrst_n) begin
    rinc <= 0; 
  end
  else begin
    rinc <= 1;
  end
end


initial begin : dump_wave
  $fsdbDumpfile("read_fast_write_slow.fsdb");
  $fsdbDumpvars(0,"read_fast_write_slow");
end

initial begin : finsh
  #1000 $finish();
end

async_fifo #(
  .DSIZE(DSIZE),
  .ASIZE(ASIZE)
) async_fifo_inst (
  .wclk(wclk),
  .wrst_n(wrst_n),
  .winc(winc),
  .wdata(wdata),
  .wfull(wfull),
  .rclk(rclk),
  .rrst_n(rrst_n),
  .rinc(rinc),
  .rempty(rempty),
  .rdata(rdata)
);

endmodule
