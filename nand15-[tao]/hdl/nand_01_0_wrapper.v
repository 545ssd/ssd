//-----------------------------------------------------------------------------
// nand_01_0_wrapper.v
//-----------------------------------------------------------------------------

  (* x_core_info = "nand_01_v1_00_a" *)
module nand_01_0_wrapper
  (
    FSL_Clk,
    FSL_Rst,
    FSL_S_Clk,
    FSL_S_Read,
    FSL_S_Data,
    FSL_S_Control,
    FSL_S_Exists,
    FSL_M_Clk,
    FSL_M_Write,
    FSL_M_Data,
    FSL_M_Control,
    FSL_M_Full,
    curr_state,
    ccount_q,
    control_q,
    count_q,
    raddr_q,
    nDone,
    nReset,
    nAddr,
    nCmd,
    nData_Loaded,
    nCmd_Loaded,
    nCsf,
    n_re_l,
    n_we_l,
    n_ale,
    n_cle,
    n_ce1_l,
    n_ce2_l,
    n_wp_l,
    n_io_dir,
    n_i,
    n_o,
    n_rb1_l,
    n_rb2_l,
    t_rb1_l,
    t_rb2_l,
    t_i
  );
  input FSL_Clk;
  input FSL_Rst;
  output FSL_S_Clk;
  output FSL_S_Read;
  input [0:31] FSL_S_Data;
  input FSL_S_Control;
  input FSL_S_Exists;
  output FSL_M_Clk;
  output FSL_M_Write;
  output [0:31] FSL_M_Data;
  output FSL_M_Control;
  input FSL_M_Full;
  output [0:5] curr_state;
  output [0:4] ccount_q;
  output [0:15] control_q;
  output [0:15] count_q;
  output [0:12] raddr_q;
  output nDone;
  output nReset;
  output [0:31] nAddr;
  output [0:2] nCmd;
  output nData_Loaded;
  output nCmd_Loaded;
  output [0:6] nCsf;
  output n_re_l;
  output n_we_l;
  output n_ale;
  output n_cle;
  output n_ce1_l;
  output n_ce2_l;
  output n_wp_l;
  output n_io_dir;
  input [0:7] n_i;
  output [0:7] n_o;
  input n_rb1_l;
  input n_rb2_l;
  output t_rb1_l;
  output t_rb2_l;
  output [0:7] t_i;

  nand_01
    nand_01_0 (
      .FSL_Clk ( FSL_Clk ),
      .FSL_Rst ( FSL_Rst ),
      .FSL_S_Clk ( FSL_S_Clk ),
      .FSL_S_Read ( FSL_S_Read ),
      .FSL_S_Data ( FSL_S_Data ),
      .FSL_S_Control ( FSL_S_Control ),
      .FSL_S_Exists ( FSL_S_Exists ),
      .FSL_M_Clk ( FSL_M_Clk ),
      .FSL_M_Write ( FSL_M_Write ),
      .FSL_M_Data ( FSL_M_Data ),
      .FSL_M_Control ( FSL_M_Control ),
      .FSL_M_Full ( FSL_M_Full ),
      .curr_state ( curr_state ),
      .ccount_q ( ccount_q ),
      .control_q ( control_q ),
      .count_q ( count_q ),
      .raddr_q ( raddr_q ),
      .nDone ( nDone ),
      .nReset ( nReset ),
      .nAddr ( nAddr ),
      .nCmd ( nCmd ),
      .nData_Loaded ( nData_Loaded ),
      .nCmd_Loaded ( nCmd_Loaded ),
      .nCsf ( nCsf ),
      .n_re_l ( n_re_l ),
      .n_we_l ( n_we_l ),
      .n_ale ( n_ale ),
      .n_cle ( n_cle ),
      .n_ce1_l ( n_ce1_l ),
      .n_ce2_l ( n_ce2_l ),
      .n_wp_l ( n_wp_l ),
      .n_io_dir ( n_io_dir ),
      .n_i ( n_i ),
      .n_o ( n_o ),
      .n_rb1_l ( n_rb1_l ),
      .n_rb2_l ( n_rb2_l ),
      .t_rb1_l ( t_rb1_l ),
      .t_rb2_l ( t_rb2_l ),
      .t_i ( t_i )
    );

endmodule

