library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity ram is
    port (
        rst    : in  std_logic;
        clk_wr : in  std_logic;
        input  : in  std_logic_vector(RAM_DATA_WIDTH-1 downto 0);
        clk_rd : in  std_logic;
        addr   : in  std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
        output : out std_logic_vector(RAM_DATA_WIDTH-1 downto 0)
    );
end ram;

architecture behaviour of ram is
    -- Internal signals
    signal waddr, next_waddr : std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
    
    -- Inferred RAM storage signal
    type ram is array(2**RAM_ADDR_WIDTH-1 downto 0) of std_logic_vector(RAM_DATA_WIDTH-1 downto 0);
    signal ram_block : ram;
begin
    
    -- Create an adder to calculate the next write address
    next_waddr <= std_logic_vector( unsigned(waddr) + 1 );
    
    -- Write process for the ram
    process(rst, clk_wr, next_waddr)
    variable addr_int, waddr_int : integer;
    begin
        addr_int    := to_integer(unsigned(addr));
        waddr_int   := to_integer(unsigned(waddr));

        if(rst = '1') then
            waddr <= (others => '0'); -- reset the write address to the beginning
        elsif(rising_edge(clk_wr)) then
            ram_block(waddr_int) <= input; -- store input at the current write address
            waddr <= next_waddr; -- allow the write address to increment
        end if;
    end process;
    
    -- Read process for the ram
    process(clk_rd)
    begin
        if(rising_edge(clk_rd)) then
            output <= ram_block(addr_int); -- retrieve contents at the given read address
        end if;
    end process;

end behaviour;