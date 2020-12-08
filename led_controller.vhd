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