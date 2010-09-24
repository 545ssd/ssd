library verilog;
use verilog.vl_types.all;
entity nand_controller_top is
    port(
        DONE            : out    vl_logic;
        DATA_DONE       : out    vl_logic;
        DATA_READY      : out    vl_logic;
        RB              : out    vl_logic;
        status          : out    vl_logic_vector(7 downto 0);
        DATA_OUT        : out    vl_logic_vector(7 downto 0);
        DATA_IN         : in     vl_logic_vector(7 downto 0);
        ADDR            : in     vl_logic_vector(31 downto 0);
        CMD             : in     vl_logic_vector(2 downto 0);
        DATA_LOADED     : in     vl_logic;
        CMD_LOADED      : in     vl_logic;
        LEN             : in     vl_logic_vector(12 downto 0);
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        ce1_l           : out    vl_logic;
        ce2_l           : out    vl_logic;
        ale             : out    vl_logic;
        cle             : out    vl_logic;
        re_l            : out    vl_logic;
        we_l            : out    vl_logic;
        i               : in     vl_logic_vector(7 downto 0);
        o               : out    vl_logic_vector(7 downto 0);
        rb1_l           : in     vl_logic;
        rb2_l           : in     vl_logic
    );
end nand_controller_top;
