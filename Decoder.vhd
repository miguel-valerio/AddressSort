library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.pack.all;

entity Decoder is
	port(		clk, en		:in std_logic;												--Clock, Enable
				radd			:in std_logic_vector(data_size-1 downto 0);		--Address where din will be read from
				din			:in std_logic;												--Data received from RAM
				wadd			:out std_logic_vector(vga_wadd_size-1 downto 0);		--Address where dout will be written to
				dout			:out std_logic_vector(vga_din_size-1 downto 0));
				
end Decoder;

architecture Behavioral of Decoder is

begin

--
--	process(clk)
--		variable temp_add :std_logic_vector(vga_wadd_size-1 downto 0) := (others => '0');
--	begin
--		if rising_edge(clk) then
--			if en = '1' then
--				if din = '1' then															--If flag is active
--					dout0 <= "000" & radd(data_size-1 downto data_size-2);	--Address will be written
--					dout1 <= "0" & radd(data_size-3 downto data_size-6);	--to VGARAM in order to
--					dout2 <= "0" & radd(data_size-7 downto data_size-10);	--be displayed		ATRIBUIR DINAMICAMENTE
--					dout3(3 downto 0) <= "0001";
--					temp_add := temp_add + 1;
--				else
--					dout0 <= (others => '1');			--All 1's means value will not be written
--					dout1 <= (others => '1');
--					dout2 <= (others => '1');
--					dout3(3 downto 0) <= (others => '1');
--				end if;
--			end if;
--			wadd0 <= temp_add;
--			wadd1 <= temp_add;
--			wadd2 <= temp_add;
--			wadd3 <= temp_add;
--		end if;
--	end process;

	dout(29) <= '1';

	process(clk)
		variable temp_add :std_logic_vector(vga_wadd_size-1 downto 0) := (others => '0');
	begin
		if rising_edge(clk) then
			if en = '1' then
				if din = '1' then
					dout(4 downto 0) <= (others => '0');
					dout(9 downto 5) <= "0" & radd(data_size-1 downto data_size-4);
					dout(14 downto 10) <= "0" & radd(data_size-5 downto data_size-8);
					dout(19 downto 15) <= "0" & radd(data_size-9 downto data_size-12);
					dout(24 downto 20) <= "0" & radd(data_size-13 downto data_size-16);
					dout(28 downto 25) <= "0001";
					temp_add := temp_add + 1;
				else
					dout(4 downto 0) <= (others => '1');
					dout(9 downto 5) <= (others => '1');
					dout(14 downto 10) <= (others => '1');
					dout(19 downto 15) <= (others => '1');
					dout(24 downto 20) <= (others => '1');
					dout(28 downto 25) <= (others => '1');
				end if;
			end if;
			wadd <= temp_add;
		end if;
	end process;

--	process(clk)
--	begin
--		if rising_edge(clk) then
--			if en = '1' then
--				dout <= 
--			end if;
--		end if;
--	end process;

end Behavioral;

