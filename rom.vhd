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
				tmp(0) <= "0100101010101111";
				tmp(1) <= "1111010101010011";
				tmp(2) <= "1111100110011001";
				tmp(3) <= "0011010101011111";
				tmp(4) <= "1111000100011111";
				tmp(5) <= "1100001100111100";
				tmp(6) <= "1111001100111111";
				tmp(7) <= "1001011001101001";
				tmp(8) <= "1101010101011111";
				tmp(9) <= "1001101111011001";
				tmp(10) <= "1111101111011101";
				tmp(11) <= "1111101010101010";
				tmp(12) <= "1101101110111111";
				tmp(13) <= "1111010001000111";
				tmp(14) <= "0000111100000000";
				tmp(15) <= "0000100110011111";
				tmp(16) <= "1111011001101001";
				tmp(17) <= "1111000100010001";
				tmp(18) <= "1111110011001111";
				tmp(19) <= "0000111110001111";
				tmp(20) <= "1111100110011111";
				tmp(21) <= "1111101010101110";
				tmp(22) <= "1110111011110010";
				tmp(23) <= "0000111110001000";
				tmp(24) <= "1001110110111001";
				tmp(25) <= "1000111110000000";

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
