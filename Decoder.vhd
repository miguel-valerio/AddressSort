----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:33:19 04/13/2014 
-- Design Name: 
-- Module Name:    Decoder - Behavioral 
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
	generic(	data_width:	positive:= 10;
				size:			positive:= 16);
	port(		clk, EN:		in std_logic;
				data:		in std_logic_vector (size-1 downto 0);
				output:	out std_logic_vector(size-1 downto 0));
end Decoder;

architecture Behavioral of Decoder is

	signal dividedc: std_logic;

begin

	c_divider:	entity work.clock_divider port map (clk, '0', dividedc);

	process(dividedc)
	begin
		if rising_edge(dividedc) then
			if EN = '1' then
				output <= data;
			end if;
		end if;
	end process;

end Behavioral;

