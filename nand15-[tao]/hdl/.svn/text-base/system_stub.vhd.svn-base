-------------------------------------------------------------------------------
-- system_stub.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_stub is
  port (
    fpga_0_RS232_Uart_1_RX_pin : in std_logic;
    fpga_0_RS232_Uart_1_TX_pin : out std_logic;
    fpga_0_RS232_Uart_2_RX_pin : in std_logic;
    fpga_0_RS232_Uart_2_TX_pin : out std_logic;
    fpga_0_clk_1_sys_clk_pin : in std_logic;
    fpga_0_rst_1_sys_rst_pin : in std_logic;
    nand_01_0_curr_state_pin : out std_logic_vector(0 to 5);
    nand_01_0_ccount_q_pin : out std_logic_vector(0 to 4);
    nand_01_0_control_q_pin : out std_logic_vector(0 to 15);
    nand_01_0_count_q_pin : out std_logic_vector(0 to 15);
    nand_01_0_raddr_q_pin : out std_logic_vector(0 to 12);
    nand_01_0_nDone_pin : out std_logic;
    nand_01_0_nReset_pin : out std_logic;
    nand_01_0_nAddr_pin : out std_logic_vector(0 to 31);
    nand_01_0_nCmd_pin : out std_logic_vector(0 to 2);
    nand_01_0_nData_Loaded_pin : out std_logic;
    nand_01_0_nCmd_Loaded_pin : out std_logic;
    nand_01_0_nCsf_pin : out std_logic_vector(0 to 6);
    nand_01_0_n_re_l_pin : out std_logic;
    nand_01_0_n_we_l_pin : out std_logic;
    nand_01_0_n_ale_pin : out std_logic;
    nand_01_0_n_cle_pin : out std_logic;
    nand_01_0_n_ce1_l_pin : out std_logic;
    nand_01_0_n_ce2_l_pin : out std_logic;
    nand_01_0_n_wp_l_pin : out std_logic;
    nand_01_0_n_io_dir_pin : out std_logic;
    nand_01_0_n_rb1_l_pin : in std_logic;
    nand_01_0_n_rb2_l_pin : in std_logic;
    nand_01_0_t_rb1_l_pin : out std_logic;
    nand_01_0_t_rb2_l_pin : out std_logic;
    nand_01_0_t_i_pin : out std_logic_vector(0 to 7);
    nand_01_0_n_i_pin : in std_logic_vector(0 to 7);
    nand_01_0_n_o_pin : out std_logic_vector(0 to 7)
  );
end system_stub;

architecture STRUCTURE of system_stub is

  component system is
    port (
      fpga_0_RS232_Uart_1_RX_pin : in std_logic;
      fpga_0_RS232_Uart_1_TX_pin : out std_logic;
      fpga_0_RS232_Uart_2_RX_pin : in std_logic;
      fpga_0_RS232_Uart_2_TX_pin : out std_logic;
      fpga_0_clk_1_sys_clk_pin : in std_logic;
      fpga_0_rst_1_sys_rst_pin : in std_logic;
      nand_01_0_curr_state_pin : out std_logic_vector(0 to 5);
      nand_01_0_ccount_q_pin : out std_logic_vector(0 to 4);
      nand_01_0_control_q_pin : out std_logic_vector(0 to 15);
      nand_01_0_count_q_pin : out std_logic_vector(0 to 15);
      nand_01_0_raddr_q_pin : out std_logic_vector(0 to 12);
      nand_01_0_nDone_pin : out std_logic;
      nand_01_0_nReset_pin : out std_logic;
      nand_01_0_nAddr_pin : out std_logic_vector(0 to 31);
      nand_01_0_nCmd_pin : out std_logic_vector(0 to 2);
      nand_01_0_nData_Loaded_pin : out std_logic;
      nand_01_0_nCmd_Loaded_pin : out std_logic;
      nand_01_0_nCsf_pin : out std_logic_vector(0 to 6);
      nand_01_0_n_re_l_pin : out std_logic;
      nand_01_0_n_we_l_pin : out std_logic;
      nand_01_0_n_ale_pin : out std_logic;
      nand_01_0_n_cle_pin : out std_logic;
      nand_01_0_n_ce1_l_pin : out std_logic;
      nand_01_0_n_ce2_l_pin : out std_logic;
      nand_01_0_n_wp_l_pin : out std_logic;
      nand_01_0_n_io_dir_pin : out std_logic;
      nand_01_0_n_rb1_l_pin : in std_logic;
      nand_01_0_n_rb2_l_pin : in std_logic;
      nand_01_0_t_rb1_l_pin : out std_logic;
      nand_01_0_t_rb2_l_pin : out std_logic;
      nand_01_0_t_i_pin : out std_logic_vector(0 to 7);
      nand_01_0_n_i_pin : in std_logic_vector(0 to 7);
      nand_01_0_n_o_pin : out std_logic_vector(0 to 7)
    );
  end component;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of system : component is "user_black_box";

