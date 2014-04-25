----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:06:39 04/18/2014 
-- Design Name: 
-- Module Name:    OnePortRAM - Behavioral 
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

entity OnePortRAM is
	generic	(	add_width:	positive := 10;												--Nº of RAM Address Bits
					data_width	: positive := 5);
	port		(	clk:			in std_logic;													--Clock
					we:			in std_logic;													--Write Enable
					wadd:			in std_logic_vector(add_width-1 downto 0);			--Write Address
					radd:			in std_logic_vector(add_width-1 downto 0);			--Read Address
					din:			in std_logic_vector(data_width-1 downto 0);			--Data In
					dout:			out std_logic_vector(data_width-1 downto 0));		--Data Out
end OnePortRAM;

architecture Behavioral of OnePortRAM is

	type ram is array (2**add_width-1 downto 0) of std_logic_vector(data_width-1 downto 0);
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

