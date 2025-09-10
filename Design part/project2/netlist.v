// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Tue Sep  9 15:48:47 2025
// Host        : DESKTOP-QONJRA3 running 64-bit major release  (build 9200)
// Command     : write_verilog -force netlist.v
// Design      : SPI_Wrapper
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module RAM
   (tx_valid,
    dout0,
    MISO_reg,
    rst_n,
    rx_valid,
    \rx_data_reg[8] ,
    clk_IBUF_BUFG,
    Q,
    mem,
    out,
    \counter_reg[2] ,
    E,
    \rx_data_reg[9] ,
    \rx_data_reg[9]_0 ,
    \rx_data_reg[9]_1 ,
    \rx_data_reg[9]_2 ,
    \rx_data_reg[9]_3 ,
    \rx_data_reg[9]_4 ,
    \rx_data_reg[9]_5 ,
    \rx_data_reg[9]_6 );
  output tx_valid;
  output [7:0]dout0;
  output MISO_reg;
  input rst_n;
  input rx_valid;
  input \rx_data_reg[8] ;
  input clk_IBUF_BUFG;
  input [7:0]Q;
  input mem;
  input [0:0]out;
  input [2:0]\counter_reg[2] ;
  input [0:0]E;
  input \rx_data_reg[9] ;
  input \rx_data_reg[9]_0 ;
  input \rx_data_reg[9]_1 ;
  input \rx_data_reg[9]_2 ;
  input \rx_data_reg[9]_3 ;
  input \rx_data_reg[9]_4 ;
  input \rx_data_reg[9]_5 ;
  input \rx_data_reg[9]_6 ;

  wire [0:0]E;
  wire MISO_i_3_n_0;
  wire MISO_i_4_n_0;
  wire MISO_reg;
  wire [7:0]Q;
  wire [7:0]addr;
  wire clk_IBUF_BUFG;
  wire [2:0]\counter_reg[2] ;
  wire [7:0]dout0;
  wire mem;
  wire [0:0]out;
  wire rst_n;
  wire \rx_data_reg[8] ;
  wire \rx_data_reg[9] ;
  wire \rx_data_reg[9]_0 ;
  wire \rx_data_reg[9]_1 ;
  wire \rx_data_reg[9]_2 ;
  wire \rx_data_reg[9]_3 ;
  wire \rx_data_reg[9]_4 ;
  wire \rx_data_reg[9]_5 ;
  wire \rx_data_reg[9]_6 ;
  wire rx_valid;
  wire [7:0]tx_data;
  wire tx_valid;

  LUT4 #(
    .INIT(16'hA0C0)) 
    MISO_i_2
       (.I0(MISO_i_3_n_0),
        .I1(MISO_i_4_n_0),
        .I2(out),
        .I3(\counter_reg[2] [2]),
        .O(MISO_reg));
  LUT6 #(
    .INIT(64'hCACAFFF0CACA0F00)) 
    MISO_i_3
       (.I0(tx_data[2]),
        .I1(tx_data[0]),
        .I2(\counter_reg[2] [1]),
        .I3(tx_data[3]),
        .I4(\counter_reg[2] [0]),
        .I5(tx_data[1]),
        .O(MISO_i_3_n_0));
  LUT6 #(
    .INIT(64'hCACAFFF0CACA0F00)) 
    MISO_i_4
       (.I0(tx_data[6]),
        .I1(tx_data[4]),
        .I2(\counter_reg[2] [1]),
        .I3(tx_data[7]),
        .I4(\counter_reg[2] [0]),
        .I5(tx_data[5]),
        .O(MISO_i_4_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \addr_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .D(Q[0]),
        .Q(addr[0]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \addr_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .D(Q[1]),
        .Q(addr[1]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \addr_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .D(Q[2]),
        .Q(addr[2]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \addr_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .D(Q[3]),
        .Q(addr[3]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \addr_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .D(Q[4]),
        .Q(addr[4]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \addr_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .D(Q[5]),
        .Q(addr[5]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \addr_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .D(Q[6]),
        .Q(addr[6]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \addr_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .D(Q[7]),
        .Q(addr[7]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \dout_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(rx_valid),
        .D(\rx_data_reg[9]_6 ),
        .Q(tx_data[0]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \dout_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(rx_valid),
        .D(\rx_data_reg[9]_5 ),
        .Q(tx_data[1]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \dout_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(rx_valid),
        .D(\rx_data_reg[9]_4 ),
        .Q(tx_data[2]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \dout_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(rx_valid),
        .D(\rx_data_reg[9]_3 ),
        .Q(tx_data[3]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \dout_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(rx_valid),
        .D(\rx_data_reg[9]_2 ),
        .Q(tx_data[4]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \dout_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(rx_valid),
        .D(\rx_data_reg[9]_1 ),
        .Q(tx_data[5]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \dout_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(rx_valid),
        .D(\rx_data_reg[9]_0 ),
        .Q(tx_data[6]),
        .R(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \dout_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(rx_valid),
        .D(\rx_data_reg[9] ),
        .Q(tx_data[7]),
        .R(rst_n));
  RAM256X1S #(
    .INIT(256'h0000000000000000000000000000000000000000000000000000000000000000)) 
    mem_reg_0_255_0_0
       (.A(addr),
        .D(Q[0]),
        .O(dout0[0]),
        .WCLK(clk_IBUF_BUFG),
        .WE(mem));
  RAM256X1S #(
    .INIT(256'h0000000000000000000000000000000000000000000000000000000000000000)) 
    mem_reg_0_255_1_1
       (.A(addr),
        .D(Q[1]),
        .O(dout0[1]),
        .WCLK(clk_IBUF_BUFG),
        .WE(mem));
  RAM256X1S #(
    .INIT(256'h0000000000000000000000000000000000000000000000000000000000000000)) 
    mem_reg_0_255_2_2
       (.A(addr),
        .D(Q[2]),
        .O(dout0[2]),
        .WCLK(clk_IBUF_BUFG),
        .WE(mem));
  RAM256X1S #(
    .INIT(256'h0000000000000000000000000000000000000000000000000000000000000000)) 
    mem_reg_0_255_3_3
       (.A(addr),
        .D(Q[3]),
        .O(dout0[3]),
        .WCLK(clk_IBUF_BUFG),
        .WE(mem));
  RAM256X1S #(
    .INIT(256'h0000000000000000000000000000000000000000000000000000000000000000)) 
    mem_reg_0_255_4_4
       (.A(addr),
        .D(Q[4]),
        .O(dout0[4]),
        .WCLK(clk_IBUF_BUFG),
        .WE(mem));
  RAM256X1S #(
    .INIT(256'h0000000000000000000000000000000000000000000000000000000000000000)) 
    mem_reg_0_255_5_5
       (.A(addr),
        .D(Q[5]),
        .O(dout0[5]),
        .WCLK(clk_IBUF_BUFG),
        .WE(mem));
  RAM256X1S #(
    .INIT(256'h0000000000000000000000000000000000000000000000000000000000000000)) 
    mem_reg_0_255_6_6
       (.A(addr),
        .D(Q[6]),
        .O(dout0[6]),
        .WCLK(clk_IBUF_BUFG),
        .WE(mem));
  RAM256X1S #(
    .INIT(256'h0000000000000000000000000000000000000000000000000000000000000000)) 
    mem_reg_0_255_7_7
       (.A(addr),
        .D(Q[7]),
        .O(dout0[7]),
        .WCLK(clk_IBUF_BUFG),
        .WE(mem));
  FDRE #(
    .INIT(1'b0)) 
    tx_valid_reg
       (.C(clk_IBUF_BUFG),
        .CE(rx_valid),
        .D(\rx_data_reg[8] ),
        .Q(tx_valid),
        .R(rst_n));
endmodule

module SPI_Slave
   (out,
    MISO_OBUF,
    SR,
    rx_valid,
    \dout_reg[0] ,
    Q,
    \dout_reg[1] ,
    \dout_reg[2] ,
    \dout_reg[3] ,
    \dout_reg[4] ,
    \dout_reg[5] ,
    \dout_reg[6] ,
    \dout_reg[7] ,
    \counter_reg[2]_0 ,
    tx_valid_reg,
    E,
    mem,
    \FSM_gray_state_crnt_reg[1]_0 ,
    CLK,
    dout0,
    tx_valid,
    rst_n_IBUF,
    SS_n_IBUF,
    MOSI_IBUF);
  output [0:0]out;
  output MISO_OBUF;
  output [0:0]SR;
  output rx_valid;
  output \dout_reg[0] ;
  output [7:0]Q;
  output \dout_reg[1] ;
  output \dout_reg[2] ;
  output \dout_reg[3] ;
  output \dout_reg[4] ;
  output \dout_reg[5] ;
  output \dout_reg[6] ;
  output \dout_reg[7] ;
  output [2:0]\counter_reg[2]_0 ;
  output tx_valid_reg;
  output [0:0]E;
  output mem;
  input \FSM_gray_state_crnt_reg[1]_0 ;
  input CLK;
  input [7:0]dout0;
  input tx_valid;
  input rst_n_IBUF;
  input SS_n_IBUF;
  input MOSI_IBUF;

  wire \<const1> ;
  wire CLK;
  wire [0:0]E;
  wire \FSM_gray_state_crnt_reg[1]_0 ;
  wire MISO_OBUF;
  wire MISO_i_1_n_0;
  wire MOSI_IBUF;
  wire [7:0]Q;
  wire [0:0]SR;
  wire SS_n_IBUF;
  wire counter;
  wire \counter[0]_i_1_n_0 ;
  wire \counter[1]_i_1_n_0 ;
  wire \counter[2]_i_1_n_0 ;
  wire \counter[3]_i_2_n_0 ;
  wire \counter[3]_i_3_n_0 ;
  wire [2:0]\counter_reg[2]_0 ;
  wire \counter_reg_n_0_[3] ;
  wire [7:0]dout0;
  wire \dout_reg[0] ;
  wire \dout_reg[1] ;
  wire \dout_reg[2] ;
  wire \dout_reg[3] ;
  wire \dout_reg[4] ;
  wire \dout_reg[5] ;
  wire \dout_reg[6] ;
  wire \dout_reg[7] ;
  wire mem;
  (* RTL_KEEP = "yes" *) wire [0:0]out;
  wire read_addr_i_1_n_0;
  wire read_addr_i_2_n_0;
  wire read_addr_i_4_n_0;
  wire read_addr_i_5_n_0;
  wire read_addr_i_6_n_0;
  wire read_addr_reg_n_0;
  wire rst_n_IBUF;
  wire [9:8]rx_data;
  wire \rx_data[9]_i_1_n_0 ;
  wire [9:0]rx_data__0;
  wire rx_valid;
  wire rx_valid4_out__0;
  wire rx_valid_i_1_n_0;
  wire rx_valid_i_2_n_0;
  (* RTL_KEEP = "yes" *) wire [2:0]state_crnt;
  wire [2:0]state_nxt;
  wire tx_valid;
  wire tx_valid_reg;

  LUT6 #(
    .INIT(64'h0000FFFF00009DDD)) 
    \FSM_gray_state_crnt[0]_i_1 
       (.I0(out),
        .I1(state_crnt[0]),
        .I2(MOSI_IBUF),
        .I3(read_addr_reg_n_0),
        .I4(SS_n_IBUF),
        .I5(state_crnt[2]),
        .O(state_nxt[0]));
  LUT4 #(
    .INIT(16'h00FE)) 
    \FSM_gray_state_crnt[1]_i_1 
       (.I0(out),
        .I1(state_crnt[0]),
        .I2(state_crnt[2]),
        .I3(SS_n_IBUF),
        .O(state_nxt[1]));
  LUT1 #(
    .INIT(2'h1)) 
    \FSM_gray_state_crnt[2]_i_1 
       (.I0(rst_n_IBUF),
        .O(SR));
  LUT6 #(
    .INIT(64'h00000000AAAAAAEA)) 
    \FSM_gray_state_crnt[2]_i_2 
       (.I0(state_crnt[2]),
        .I1(MOSI_IBUF),
        .I2(state_crnt[0]),
        .I3(read_addr_reg_n_0),
        .I4(out),
        .I5(SS_n_IBUF),
        .O(state_nxt[2]));
  (* FSM_ENCODED_STATES = "CHK_CMD:001,WRITE:011,READ_ADD:111,READ_DATA:010,IDLE:000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_gray_state_crnt_reg[0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(state_nxt[0]),
        .Q(state_crnt[0]),
        .R(SR));
  (* FSM_ENCODED_STATES = "CHK_CMD:001,WRITE:011,READ_ADD:111,READ_DATA:010,IDLE:000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_gray_state_crnt_reg[1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(state_nxt[1]),
        .Q(out),
        .R(SR));
  (* FSM_ENCODED_STATES = "CHK_CMD:001,WRITE:011,READ_ADD:111,READ_DATA:010,IDLE:000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_gray_state_crnt_reg[2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(state_nxt[2]),
        .Q(state_crnt[2]),
        .R(SR));
  LUT5 #(
    .INIT(32'h000000D5)) 
    MISO_i_1
       (.I0(out),
        .I1(read_addr_reg_n_0),
        .I2(tx_valid),
        .I3(state_crnt[2]),
        .I4(state_crnt[0]),
        .O(MISO_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    MISO_reg
       (.C(CLK),
        .CE(MISO_i_1_n_0),
        .D(\FSM_gray_state_crnt_reg[1]_0 ),
        .Q(MISO_OBUF),
        .R(SR));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \addr[7]_i_1 
       (.I0(rx_valid),
        .I1(rx_data[8]),
        .O(E));
  LUT3 #(
    .INIT(8'h20)) 
    \counter[0]_i_1 
       (.I0(out),
        .I1(\counter_reg[2]_0 [0]),
        .I2(\counter[3]_i_3_n_0 ),
        .O(\counter[0]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2800)) 
    \counter[1]_i_1 
       (.I0(out),
        .I1(\counter_reg[2]_0 [0]),
        .I2(\counter_reg[2]_0 [1]),
        .I3(\counter[3]_i_3_n_0 ),
        .O(\counter[1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h2A800000)) 
    \counter[2]_i_1 
       (.I0(out),
        .I1(\counter_reg[2]_0 [0]),
        .I2(\counter_reg[2]_0 [1]),
        .I3(\counter_reg[2]_0 [2]),
        .I4(\counter[3]_i_3_n_0 ),
        .O(\counter[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h04AE00AF05050505)) 
    \counter[3]_i_1 
       (.I0(state_crnt[0]),
        .I1(read_addr_reg_n_0),
        .I2(state_crnt[2]),
        .I3(rx_valid),
        .I4(tx_valid),
        .I5(out),
        .O(counter));
  LUT6 #(
    .INIT(64'h2AAA800000000000)) 
    \counter[3]_i_2 
       (.I0(out),
        .I1(\counter_reg[2]_0 [0]),
        .I2(\counter_reg[2]_0 [1]),
        .I3(\counter_reg[2]_0 [2]),
        .I4(\counter_reg_n_0_[3] ),
        .I5(\counter[3]_i_3_n_0 ),
        .O(\counter[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFBFFFFFFFF4FFFFF)) 
    \counter[3]_i_3 
       (.I0(state_crnt[0]),
        .I1(tx_valid),
        .I2(\counter_reg_n_0_[3] ),
        .I3(\counter_reg[2]_0 [2]),
        .I4(\counter_reg[2]_0 [0]),
        .I5(\counter_reg[2]_0 [1]),
        .O(\counter[3]_i_3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[0] 
       (.C(CLK),
        .CE(counter),
        .D(\counter[0]_i_1_n_0 ),
        .Q(\counter_reg[2]_0 [0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[1] 
       (.C(CLK),
        .CE(counter),
        .D(\counter[1]_i_1_n_0 ),
        .Q(\counter_reg[2]_0 [1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[2] 
       (.C(CLK),
        .CE(counter),
        .D(\counter[2]_i_1_n_0 ),
        .Q(\counter_reg[2]_0 [2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[3] 
       (.C(CLK),
        .CE(counter),
        .D(\counter[3]_i_2_n_0 ),
        .Q(\counter_reg_n_0_[3] ),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \dout[0]_i_1 
       (.I0(rx_data[9]),
        .I1(rx_data[8]),
        .I2(dout0[0]),
        .O(\dout_reg[0] ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \dout[1]_i_1 
       (.I0(rx_data[9]),
        .I1(rx_data[8]),
        .I2(dout0[1]),
        .O(\dout_reg[1] ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \dout[2]_i_1 
       (.I0(rx_data[9]),
        .I1(rx_data[8]),
        .I2(dout0[2]),
        .O(\dout_reg[2] ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \dout[3]_i_1 
       (.I0(rx_data[9]),
        .I1(rx_data[8]),
        .I2(dout0[3]),
        .O(\dout_reg[3] ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \dout[4]_i_1 
       (.I0(rx_data[9]),
        .I1(rx_data[8]),
        .I2(dout0[4]),
        .O(\dout_reg[4] ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \dout[5]_i_1 
       (.I0(rx_data[9]),
        .I1(rx_data[8]),
        .I2(dout0[5]),
        .O(\dout_reg[5] ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \dout[6]_i_1 
       (.I0(rx_data[9]),
        .I1(rx_data[8]),
        .I2(dout0[6]),
        .O(\dout_reg[6] ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \dout[7]_i_1 
       (.I0(rx_data[9]),
        .I1(rx_data[8]),
        .I2(dout0[7]),
        .O(\dout_reg[7] ));
  LUT4 #(
    .INIT(16'h0800)) 
    mem_reg_0_255_0_0_i_1
       (.I0(rx_valid),
        .I1(rst_n_IBUF),
        .I2(rx_data[9]),
        .I3(rx_data[8]),
        .O(mem));
  LUT6 #(
    .INIT(64'hAABFBFBFAA808080)) 
    read_addr_i_1
       (.I0(read_addr_i_2_n_0),
        .I1(rx_valid4_out__0),
        .I2(read_addr_i_4_n_0),
        .I3(read_addr_i_5_n_0),
        .I4(read_addr_i_6_n_0),
        .I5(read_addr_reg_n_0),
        .O(read_addr_i_1_n_0));
  LUT3 #(
    .INIT(8'hE0)) 
    read_addr_i_2
       (.I0(state_crnt[2]),
        .I1(rx_valid),
        .I2(state_crnt[0]),
        .O(read_addr_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000400)) 
    read_addr_i_3
       (.I0(\counter_reg[2]_0 [1]),
        .I1(\counter_reg[2]_0 [0]),
        .I2(\counter_reg[2]_0 [2]),
        .I3(\counter_reg_n_0_[3] ),
        .I4(rx_valid),
        .O(rx_valid4_out__0));
  LUT2 #(
    .INIT(4'h8)) 
    read_addr_i_4
       (.I0(state_crnt[0]),
        .I1(out),
        .O(read_addr_i_4_n_0));
  LUT3 #(
    .INIT(8'h40)) 
    read_addr_i_5
       (.I0(\counter_reg_n_0_[3] ),
        .I1(out),
        .I2(\counter_reg[2]_0 [2]),
        .O(read_addr_i_5_n_0));
  LUT6 #(
    .INIT(64'h0000000000008000)) 
    read_addr_i_6
       (.I0(\counter_reg[2]_0 [1]),
        .I1(\counter_reg[2]_0 [0]),
        .I2(read_addr_reg_n_0),
        .I3(tx_valid),
        .I4(state_crnt[2]),
        .I5(state_crnt[0]),
        .O(read_addr_i_6_n_0));
  FDRE #(
    .INIT(1'b0)) 
    read_addr_reg
       (.C(CLK),
        .CE(\<const1> ),
        .D(read_addr_i_1_n_0),
        .Q(read_addr_reg_n_0),
        .R(SR));
  LUT2 #(
    .INIT(4'h8)) 
    \rx_data[0]_i_1 
       (.I0(out),
        .I1(MOSI_IBUF),
        .O(rx_data__0[0]));
  LUT2 #(
    .INIT(4'h8)) 
    \rx_data[1]_i_1 
       (.I0(out),
        .I1(Q[0]),
        .O(rx_data__0[1]));
  LUT2 #(
    .INIT(4'h8)) 
    \rx_data[2]_i_1 
       (.I0(out),
        .I1(Q[1]),
        .O(rx_data__0[2]));
  LUT2 #(
    .INIT(4'h8)) 
    \rx_data[3]_i_1 
       (.I0(out),
        .I1(Q[2]),
        .O(rx_data__0[3]));
  LUT2 #(
    .INIT(4'h8)) 
    \rx_data[4]_i_1 
       (.I0(out),
        .I1(Q[3]),
        .O(rx_data__0[4]));
  LUT2 #(
    .INIT(4'h8)) 
    \rx_data[5]_i_1 
       (.I0(out),
        .I1(Q[4]),
        .O(rx_data__0[5]));
  LUT2 #(
    .INIT(4'h8)) 
    \rx_data[6]_i_1 
       (.I0(out),
        .I1(Q[5]),
        .O(rx_data__0[6]));
  LUT2 #(
    .INIT(4'h8)) 
    \rx_data[7]_i_1 
       (.I0(out),
        .I1(Q[6]),
        .O(rx_data__0[7]));
  LUT2 #(
    .INIT(4'h8)) 
    \rx_data[8]_i_1 
       (.I0(out),
        .I1(Q[7]),
        .O(rx_data__0[8]));
  LUT5 #(
    .INIT(32'h0A0B1111)) 
    \rx_data[9]_i_1 
       (.I0(state_crnt[0]),
        .I1(state_crnt[2]),
        .I2(rx_valid),
        .I3(tx_valid),
        .I4(out),
        .O(\rx_data[9]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \rx_data[9]_i_2 
       (.I0(out),
        .I1(rx_data[8]),
        .O(rx_data__0[9]));
  FDRE #(
    .INIT(1'b0)) 
    \rx_data_reg[0] 
       (.C(CLK),
        .CE(\rx_data[9]_i_1_n_0 ),
        .D(rx_data__0[0]),
        .Q(Q[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rx_data_reg[1] 
       (.C(CLK),
        .CE(\rx_data[9]_i_1_n_0 ),
        .D(rx_data__0[1]),
        .Q(Q[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rx_data_reg[2] 
       (.C(CLK),
        .CE(\rx_data[9]_i_1_n_0 ),
        .D(rx_data__0[2]),
        .Q(Q[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rx_data_reg[3] 
       (.C(CLK),
        .CE(\rx_data[9]_i_1_n_0 ),
        .D(rx_data__0[3]),
        .Q(Q[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rx_data_reg[4] 
       (.C(CLK),
        .CE(\rx_data[9]_i_1_n_0 ),
        .D(rx_data__0[4]),
        .Q(Q[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rx_data_reg[5] 
       (.C(CLK),
        .CE(\rx_data[9]_i_1_n_0 ),
        .D(rx_data__0[5]),
        .Q(Q[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rx_data_reg[6] 
       (.C(CLK),
        .CE(\rx_data[9]_i_1_n_0 ),
        .D(rx_data__0[6]),
        .Q(Q[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rx_data_reg[7] 
       (.C(CLK),
        .CE(\rx_data[9]_i_1_n_0 ),
        .D(rx_data__0[7]),
        .Q(Q[7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rx_data_reg[8] 
       (.C(CLK),
        .CE(\rx_data[9]_i_1_n_0 ),
        .D(rx_data__0[8]),
        .Q(rx_data[8]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rx_data_reg[9] 
       (.C(CLK),
        .CE(\rx_data[9]_i_1_n_0 ),
        .D(rx_data__0[9]),
        .Q(rx_data[9]),
        .R(SR));
  LUT6 #(
    .INIT(64'hFF0FFF01FF00AA00)) 
    rx_valid_i_1
       (.I0(state_crnt[2]),
        .I1(tx_valid),
        .I2(rx_valid_i_2_n_0),
        .I3(rx_valid),
        .I4(state_crnt[0]),
        .I5(out),
        .O(rx_valid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFFDF)) 
    rx_valid_i_2
       (.I0(\counter_reg_n_0_[3] ),
        .I1(\counter_reg[2]_0 [2]),
        .I2(\counter_reg[2]_0 [0]),
        .I3(\counter_reg[2]_0 [1]),
        .O(rx_valid_i_2_n_0));
  FDRE #(
    .INIT(1'b0)) 
    rx_valid_reg
       (.C(CLK),
        .CE(\<const1> ),
        .D(rx_valid_i_1_n_0),
        .Q(rx_valid),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    tx_valid_i_1
       (.I0(rx_data[8]),
        .I1(rx_data[9]),
        .O(tx_valid_reg));
endmodule

(* ADDR_SIZE = "8" *) (* CTRL_WIDTH = "2" *) (* FRAME_WIDTH = "8" *) 
(* MEM_DEPTH = "256" *) (* RX_FRAME_WIDTH = "10" *) (* TX_FRAME_WIDTH = "8" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module SPI_Wrapper
   (clk,
    rst_n,
    SS_n,
    MOSI,
    MISO);
  input clk;
  input rst_n;
  input SS_n;
  input MOSI;
  output MISO;

  wire MISO;
  wire MISO_OBUF;
  wire MOSI;
  wire MOSI_IBUF;
  wire SS_n;
  wire SS_n_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [7:0]dout0;
  wire mem;
  wire ram_inst_n_9;
  wire rst_n;
  wire rst_n_IBUF;
  wire [7:0]rx_data;
  wire rx_valid;
  wire spi_slave_inst_n_0;
  wire spi_slave_inst_n_13;
  wire spi_slave_inst_n_14;
  wire spi_slave_inst_n_15;
  wire spi_slave_inst_n_16;
  wire spi_slave_inst_n_17;
  wire spi_slave_inst_n_18;
  wire spi_slave_inst_n_19;
  wire spi_slave_inst_n_2;
  wire spi_slave_inst_n_20;
  wire spi_slave_inst_n_21;
  wire spi_slave_inst_n_22;
  wire spi_slave_inst_n_23;
  wire spi_slave_inst_n_24;
  wire spi_slave_inst_n_4;
  wire tx_valid;

  OBUF MISO_OBUF_inst
       (.I(MISO_OBUF),
        .O(MISO));
  IBUF MOSI_IBUF_inst
       (.I(MOSI),
        .O(MOSI_IBUF));
  IBUF SS_n_IBUF_inst
       (.I(SS_n),
        .O(SS_n_IBUF));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  RAM ram_inst
       (.E(spi_slave_inst_n_24),
        .MISO_reg(ram_inst_n_9),
        .Q(rx_data),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .\counter_reg[2] ({spi_slave_inst_n_20,spi_slave_inst_n_21,spi_slave_inst_n_22}),
        .dout0(dout0),
        .mem(mem),
        .out(spi_slave_inst_n_0),
        .rst_n(spi_slave_inst_n_2),
        .\rx_data_reg[8] (spi_slave_inst_n_23),
        .\rx_data_reg[9] (spi_slave_inst_n_19),
        .\rx_data_reg[9]_0 (spi_slave_inst_n_18),
        .\rx_data_reg[9]_1 (spi_slave_inst_n_17),
        .\rx_data_reg[9]_2 (spi_slave_inst_n_16),
        .\rx_data_reg[9]_3 (spi_slave_inst_n_15),
        .\rx_data_reg[9]_4 (spi_slave_inst_n_14),
        .\rx_data_reg[9]_5 (spi_slave_inst_n_13),
        .\rx_data_reg[9]_6 (spi_slave_inst_n_4),
        .rx_valid(rx_valid),
        .tx_valid(tx_valid));
  IBUF rst_n_IBUF_inst
       (.I(rst_n),
        .O(rst_n_IBUF));
  SPI_Slave spi_slave_inst
       (.CLK(clk_IBUF_BUFG),
        .E(spi_slave_inst_n_24),
        .\FSM_gray_state_crnt_reg[1]_0 (ram_inst_n_9),
        .MISO_OBUF(MISO_OBUF),
        .MOSI_IBUF(MOSI_IBUF),
        .Q(rx_data),
        .SR(spi_slave_inst_n_2),
        .SS_n_IBUF(SS_n_IBUF),
        .\counter_reg[2]_0 ({spi_slave_inst_n_20,spi_slave_inst_n_21,spi_slave_inst_n_22}),
        .dout0(dout0),
        .\dout_reg[0] (spi_slave_inst_n_4),
        .\dout_reg[1] (spi_slave_inst_n_13),
        .\dout_reg[2] (spi_slave_inst_n_14),
        .\dout_reg[3] (spi_slave_inst_n_15),
        .\dout_reg[4] (spi_slave_inst_n_16),
        .\dout_reg[5] (spi_slave_inst_n_17),
        .\dout_reg[6] (spi_slave_inst_n_18),
        .\dout_reg[7] (spi_slave_inst_n_19),
        .mem(mem),
        .out(spi_slave_inst_n_0),
        .rst_n_IBUF(rst_n_IBUF),
        .rx_valid(rx_valid),
        .tx_valid(tx_valid),
        .tx_valid_reg(spi_slave_inst_n_23));
endmodule
