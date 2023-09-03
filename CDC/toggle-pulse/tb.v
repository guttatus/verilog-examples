module tb ();

reg send_clk;
reg rev_clk;
reg rst_n;
reg pulse;

initial begin
  send_clk = 1;
  rst_n = 0;
  #10 rst_n = 1;
end

always #2 send_clk = ~send_clk;

initial begin
  rev_clk = 1;
  #1;
  forever #5 rev_clk = ~rev_clk; 
end

reg [3:0] cnt;

always @(posedge send_clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt <= 2'b0;
  end
  else begin
    if(cnt == 3'b111) begin
      cnt <= 0;
    end
    else begin
      cnt <= cnt + 1;
    end
  end
end

reg [8:0] data_in;
reg [8:0] data_out;

always @(posedge send_clk or negedge rst_n) begin
  if(!rst_n) begin
    pulse <= 1'b0;
    data_in <=0;
  end
  else begin
    if(cnt == 2'b0) begin
      pulse <= 1'b1;
      data_in <= data_in + 1;
    end
    else begin
      pulse <= 1'b0;
    end
  end
end

wire enable;

clk_domain_send clk_domain_send_inst (
  .clk(send_clk),
  .rst_n(rst_n),
  .pulse(pulse),
  .enable (enable),
  .data_in(data_in),
  .data_out(data_out)
);


reg [8:0] rev_data_out;

clk_domain_rev clk_domain_rev_inst(
  .clk(rev_clk),
  .rst_n(rst_n),
  .enable(enable),
  .data_in(data_out),
  .data_out(rev_data_out)
);

initial begin
    $fsdbDumpfile("top_tb.fsdb");
    $fsdbDumpvars(0,"tb");
end

initial begin
  #200 $finish();
end

endmodule
