library verilog;
use verilog.vl_types.all;
entity \buffer\ is
    port(
        C               : in     vl_logic;
        we              : in     vl_logic;
        addr            : in     vl_logic_vector(0 to 10);
        D               : in     vl_logic_vector(0 to 31);
        Q               : out    vl_logic_vector(0 to 31)
    );
end \buffer\;
