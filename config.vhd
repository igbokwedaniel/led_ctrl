library ieee;
use ieee.math_real.log2;
use ieee.math_real.ceil;

package led_matrix_controller is
    
    -- User configurable constants
    constant RAM_DATA_WIDTH     : integer := 8; -- data width of ram
    constant ROM_DATA_WIDTH     : integer := 16; -- 4 bits per column of LED Matrix
    constant RAM_ADDRESS_WIDTH  : integer := 8; -- address width of ram
    constant ROM_ADDRESS_WIDTH  : integer := 8; -- address width of rom
    
    -- Special constants (change these at your own risk, stuff might break!)
   constant MAX_LED_COLUMN      : integer := 4; -- Number of columns in LED Matrix
   constant MAX_RAM_ADDR        : integer := 1; -- How many letters should show up
    
end led_controller;
