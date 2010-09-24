library verilog;
use verilog.vl_types.all;
entity counter is
    generic(
        width           : integer := 1
    );
    port(
        C               : in     vl_logic;
        CLR             : in     vl_logic;
        CE              : in     vl_logic;
        CE4             : in     vl_logic;
        Q               : out    vl_logic_vector
    );
end counter;
