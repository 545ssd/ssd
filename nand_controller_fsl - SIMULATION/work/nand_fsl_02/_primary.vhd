library verilog;
use verilog.vl_types.all;
entity nand_fsl_02 is
    port(
        FSL_Clk         : in     vl_logic;
        FSL_Rst         : in     vl_logic;
        FSL_S_Clk       : out    vl_logic;
        FSL_S_Read      : out    vl_logic;
        FSL_S_Data      : in     vl_logic_vector(0 to 31);
        FSL_S_Control   : in     vl_logic;
        FSL_S_Exists    : in     vl_logic;
        FSL_M_Clk       : out    vl_logic;
        FSL_M_Write     : out    vl_logic;
        FSL_M_Data      : out    vl_logic_vector(0 to 31);
        FSL_M_Control   : out    vl_logic;
        FSL_M_Full      : in     vl_logic;
        curr_state      : out    vl_logic_vector(0 to 5);
        control_q       : out    vl_logic_vector(0 to 15);
        count_q         : out    vl_logic_vector(0 to 15);
        raddr_q         : out    vl_logic_vector(0 to 12);
        nDone           : out    vl_logic;
        nReset          : out    vl_logic;
        nAddr           : out    vl_logic_vector(0 to 31);
        nCmd            : out    vl_logic_vector(0 to 2);
        nData_Loaded    : out    vl_logic;
        nCmd_Loaded     : out    vl_logic;
        n_re_l          : out    vl_logic;
        n_we_l          : out    vl_logic;
        n_ale           : out    vl_logic;
        n_cle           : out    vl_logic;
        n_ce1_l         : out    vl_logic;
        n_ce2_l         : out    vl_logic;
        n_io_dir        : out    vl_logic;
        n_io            : inout  vl_logic_vector(0 to 7);
        n_rb1_l         : in     vl_logic;
        n_rb2_l         : in     vl_logic
    );
end nand_fsl_02;
