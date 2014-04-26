library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.pack.all;

entity RNG is
	port(		clk:			in std_logic;
				random_num:	out std_logic_vector(data_size-1 downto 0);
				over:			out std_logic);
end RNG;

architecture Behavioral of RNG is

begin

	process(clk)
		variable rand_temp : std_logic_vector(data_size-1 downto 0):=(data_size-1 => '1',others => '0');
      variable temp : std_logic := '0';
		variable count : integer range 0 to ndata:= 0;
      begin
      if rising_edge(clk) then
			if (count < ndata) then
				over <= '0';
				temp := rand_temp(data_size-1) xor rand_temp(data_size-2);
				rand_temp(data_size-1 downto 1) := rand_temp(data_size-2 downto 0);
				rand_temp(0) := temp;
				count:=count+1;
			else
				over <= '1';
			end if;
      end if;
      random_num <= rand_temp;
	end process;

end Behavioral;

