library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.led_matrix_controller.all;

entity single_port_rom is

	port
	(
		addr	: IN 	STD_LOGIC_VECTOR(ROM_ADDR_WIDTH-1 DOWNTO 0);
		clk		: IN 	STD_LOGIC;
		q		: OUT 	STD_LOGIC_VECTOR(ROM_DATA_WIDTH-1 DOWNTO 0);
	);
	
end entity;


architecture behaviour of single_port_rom is

	-- Build a 2-D array type for the RoM
	subtype word_t 	is STD_LOGIC_VECTOR(ROM_DATA_WIDTH-1 DOWNTO 0);
    type memory_t 	is ARRAY(ROM_SIZE-1 DOWNTO 0) of word_t;
    
		
	function init_rom
		return memory_t is
		
		variable tmp : memory_t := (others => (others => '0'));
		begin
			tmp(0) := "1110101010101111";
			tmp(1) := "1111010101010111";
			tmp(2) := "1111100110011001";

		return tmp;
	end init_rom;
	
	-- Declare the ROM signal and specify a default value.	FPGA
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
    signal rom          : memory_t := init_rom;
    
	
begin
	
    process(clk)
    variable addr_int   : INTEGER;
    begin
        addr_int := to_integer(unsigned(addr));
		if(rising_edge(clk)) then
			q <= rom(addr_int);
		end if;
	end process;
		
end behaviour;
