library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.pack.all;

entity TopLevel is
	port(		clk			:in std_logic;																	--Clock
				vgaRed		:out std_logic_vector(3 downto 0);
				vgaBlue		:out std_logic_vector(3 downto 0);
				vgaGreen		:out std_logic_vector(3 downto 0);
				Hsync			:out std_logic;
				Vsync			:out std_logic;
				led			:out std_logic);
end TopLevel;

architecture Behavioral of TopLevel is

	signal random_num		:std_logic_vector(data_size-1 downto 0) := (others => '0');		--RNG Output
	signal we				:std_logic := '1';																--RAM Write enable
	signal en				:std_logic := '0';																--Decoder enable
	signal over				:std_logic := '0';																--Signals RAM populated with 216 values
	signal radd				:std_logic_vector(data_size-1 downto 0) := (others => '0');		--Read Addr
	signal ram_out			:std_logic;																			--RAM output
	signal clk25			:std_logic;																			--25MHz Clock
	signal wadd				:std_logic_vector(vga_wadd_size-1 downto 0);
	signal dout				:std_logic_vector(vga_din_size-1 downto 0);
	signal hs, vs, blank	:std_logic;
	signal hcount			:std_logic_vector(hcount_size-1 downto 0);
	signal vcount			:std_logic_vector(vcount_size-1 downto 0);
	signal r, g, b			:std_logic_vector(rgb_size-1 downto 0);
	signal ram_add			:std_logic_vector(vga_radd_size-1 downto 0);
	signal ram_data		:std_logic_vector(vga_dout_size-1 downto 0);
	signal rom_add			:std_logic_vector(rom_radd_size-1 downto 0);--ROMSIZE
	signal rom_line		:std_logic_vector(rom_line_size-1 downto 0);
	signal rom_column		:std_logic_vector(rom_column_size-1 downto 0);
	signal rom_data		:std_logic;
	signal vgaen			:std_logic := '0';
	signal done				:std_logic := '0';
	
begin

	Hsync <= hs;
	Vsync <= vs;
	
	vgaRed <= r;
	vgaGreen <= g;
	vgaBlue <= b;
	
	led <= done;

	cgenerator	:entity work.ClockGenerator port map (clk => clk, clk25 => clk25);					--25MHz Clock Generator

	generator	:entity work.RNG port map	(clk => clk25, random_num => random_num,						--Random Number Generator
														over => over);
	
	ram			:entity work.RAM port map	(clk => clk	, we => we	, wadd => random_num,			--RAM
														radd => radd, din => '1', dout => ram_out);	
	
	decoder		:entity work.Decoder	port map	(clk => clk		, en => en			, radd => radd, 	--Decoder
															din => ram_out	, wadd => wadd, dout => dout);
	
	vgaram		:entity work.VGARAM port map	(clk => clk		, we => vgaen		, wadd => wadd, --VGARAM
															din => dout	, radd => ram_add	, dout => ram_data);
	
	vgasync		:entity work.VGASync port map	(reset => '0'	, clk => clk25		, hs => hs, vs => vs,
															blank => blank	, hcount => hcount, vcount => vcount);
	
	vgatext		:entity work.VGAText port map	(blank => blank	, hcount => hcount, vcount => vcount,
															red => r				, green => g		, blue => b,
															ram_add => ram_add, ram_data => ram_data, 
															rom_add => rom_add, rom_line => rom_line, 
															rom_column => rom_column, rom_data => rom_data,
															clk => clk);
														
	pixel			:entity work.PixelROM port map(char => rom_add		, line => rom_line, 
															column => rom_column	, data => rom_data);
	
	we <= '0' 	when over = '1' else '1';			--we is disabled after 216 values 
																--beign written to the RAM
																													
	en <= '1' 	when (over = '1' and done = '0') else '0';			--Decoder is enabled after 216 values 
																--beign written to the RAM
																
	vgaen <= '1' when over = '1' else '0';
	
	process(clk)	
		variable count : integer := 0;								--radd Incrementer
	begin
		if rising_edge(clk) then
			if over = '1' then
				if conv_integer(radd) < (2**data_size) then						--Max nº of blocks
					radd <= radd + 1;
				end if;
				if radd = "1111111111" then
					done <= '1';
				end if;
			end if;
		end if;
	end process;

end Behavioral;

