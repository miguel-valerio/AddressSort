library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.pack.all;

entity VGAText is
	port(		clk			:in std_logic;
				blank			:in std_logic;
				hcount		:in std_logic_vector(hcount_size-1 downto 0);
				vcount		:in std_logic_vector(vcount_size-1 downto 0);
				red			:out std_logic_vector(3 downto 0);
				green			:out std_logic_vector(3 downto 0);
				blue			:out std_logic_vector(3 downto 0);
				ram_data		:in std_logic_vector(vga_din_size-1 downto 0);			--LINHA
				ram_add		:out std_logic_vector(vga_radd_size-1 downto 0);			--TILE (de 80*40)
				rom_data		:in std_logic;
				rom_add		:out std_logic_vector(rom_radd_size-1 downto 0);
				rom_line		:out std_logic_vector(rom_line_size-1 downto 0);
				rom_column	:out std_logic_vector(rom_column_size-1 downto 0));
end VGAText;

architecture Behavioral of VGAText is
	
--	signal hc			:std_logic_vector(7 downto 0) := (others => '0');
--	signal vc			:std_logic_vector(7 downto 0) := (others => '0');
	
	signal h				:integer range 0 to 7:= 0;
	signal v				:integer range 0 to 11:= 0;
	
	signal vc			:integer := 0;
	signal hc			:integer := 0;

begin

	h <= conv_integer(hcount-HBP) rem 8;
	v <= conv_integer(vcount-VBP) rem 12;

	red <= (others => '0');
	blue <= (others => '0');

	ram_add <= conv_std_logic_vector((conv_integer(hcount-HBP)/48) + (conv_integer(vcount-VBP)/12*14), vga_radd_size);
	rom_add <= ram_data(4+hc downto hc);
	rom_line <= conv_std_logic_vector(v, rom_line_size);
	rom_column <= conv_std_logic_vector(8-h, rom_column_size);
	
--	process(clk)
--	begin
--		if rising_edge(clk) then
--			if h = 0 then
--					hc <= hc + 1;
--			end if;
--			if v = 0 then
--				vc <= vc + 1;
--			end if;
--		end if;
--	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			if hc = 30 then
				hc <= 0;
			elsif h = 0 then
				hc <= hc+5;
			end if;
		end if;
	end process;
	
	process(hcount, vcount, blank, rom_data)
	begin
		if blank = '0' then
			green <= (others => rom_data);
		else
			green <= (others => '0');
		end if;
	end process;

end Behavioral;

