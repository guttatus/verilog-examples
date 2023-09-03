module clk_domain_send (
  input            clk,
  input            rst_n,
  input            pulse,
  input      [8:0] data_in,
  output reg [8:0] data_out,
  output reg       enable
);

wire d;

assign d = pulse ^ enable;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    enable <= 0;
  end
  else begin
    enable <= d;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    data_out <= 0;
  end
  else begin
    if(pulse) begin
      data_out <= data_in;
    end
    else begin
      data_out <= data_out;
    end
  end
end

endmodule


module clk_domain_rev (
  input clk,
  input rst_n,
  input enable,
  input [8:0] data_in,
  output reg [8:0] data_out

);

reg q1;
reg q2;
reg q3;
wire load_enable;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    q1 <= 0;
    q2 <= 0;
    q3 <= 0;
  end
  else begin
    {q3,q2,q1} <= {q2,q1,enable};
  end
end

assign load_enable = q2 ^q3;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    data_out <= 0;
  end
  else begin
    if(load_enable) begin
      data_out <= data_in;
    end
    else begin
      data_out <= data_out;
    end
  end
end

endmodule





