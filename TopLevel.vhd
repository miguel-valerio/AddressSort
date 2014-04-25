----------------------------------------------------------------------------------
-- Company: 
-- engineer: 
-- 
-- Create Date:    12:07:43 04/13/2014 
-- Design Name: 
-- Module Name:    TopLevel - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopLevel is
	generic(	data_width:	positive := 10);																--Data Size
	port(		clk			:in std_logic;																	--Clock
				vgaRed		:out std_logic_vector(3 downto 0);
				vgaBlue		:out std_logic_vector(3 downto 0);
				vgaGreen		:out std_logic_vector(3 downto 0);
				Hsync			:out std_logic;
				Vsync			:out std_logic;
				led			:out std_logic);
end TopLevel;

architecture Behavioral of TopLevel is

	signal random_num		:std_logic_vector(data_width-1 downto 0) := (others => '0');		--RNG Output
	signal we				:std_logic := '1';																--RAM Write enable
	signal en				:std_logic := '0';																--Decoder enable
	signal over				:std_logic := '0';																--Signals RAM populated with 216 values
	signal radd				:std_logic_vector(data_width-1 downto 0) := (others => '0');		--Read Addr
	signal ram_out			:std_logic;																			--RAM output
--	signal data				:std_logic_vector(2**dec_size-1 downto 0);								--Decoder output
	signal clk25			:std_logic;																			--25MHz Clock
	signal wadd0			:std_logic_vector(9 downto 0);
	signal wadd1			:std_logic_vector(9 downto 0);
	signal wadd2			:std_logic_vector(9 downto 0);
	signal wadd3			:std_logic_vector(9 downto 0);
	signal dout0			:std_logic_vector(4 downto 0);
	signal dout1			:std_logic_vector(4 downto 0);
	signal dout2			:std_logic_vector(4 downto 0);
	signal dout3			:std_logic_vector(4 downto 0);
	signal hs, vs, blank	:std_logic;
	signal hcount, vcount:std_logic_vector(10 downto 0);
	signal r, g, b			:std_logic_vector(3 downto 0);
	signal ram_add			:std_logic_vector(11 downto 0);
	signal ram_data		:std_logic_vector(4 downto 0);
	signal rom_add			:std_logic_vector(4 downto 0);--ROMSIZE
	signal rom_line		:std_logic_vector(3 downto 0);
	signal rom_column		:std_logic_vector(2 downto 0);
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
															din => ram_out	, wadd0 => wadd0	, wadd1 => wadd1,
															wadd2 => wadd2	, wadd3 => wadd3	, dout0 => dout0,
															dout1 => dout1	, dout2 => dout2	, dout3 => dout3);
	
	vgaram		:entity work.VGARAM port map	(clk => clk		, we => vgaen		, wadd0 => wadd0, --VGARAM
															wadd1 => wadd1	, wadd2 => wadd2	, wadd3 => wadd3,
															din0 => dout0	, din1 => dout1	, din2 => dout2,
															din3 => dout3	, radd => ram_add	, dout => ram_data);
	
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
				if conv_integer(radd) < (2**data_width) then						--Max nº of blocks
					radd <= radd + 1;
				end if;
				if radd = "1111111111" then
					done <= '1';
				end if;
			end if;
		end if;
	end process;

end Behavioral;

