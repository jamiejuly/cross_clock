module rt_cross_clk_de #(
  parameter DWIDTH = 8
)(
  //A clock domain
  input                     rt_i_aclk,
  input                     rt_i_de_aclk,
  input      [DWIDTH - 1:0] rt_i_din_aclk,
  output                    rt_o_busy_aclk,
  //B clock domain
  input                     rt_i_bclk, 
  output reg                rt_o_de_bclk,
  output reg [DWIDTH - 1:0] rt_o_dout_bclk = 0
  );

reg                 rt_r_de_tog_aclk = 1'b0;
reg [DWIDTH - 1:0]  rt_r_din_d1_aclk = 0;
reg [1:0]           rt_r_sr_aclk     = 2'd0; 

reg [2:0] rt_r_sr_bclk = 3'd0;
wire      rt_w_de_bclk;

assign rt_o_busy_aclk = rt_r_sr_aclk[1]^rt_r_de_tog_aclk;
always@(posedge rt_i_aclk) begin
  rt_r_de_tog_aclk <=  rt_r_de_tog_aclk^(rt_i_de_aclk&~rt_o_busy_aclk);
  
  if(~rt_o_busy_aclk)
    rt_r_din_d1_aclk <=  rt_i_din_aclk;

  rt_r_sr_aclk <= {rt_r_sr_aclk[0], rt_r_sr_bclk[2]}; //rt_r_sr_bclk[2] TIG
end

assign    rt_w_de_bclk = rt_r_sr_bclk[2]^rt_r_sr_bclk[1]; 
always@(posedge rt_i_bclk) begin
  rt_r_sr_bclk <= {rt_r_sr_bclk[1:0], rt_r_de_tog_aclk}; //rt_r_de_tog_aclk TIG
  rt_o_de_bclk <= rt_w_de_bclk;

  if(rt_w_de_bclk)
    rt_o_dout_bclk <= rt_r_din_d1_aclk;
end

endmodule



