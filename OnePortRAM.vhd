library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.pack.all;

entity OnePortRAM is
	port		(	clk:			in std_logic;													--Clock
					we:			in std_logic;													--Write Enable
					wadd:			in std_logic_vector(data_size-1 downto 0);			--Write Address
					radd:			in std_logic_vector(data_size-1 downto 0);			--Read Address
					din:			in std_logic_vector(vga_dout_size-1 downto 0);			--Data In
					dout:			out std_logic_vector(vga_dout_size-1 downto 0));		--Data Out
end OnePortRAM;

architecture Behavioral of OnePortRAM is

	type ram is array (2**data_size-1 downto 0) of std_logic_vector(vga_dout_size-1 downto 0);
	signal my_ram : ram := (others => (others => '0'));

begin

	process(clk)
	begin
		if rising_edge(clk) then
			if we = '1' then
				if din /= "11111" then
					my_ram(conv_integer(wadd)) <= din;
				end if;
			end if;
			dout <= my_ram(conv_integer(radd));
		end if;
	end process;

end Behavioral;