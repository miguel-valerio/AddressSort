----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:44:33 04/13/2014 
-- Design Name: 
-- Module Name:    RAM - Behavioral 
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
	generic	(	add_width:	positive := 10);
	port		(	clk:			in std_logic;
					WE:			in std_logic;
					WADD:			in std_logic_vector(add_width-1 downto 0);
					RADD:			in std_logic_vector(add_width-5 downto 0);
					DIN:			in std_logic;
					DOUT:			out std_logic_vector(15 downto 0));
end RAM;

architecture Behavioral of RAM is

	type blk 			is array (15 downto 0) of std_logic;
	type page 			is array (63 downto 0) of blk;								--Nº DE PÁGINAS DE ACORDO COM GENERIC
	signal my_ram: 	page;
	signal w_page: 	std_logic_vector(add_width-1 downto 4);
	signal w_blk: 		std_logic_vector(3 downto 0);
	signal r_page: 	std_logic_vector(add_width-1 downto 4);
	signal r_blk: 		std_logic_vector(3 downto 0);
	signal temp_radd:	std_logic_vector(add_width-1 downto 0);					--latches warning

begin

	temp_radd 	<= RADD(add_width-5 downto 0) & "0000";							--latches warning
	w_page 		<= WADD(add_width-1 downto 4);
	w_blk 		<= WADD(3 downto 0);
	r_page 		<= temp_radd(add_width-1 downto 4);
	r_blk 		<= temp_radd(3 downto 0);

	process(clk)
	begin
		if rising_edge(clk) then
			if WE = '1' then 
				my_ram(conv_integer(w_page))(conv_integer(w_blk)) <= DIN;
			end if;
		end if;
	end process;
	
	DOUT <= 	my_ram(conv_integer(r_page))(conv_integer(r_blk) + 15) & my_ram(conv_integer(r_page))(conv_integer(r_blk) + 14) &
				my_ram(conv_integer(r_page))(conv_integer(r_blk) + 13) & my_ram(conv_integer(r_page))(conv_integer(r_blk) + 12) &
				my_ram(conv_integer(r_page))(conv_integer(r_blk) + 11) & my_ram(conv_integer(r_page))(conv_integer(r_blk) + 10) &
				my_ram(conv_integer(r_page))(conv_integer(r_blk) + 9)  & my_ram(conv_integer(r_page))(conv_integer(r_blk) + 8)  &
				my_ram(conv_integer(r_page))(conv_integer(r_blk) + 7)  & my_ram(conv_integer(r_page))(conv_integer(r_blk) + 6)  &
				my_ram(conv_integer(r_page))(conv_integer(r_blk) + 5)  & my_ram(conv_integer(r_page))(conv_integer(r_blk) + 4)  &
				my_ram(conv_integer(r_page))(conv_integer(r_blk) + 3)  & my_ram(conv_integer(r_page))(conv_integer(r_blk) + 2)  &
				my_ram(conv_integer(r_page))(conv_integer(r_blk) + 1)  & my_ram(conv_integer(r_page))(conv_integer(r_blk));

end Behavioral;

