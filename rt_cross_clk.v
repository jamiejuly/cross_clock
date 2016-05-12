module rt_cross_clk(
    //lbus domain------------------------------
    input rt_i_lbus_clk,
    input rt_i_rst,
    //local bus decoder
    input         rt_i_reg_update_lclk,
    input         rt_i_reg_mode_dbg,
    input [1:0]   rt_i_reg_ai_ctrl,
    input [6:0]   rt_i_reg_ai_conv_intv,
    input [12:0]  rt_i_reg_di_th,               //0x060
    output [7:0]  rt_o_reg_di_data,
    input [13:0]  rt_i_reg_test_const,          //0x0C4
    input [15:0]  rt_i_reg_ch1_offset,          //0x020
    input [15:0]  rt_i_reg_ch1_gain,                //0x020
    input [15:0]  rt_i_reg_ch2_offset,          //0x024
    input [15:0]  rt_i_reg_ch2_gain,                //0x024
    input [15:0]  rt_i_reg_ch3_offset,          //0x028
    input [15:0]  rt_i_reg_ch3_gain,            //0x028
    input [15:0]  rt_i_reg_ch4_offset,          //0x02C
    input [15:0]  rt_i_reg_ch4_gain,            //0x02C
    input [15:0]  rt_i_reg_ch5_offset,          //0x030
    input [15:0]  rt_i_reg_ch5_gain,            //0x030
    input [15:0]  rt_i_reg_ch6_offset,          //0x034
    input [15:0]  rt_i_reg_ch6_gain,            //0x034
    input [15:0]  rt_i_reg_ch7_offset,          //0x038
    input [15:0]  rt_i_reg_ch7_gain,            //0x038
    input [15:0]  rt_i_reg_ch8_offset,          //0x03C
    input [15:0]  rt_i_reg_ch8_gain,            //0x03C
    output [13:0] rt_o_reg_v1_data,             //0x040
    output [13:0] rt_o_reg_v2_data,             //0x044
    output [13:0] rt_o_reg_v3_data,             //0x048
    output [13:0] rt_o_reg_v4_data,             //0x04C
    output [13:0] rt_o_reg_v5_data,             //0x050
    output [13:0] rt_o_reg_v6_data,             //0x054
    output [13:0] rt_o_reg_v7_data,             //0x058
    output [13:0] rt_o_reg_v8_data,             //0x05C
    output [30:0] rt_o_reg_dbg,
    //osc domain-------------------------------
    //ai_top
    input           rt_i_osc_clk,
    input           rt_i_ai_update_oclk,
    output reg      rt_o_rst,
    output          rt_o_reg_mode_dbg,
    output [1:0]    rt_o_reg_ai_ctrl,
    output [6:0]    rt_o_reg_ai_conv_intv,
    output [12:0]   rt_o_reg_di_th,             //0x060
    input  [7:0]    rt_i_reg_di_data,           //0x064
    output [13:0]   rt_o_reg_test_const,            //0x0C4
    output [15:0]   rt_o_reg_ch1_offset,            //0x020
    output [15:0]   rt_o_reg_ch1_gain,              //0x020
    output [15:0]   rt_o_reg_ch2_offset,            //0x024
    output [15:0]   rt_o_reg_ch2_gain,              //0x024
    output [15:0]   rt_o_reg_ch3_offset,            //0x028
    output [15:0]   rt_o_reg_ch3_gain,          //0x028
    output [15:0]   rt_o_reg_ch4_offset,        //0x02C
    output [15:0]   rt_o_reg_ch4_gain,          //0x02C
    output [15:0]   rt_o_reg_ch5_offset,            //0x030
    output [15:0]   rt_o_reg_ch5_gain,          //0x030
    output [15:0]   rt_o_reg_ch6_offset,        //0x034
    output [15:0]   rt_o_reg_ch6_gain,          //0x034
    output [15:0]   rt_o_reg_ch7_offset,            //0x038
    output [15:0]   rt_o_reg_ch7_gain,          //0x038
    output [15:0]   rt_o_reg_ch8_offset,        //0x03C
    output [15:0]   rt_o_reg_ch8_gain,          //0x03C
    input  [13:0]   rt_i_reg_v1_data,           //0x040
    input  [13:0]   rt_i_reg_v2_data,           //0x044
    input  [13:0]   rt_i_reg_v3_data,           //0x048
    input  [13:0]   rt_i_reg_v4_data,           //0x04C
    input  [13:0]   rt_i_reg_v5_data,           //0x050
    input  [13:0]   rt_i_reg_v6_data,           //0x054
    input  [13:0]   rt_i_reg_v7_data,           //0x058
    input  [13:0]   rt_i_reg_v8_data,           //0x05C
    input  [30:0]   rt_i_reg_dbg
);


reg         rt_r_rst_lclk = 1'b0;
reg  [1:0]  rt_r_reg_mode_dbg             = 2'd0;
reg  [30:0] rt_r_reg_dbg_d1     = 31'd0;
reg  [30:0] rt_r_reg_dbg_d2 = 31'd0;

wire [291:0] rt_w_reg_lclk;
wire [291:0] rt_w_reg_oclk;

wire [119:0] rt_w_ai_oclk;
wire [119:0] rt_w_ai_lclk;

always@(posedge rt_i_lbus_clk) begin
  if(rt_r_rst_lclk)
    rt_r_rst_lclk <= ~rt_o_rst; //rt_o_rst TIG to rt_w_lclk
  else
    rt_r_rst_lclk <= rt_i_rst;
end

