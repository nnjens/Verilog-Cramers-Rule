library verilog;
use verilog.vl_types.all;
entity hex_7seg is
    port(
        w               : in     vl_logic_vector(3 downto 0);
        seg             : out    vl_logic_vector(0 to 6)
    );
end hex_7seg;
