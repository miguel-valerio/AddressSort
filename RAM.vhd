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
	generic	(	add_width:	positive := 10;												--Nº of RAM Address Bits
					dec_size:	positive := 4);												--Nº of Decoder Input Bits
	port		(	clk:			in std_logic;													--Clock
					WE:			in std_logic;													--Write Enable
					WADD:			in std_logic_vector(add_width-1 downto 0);			--Write Address
					RADD:			in std_logic_vector(add_width-dec_size-1 downto 0);--Read Address (no need to use offset when reading)
					DIN:			in std_logic;													--Data In
					DOUT:			out std_logic_vector(2**dec_size-1 downto 0));		--Data Out
end RAM;

architecture Behavioral of RAM is

	type blk				is array (2**(add_width-dec_size)-1 downto 0)				--Block address
							of std_logic_vector((2**dec_size)-1 downto 0);
	signal my_ram:		blk;																		--RAM is a set of blocks
	signal w_blk: 		std_logic_vector(add_width-1 downto 4);						--Block to write
	signal w_offset:	std_logic_vector(3 downto 0);										--Offset in block to be written

begin

	w_blk 		<= WADD(add_width-1 downto 4);											--Block to write
	w_offset		<= WADD(3 downto 0);															--Offset in block to be written

	process(clk)
	begin
		if rising_edge(clk) then
			if WE = '1' then 
				my_ram(conv_integer(w_blk))(conv_integer(w_offset)) <= DIN;			--Write
			end if;
		end if;
	end process;
																										
	DOUT <=	my_ram(conv_integer(RADD));													--Read

end Behavioral;

