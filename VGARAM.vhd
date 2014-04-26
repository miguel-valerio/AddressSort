library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.pack.all;

entity VGARAM is
	port(		clk			: in std_logic;											--Clock
				we				: in std_logic;											--Write Enable
				wadd			: in std_logic_vector(vga_add_size-1 downto 0);		--vga_ram_addess where din will be written to
				din			: in std_logic_vector(vga_din_size-1 downto 0);	--Data received from Decoder
				radd			: in std_logic_vector(vga_add_size-1 downto 0);		--vga_ram_addess where dout will be read from
				dout			: out std_logic_vector(vga_dout_size-1 downto 0));	--Data sent to VGAText
				
end VGARAM;

architecture Behavioral of VGARAM is

--	signal radd0	:std_logic_vector(vga_ram_add-1 downto 0);
--	signal radd1	:std_logic_vector(vga_ram_add-1 downto 0);
--	signal radd2	:std_logic_vector(vga_ram_add-1 downto 0);
--	signal radd3	:std_logic_vector(vga_ram_add-1 downto 0);
--	signal radd4	:std_logic_vector(vga_ram_add-1 downto 0);
--	signal radd5	:std_logic_vector(vga_ram_add-1 downto 0);
--	signal dout0	:std_logic_vector(vga_din_size-1 downto 0);
--	signal dout1	:std_logic_vector(vga_din_size-1 downto 0);
--	signal dout2	:std_logic_vector(vga_din_size-1 downto 0);
--	signal dout3	:std_logic_vector(vga_din_size-1 downto 0);
--	signal dout4	:std_logic_vector(vga_din_size-1 downto 0);
--	signal dout5	:std_logic_vector(vga_din_size-1 downto 0);

	type ram is array (519 downto 0) of std_logic_vector(vga_din_size-1 downto 0);
	signal my_ram : ram := (others => "000000000000000000000000000000");

begin

--	ram0		:entity work.OnePortRam port map (clk => clk, we => we, wadd => wadd0, radd => radd0, 
--															din => din0, dout => dout0);
--															
--	ram1		:entity work.OnePortRam port map (clk => clk, we => we, wadd => wadd1, radd => radd1, 
--															din => din1, dout => dout1);
--															
--	ram2		:entity work.OnePortRam port map (clk => clk, we => we, wadd => wadd2, radd => radd2, 
--															din => din2, dout => dout2);
--														
--	ram3		:entity work.OnePortRam port map (clk => clk, we => we, wadd => wadd3, radd => radd3, 
--															din => din3, dout => dout3);
--															
--	ram4		:entity work.OnePortRam port map (clk => clk, we => we, wadd => wadd3, radd => radd3, 
--															din => din3, dout => dout3);
--															
--	ram5		:entity work.OnePortRam port map (clk => clk, we => we, wadd => wadd3, radd => radd3, 
--															din => din3, dout => dout3);
	
--	process(clk)
--	begin
--		if rising_edge(clk) then
--			if radd(2 downto 0) = "101" then
--				radd5 <= radd(vga_add_size-1 downto 2);
--				dout <= dout5;
--			elsif radd(2 downto 0) = "100" then
--				radd4 <= radd(vga_add_size-1 downto 2);
--				dout <= dout4;
--			elsif radd(2 downto 0) = "011" then
--				radd3 <= radd(vga_add_size-1 downto 2);
--				dout <= dout3;
--			elsif radd(2 downto 0) = "010" then
--				radd2 <= radd(vga_add_size-1 downto 2);
--				dout <= dout2;
--			elsif radd(2 downto 0) = "001" then
--				radd1 <= radd(vga_add_size-1 downto 2);
--				dout <= dout1;
--			else
--				radd0 <= radd(vga_add_size-1 downto 2);
--				dout <= dout0;
--			end if;
--		end if;
--	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			if we = '1' then
				if din /= "111111111111111111111111111111" then
					my_ram(conv_integer(wadd)) <= din;
				end if;
			end if;
			dout <= my_ram(conv_integer(radd));
		end if;
	end process;

end Behavioral;

