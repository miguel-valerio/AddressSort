library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use work.pack.all;

entity RAM is
	port		(	clk:			in std_logic;													--Clock
					we:			in std_logic;													--Write Enable
					wadd:			in std_logic_vector(data_size-1 downto 0);			--Write Address
					radd:			in std_logic_vector(data_size-1 downto 0);			--Read Address
					din:			in std_logic;													--Data In
					dout:			out std_logic);												--Data Out
end RAM;

architecture Behavioral of RAM is

	type blk				is array (2**data_size-1 downto 0) of std_logic;			--RAM type: 1 address for every possible 
																										--randomly generated number;
																										--1 flag for each address
	signal my_ram:		blk;

begin

	process(clk)
	begin
		if rising_edge(clk) then
			if we = '1' then 
				my_ram(conv_integer(wadd)) <= din;			--Write
			end if;
		end if;
	end process;
																										
	dout <=	my_ram(conv_integer(radd));					--Read

end Behavioral;