assign rt_o_reg_mode_dbg = rt_r_reg_mode_dbg[1];
always@(posedge rt_i_osc_clk) begin
  rt_o_rst            <= rt_r_rst_lclk; //rt_r_rst_lclk TIG to rt_i_osc_clk
  rt_r_reg_mode_dbg   <= {rt_r_reg_mode_dbg[0], rt_i_reg_mode_dbg};
end

assign rt_o_reg_dbg     = rt_r_reg_dbg_d2;
always@(posedge rt_i_lbus_clk) begin
  rt_r_reg_dbg_d1     <= rt_i_reg_dbg;
  rt_r_reg_dbg_d2     <= rt_r_reg_dbg_d1;
end

assign rt_w_reg_lclk = {rt_i_reg_di_th,
                        rt_i_reg_ai_conv_intv,
                        rt_i_reg_ch8_gain,
                        rt_i_reg_ch7_gain,
                        rt_i_reg_ch6_gain,
                        rt_i_reg_ch5_gain,
                        rt_i_reg_ch4_gain,
                        rt_i_reg_ch3_gain,
                        rt_i_reg_ch2_gain,
                        rt_i_reg_ch1_gain,
                        rt_i_reg_ch8_offset,
                        rt_i_reg_ch7_offset,
                        rt_i_reg_ch6_offset,
                        rt_i_reg_ch5_offset,
                        rt_i_reg_ch4_offset,
                        rt_i_reg_ch3_offset,
                        rt_i_reg_ch2_offset,
                        rt_i_reg_ch1_offset,
                        rt_i_reg_test_const,
                        rt_i_reg_ai_ctrl};

assign rt_o_reg_ai_ctrl      = rt_w_reg_oclk[  1:  0];
assign rt_o_reg_test_const   = rt_w_reg_oclk[ 15:  2];
assign rt_o_reg_ch1_offset   = rt_w_reg_oclk[ 31: 16];
assign rt_o_reg_ch2_offset   = rt_w_reg_oclk[ 47: 32];
assign rt_o_reg_ch3_offset   = rt_w_reg_oclk[ 63: 48];
assign rt_o_reg_ch4_offset   = rt_w_reg_oclk[ 79: 64];
assign rt_o_reg_ch5_offset   = rt_w_reg_oclk[ 95: 80];
assign rt_o_reg_ch6_offset   = rt_w_reg_oclk[111: 96];
assign rt_o_reg_ch7_offset   = rt_w_reg_oclk[127:112];
assign rt_o_reg_ch8_offset   = rt_w_reg_oclk[143:128];
assign rt_o_reg_ch1_gain     = rt_w_reg_oclk[159:144];
assign rt_o_reg_ch2_gain     = rt_w_reg_oclk[175:160];
assign rt_o_reg_ch3_gain     = rt_w_reg_oclk[191:176];
assign rt_o_reg_ch4_gain     = rt_w_reg_oclk[207:192];
assign rt_o_reg_ch5_gain     = rt_w_reg_oclk[223:208];
assign rt_o_reg_ch6_gain     = rt_w_reg_oclk[239:224];
assign rt_o_reg_ch7_gain     = rt_w_reg_oclk[255:240];
assign rt_o_reg_ch8_gain     = rt_w_reg_oclk[271:256];
assign rt_o_reg_ai_conv_intv = rt_w_reg_oclk[278:272];
assign rt_o_reg_di_th        = rt_w_reg_oclk[291:279];

rt_cross_clk_de #(
 .DWIDTH(292)
)u0_cross_clk_de(
    .rt_i_aclk(rt_i_lbus_clk),
    .rt_i_de_aclk(rt_i_reg_update_lclk),
    .rt_i_din_aclk(rt_w_reg_lclk),
    .rt_o_busy_aclk(),
    .rt_i_bclk(rt_i_osc_clk),
    .rt_o_de_bclk(),
    .rt_o_dout_bclk(rt_w_reg_oclk)
    );

rt_cross_clk_de #(
 .DWIDTH(120)
)u1_cross_clk_de(
    .rt_i_aclk(rt_i_osc_clk),
    .rt_i_de_aclk(rt_i_ai_update_oclk),
    .rt_i_din_aclk(rt_w_ai_oclk),
    .rt_o_busy_aclk(),
    .rt_i_bclk(rt_i_lbus_clk),
    .rt_o_de_bclk(),
    .rt_o_dout_bclk(rt_w_ai_lclk)
    );

assign rt_w_ai_oclk = { rt_i_reg_v8_data,
                        rt_i_reg_v7_data,
                        rt_i_reg_v6_data,
                        rt_i_reg_v5_data,
                        rt_i_reg_v4_data,
                        rt_i_reg_v3_data,
                        rt_i_reg_v2_data,
                        rt_i_reg_v1_data,
                        rt_i_reg_di_data};

assign rt_o_reg_di_data = rt_w_ai_lclk[  7:  0];
assign rt_o_reg_v1_data = rt_w_ai_lclk[ 21:  8];
assign rt_o_reg_v2_data = rt_w_ai_lclk[ 35: 22];
assign rt_o_reg_v3_data = rt_w_ai_lclk[ 49: 36];
assign rt_o_reg_v4_data = rt_w_ai_lclk[ 63: 50];
assign rt_o_reg_v5_data = rt_w_ai_lclk[ 77: 64];
assign rt_o_reg_v6_data = rt_w_ai_lclk[ 91: 78];
assign rt_o_reg_v7_data = rt_w_ai_lclk[105: 92];
assign rt_o_reg_v8_data = rt_w_ai_lclk[119:106];

endmodule
