library verilog;
use verilog.vl_types.all;
entity \register\ is
    generic(
        width           : integer := 1
    );
    port(
        C               : in     vl_logic;
        CLR             : in     vl_logic;
        CE              : in     vl_logic;
        D               : in     vl_logic_vector;
        Q               : out    vl_logic_vector
    );
end \register\;
