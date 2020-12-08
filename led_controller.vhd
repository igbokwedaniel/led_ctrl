ibrary ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity led_controller is
    port (

        clk_in   : in  std_logic;
        rst      : in  std_logic;
        clk_out  : out std_logic;

        -- LED Panel IO
        led	     : out std_logic_vector(7 downto 0);
       
       -- MEMORY IO
       ram_addr     : out std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
       ram_data     : in std_logic_vector(RAM_DATA_WIDTH-1 downto 0);

       rom_addr     : out std_logic_vector(ROM_ADDR_WIDTH-1 downto 0);
       rom_data     : in std_logic_vector(ROM_DATA_WIDTH-1 downto 0);
    );
end led_controller;

architecture behaviour of led_controller is
    -- Internal signals
    signal clk            : std_logic;
    signal s_clk_out      : std_logic;
    signal column_count   : integer;
    signal column_index   : integer;
    
    signal s_ram_addr     : out std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
    signal s_ram_data     : in std_logic_vector(RAM_DATA_WIDTH-1 downto 0);

    signal s_rom_data     : in std_logic_vector(ROM_DATA_WIDTH-1 downto 0);

    signal next_addr      : integer;
    
    -- Essential state machine signals
    type STATE_TYPE is (INIT, READ_DATA, INCR_RAM_DATA);
    signal state, next_state : STATE_TYPE;
    
begin
    -- A simple clock divider is used here to slow down this part of the circuit
    U_CLKDIV : entity work.clk_div
        generic map (
            clk_in_freq  => 50000000, -- 50MHz input clock
            clk_out_freq => 10000000  
            -- 10MHz output clock
        )
        port map (
            rst     => rst,
            clk_in  => clk_in,
            clk_out => clk_out
        );
    
    -- Breakout internal signals to the output port
    
    ram_addr        <= s_ram_addr;
    rom_data        <= s_rom_data;
    ram_data        <= s_ram_data;
    rom_addr        <= s_ram_data; -- output of ram data is the rom address containing the alphabet mapping

    -- State register
    process(rst, clk) is
    begin
        if(rst = '1') then
            state           <= INIT;
            col_count       <= 0;
            col_index       <= ROM_DATA_WIDTH - 1;
            s_rom_addr      <= (others => '0');
            s_ram_addr      <= (others => '0');
            s_rom_data      <= (others => '0');
            s_ram_data      <= (others => '0');
            led             <= (others => '0');
            next_addr       <= 0;
            
 
        elsif(rising_edge(clk)) then
            state           <= next_state;
            col_count       <= (col_count + 1) mod MAX_LED_COLUMN;
            col_index       <= ROM_DATA_WIDTH - 1 - (col_count * 4)
        end if;
    end process;

    --ram read process
    process(clk_out) is
    begin
        wait until rising_edge(clk_out);
        if(state = READ_DATA) then
            s_ram_addr <= std_logic_vector(to_unsigned(next_addr, RAM_ADDR_WIDTH));
            next_state <= INCR_RAM_DATA;
        end if;
    end process;    

    --state transitions
    process(state, col_count, next_addr) is
    begin
        case(state) is
            when INIT => 
                led         <= (others => '1');
                next_state  <=  READ_DATA;

            when INCR_RAM_DATA => 
                next_addr   <= (next_addr + 1) mod MAX_RAM_ADDR;
                next_state  <=  READ_DATA;
        
    end process;

    --led cycle display
    process(col_count, clk) is
        variable row : std_logic_vector(3 downto 0);
        variable col : std_logic_vector(3 downto 0);
        variable stop : integer;
    begin
        stop   := col_index - 3;
        row    := s_rom_data(col_index downto stop);
        col    := (others => '0');
        col(col_count) := '1';
        led <= (row & col);
    end process;


    
end behaviour;