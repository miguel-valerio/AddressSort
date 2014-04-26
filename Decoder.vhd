library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.pack.all;

entity Decoder is
	port(		clk, en		:in std_logic;												--Clock, Enable
				radd			:in std_logic_vector(data_size-1 downto 0);		--Address where din will be read from
				din			:in std_logic;												--Data received from RAM
				wadd0			:out std_logic_vector(vga_wadd_size-1 downto 0);		--Address where dout will be written to
				wadd1			:out std_logic_vector(vga_wadd_size-1 downto 0);
				wadd2			:out std_logic_vector(vga_wadd_size-1 downto 0);
				wadd3			:out std_logic_vector(vga_wadd_size-1 downto 0);
				dout0			:out std_logic_vector(vga_din_size-1 downto 0);					--Data sent to VGARAM
				dout1			:out std_logic_vector(vga_din_size-1 downto 0);
				dout2			:out std_logic_vector(vga_din_size-1 downto 0);
				dout3			:out std_logic_vector(vga_din_size-1 downto 0));
				
end Decoder;

architecture Behavioral of Decoder is

begin

	dout3(4) <= '1';

	process(clk)
		variable temp_add :std_logic_vector(vga_wadd_size-1 downto 0) := (others => '0');
	begin
		if rising_edge(clk) then
			if en = '1' then
				if din = '1' then															--If flag is active
					dout0 <= "000" & radd(data_size-1 downto data_size-2);	--Address will be written
					dout1 <= "0" & radd(data_size-3 downto data_size-6);	--to VGARAM in order to
					dout2 <= "0" & radd(data_size-7 downto data_size-10);	--be displayed		ATRIBUIR DINAMICAMENTE
					dout3(3 downto 0) <= "0001";
					temp_add := temp_add + 1;
				else
					dout0 <= (others => '1');			--All 1's means value will not be written
					dout1 <= (others => '1');
					dout2 <= (others => '1');
					dout3(3 downto 0) <= (others => '1');
				end if;
			end if;
			wadd0 <= temp_add;
			wadd1 <= temp_add;
			wadd2 <= temp_add;
			wadd3 <= temp_add;
		end if;
	end process;

end Behavioral;

