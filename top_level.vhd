library ieee;
use ieee.std_logic_1164.all;

use work.led_matrix_controller.all; -- Constants & Configuration

entity top_level is
    port (
        clk_in  : in std_logic;
        rst     : in std_logic;
        clk_out : out std_logic;
        led     : out std_logic_vector(7 downto 0)
        );
end top_level;

architecture behaviour of top_level is
       signal s_ram_addr     : std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
       signal s_ram_data     : std_logic_vector(RAM_DATA_WIDTH-1 downto 0);

       signal s_rom_addr     : std_logic_vector(ROM_ADDR_WIDTH-1 downto 0);
       signal s_rom_data     : std_logic_vector(ROM_DATA_WIDTH-1 downto 0);
       signal mem_clk        : std_logic;
       
       
       begin
       
          LED_CONTROLLER : entity.led_controller
            port map(
            clk_in    => clk_in,
            rst       => rst,
            clk_out   => clk_out,
            led       => led,
            ram_addr  => s_ram_addr,
            rom_addr  => s_rom_addr,
            ram_data  => s_ram_data,
            rom_data  => s_rom_data,
            );
            
            RAM : entity.ram
              port map(
              
              rst     => rst,
              clk_rd  => clk_out,
              addr    => s_ram_addr,
              output  => s_ram_data
              );
            
            ROM : entity.rom
              port map(
              
              clk     => clk,
              addr    => s_rom_addr,
              q       => s_rom_data
              );
            
     end behaviour;
            
