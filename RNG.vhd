----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:01:04 04/13/2014 
-- Design Name: 
-- Module Name:    RNG - Behavioral 
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

entity RNG is
	generic(	data_width:	positive:= 10;
				ndata:		positive:= 216);
	port(		clk:			in std_logic;
				random_num:	out std_logic_vector(data_width-1 downto 0);
				over:			out std_logic);
end RNG;

architecture Behavioral of RNG is

begin

	process(clk)
		variable rand_temp : std_logic_vector(data_width-1 downto 0):=(data_width-1 => '1',others => '0');
      variable temp : std_logic := '0';
		variable count : integer := 0;
      begin
      if rising_edge(clk) then
			if (count < ndata) then
				over <= '0';
				temp := rand_temp(data_width-1) xor rand_temp(data_width-2);
				rand_temp(data_width-1 downto 1) := rand_temp(data_width-2 downto 0);
				rand_temp(0) := temp;
				count:=count+1;
			else
				over <= '1';
			end if;
      end if;
      random_num <= rand_temp;
	end process;

end Behavioral;

