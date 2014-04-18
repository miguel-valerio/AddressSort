----------------------------------------------------------------------------------
-- Company:				Computação Reconfigurável - Universidade de Aveiro
-- Engineer: 			Miguel Valério - 59606
-- 
-- Create Date:		11:44:33 04/13/2014 
-- Design Name: 
-- Module Name:		RAM - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
	generic	(	add_width:	positive := 10);												--Nº of RAM Address Bits
	port		(	clk:			in std_logic;													--Clock
					we:			in std_logic;													--Write Enable
					wadd:			in std_logic_vector(add_width-1 downto 0);			--Write Address
					radd:			in std_logic_vector(add_width-1 downto 0);			--Read Address
					din:			in std_logic;													--Data In
					dout:			out std_logic);												--Data Out
end RAM;

architecture Behavioral of RAM is

	type blk				is array (2**add_width-1 downto 0) of std_logic;			--RAM type: 1 address for every possible 
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