begin

  system_i : system
    port map (
      fpga_0_RS232_Uart_1_RX_pin => fpga_0_RS232_Uart_1_RX_pin,
      fpga_0_RS232_Uart_1_TX_pin => fpga_0_RS232_Uart_1_TX_pin,
      fpga_0_RS232_Uart_2_RX_pin => fpga_0_RS232_Uart_2_RX_pin,
      fpga_0_RS232_Uart_2_TX_pin => fpga_0_RS232_Uart_2_TX_pin,
      fpga_0_clk_1_sys_clk_pin => fpga_0_clk_1_sys_clk_pin,
      fpga_0_rst_1_sys_rst_pin => fpga_0_rst_1_sys_rst_pin,
      nand_01_0_curr_state_pin => nand_01_0_curr_state_pin,
      nand_01_0_ccount_q_pin => nand_01_0_ccount_q_pin,
      nand_01_0_control_q_pin => nand_01_0_control_q_pin,
      nand_01_0_count_q_pin => nand_01_0_count_q_pin,
      nand_01_0_raddr_q_pin => nand_01_0_raddr_q_pin,
      nand_01_0_nDone_pin => nand_01_0_nDone_pin,
      nand_01_0_nReset_pin => nand_01_0_nReset_pin,
      nand_01_0_nAddr_pin => nand_01_0_nAddr_pin,
      nand_01_0_nCmd_pin => nand_01_0_nCmd_pin,
      nand_01_0_nData_Loaded_pin => nand_01_0_nData_Loaded_pin,
      nand_01_0_nCmd_Loaded_pin => nand_01_0_nCmd_Loaded_pin,
      nand_01_0_nCsf_pin => nand_01_0_nCsf_pin,
      nand_01_0_n_re_l_pin => nand_01_0_n_re_l_pin,
      nand_01_0_n_we_l_pin => nand_01_0_n_we_l_pin,
      nand_01_0_n_ale_pin => nand_01_0_n_ale_pin,
      nand_01_0_n_cle_pin => nand_01_0_n_cle_pin,
      nand_01_0_n_ce1_l_pin => nand_01_0_n_ce1_l_pin,
      nand_01_0_n_ce2_l_pin => nand_01_0_n_ce2_l_pin,
      nand_01_0_n_wp_l_pin => nand_01_0_n_wp_l_pin,
      nand_01_0_n_io_dir_pin => nand_01_0_n_io_dir_pin,
      nand_01_0_n_rb1_l_pin => nand_01_0_n_rb1_l_pin,
      nand_01_0_n_rb2_l_pin => nand_01_0_n_rb2_l_pin,
      nand_01_0_t_rb1_l_pin => nand_01_0_t_rb1_l_pin,
      nand_01_0_t_rb2_l_pin => nand_01_0_t_rb2_l_pin,
      nand_01_0_t_i_pin => nand_01_0_t_i_pin,
      nand_01_0_n_i_pin => nand_01_0_n_i_pin,
      nand_01_0_n_o_pin => nand_01_0_n_o_pin
    );

end architecture STRUCTURE;

