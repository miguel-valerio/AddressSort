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
					WE:			in std_logic;													--Write Enable
					WADD:			in std_logic_vector(add_width-1 downto 0);			--Write Address
					RADD:			in std_logic_vector(add_width-5 downto 0);			--Read Address (refer to TopLevel for warning information)
					DIN:			in std_logic;													--Data In
					DOUT:			out std_logic_vector(15 downto 0));						--Data Out
end RAM;

architecture Behavioral of RAM is

	type offset			is array (15 downto 0) of std_logic;							--Address to write inside the block
	type blk 			is array (63 downto 0) of offset;								--//TODO
	signal my_ram: 	blk;																		--RAM is a set of blocks
	signal w_blk: 		std_logic_vector(add_width-1 downto 4);						--Block to write
	signal w_offset:	std_logic_vector(3 downto 0);										--Offset in block to be written
	signal r_blk:	 	std_logic_vector(add_width-1 downto 4);						--Block to read
	signal r_offset:	std_logic_vector(3 downto 0);										--Offset in block to be read
	signal temp_radd:	std_logic_vector(add_width-1 downto 0);						--Temporary Read Address (refer to TopLevel for warning information)

begin

	temp_radd 	<= RADD(add_width-5 downto 0) & "0000";								--Shift Left 4 (refer to TopLevel for warning information)
	w_blk 		<= WADD(add_width-1 downto 4);											--Block to write
	w_offset		<= WADD(3 downto 0);															--Offset in block to be written
	r_blk 		<= temp_radd(add_width-1 downto 4);										--Block to read
	r_offset		<= temp_radd(3 downto 0);													--Offset in block to be read

	process(clk)
	begin
		if rising_edge(clk) then
			if WE = '1' then 
				my_ram(conv_integer(w_blk))(conv_integer(w_offset)) <= DIN;			--Write
			end if;
		end if;
	end process;
	
	DOUT <= 	my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 15) & my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 14) &
				my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 13) & my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 12) &
				my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 11) & my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 10) &
				my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 9)  & my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 8)  &
				my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 7)  & my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 6)  &
				my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 5)  & my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 4)  &
				my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 3)  & my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 2)  &
				my_ram(conv_integer(r_blk))(conv_integer(r_offset) + 1)  & my_ram(conv_integer(r_blk))(conv_integer(r_offset));
																										--Read

end Behavioral;

