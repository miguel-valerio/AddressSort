----------------------------------------------------------------------------------
-- Company:				Computação Reconfigurável - Universidade de Aveiro
-- Engineer: 			Miguel Valério - 59606
-- 
-- Create Date:		12:33:19 04/13/2014 
-- Design Name: 
-- Module Name:		Decoder - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
	generic(	data_width:	positive:= 10;														--Data Size TODO
				dec_size:	positive:= 16);													--Number of Decoder Inputs
	port(		clk, EN:		in std_logic;														--Clock, Enable
				DIN:			in std_logic_vector (dec_size-1 downto 0);				--Data In
				DOUT:			out std_logic_vector(dec_size-1 downto 0));				--Data Out
end Decoder;

architecture Behavioral of Decoder is

	signal dividedc: std_logic;																--Divided Clock Signal

begin

	c_divider:	entity work.clock_divider port map (clk, '0', dividedc);			--Clock Divider

	process(dividedc)
	begin
		if rising_edge(dividedc) then
			if EN = '1' then
				DOUT <= DIN;																		--Result
			end if;
		end if;
	end process;

end Behavioral;

