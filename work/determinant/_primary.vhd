library verilog;
use verilog.vl_types.all;
entity determinant is
    port(
        x1              : in     vl_logic_vector(11 downto 0);
        y1              : in     vl_logic_vector(11 downto 0);
        x2              : in     vl_logic_vector(11 downto 0);
        y2              : in     vl_logic_vector(11 downto 0);
        det             : out    vl_logic_vector(23 downto 0)
    );
end determinant;
