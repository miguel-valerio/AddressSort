----------------------------------------------------------------------------------
-- Company:				Computação Reconfigurável - Universidade de Aveiro
-- engineer: 			Miguel Valério - 59606
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
	generic(	vga_wadd		:positive:= 12;
				data_width	:positive:= 10;
				dec_out		:positive:= 20);
	port(		clk, en		:in std_logic;												--Clock, Enable
				radd			:in std_logic_vector(data_width-1 downto 0);		--Address where din will be read from
				din			:in std_logic;												--Data received from RAM
				wadd0			:out std_logic_vector(vga_wadd-1 downto 0);		--Address where dout will be written to
				wadd1			:out std_logic_vector(vga_wadd-1 downto 0);
				wadd2			:out std_logic_vector(vga_wadd-1 downto 0);
				wadd3			:out std_logic_vector(vga_wadd-1 downto 0);
				dout0			:out std_logic_vector(4 downto 0);					--Data sent to VGARAM
				dout1			:out std_logic_vector(4 downto 0);
				dout2			:out std_logic_vector(4 downto 0);
				dout3			:out std_logic_vector(4 downto 0));
				
end Decoder;

architecture Behavioral of Decoder is

begin

	process(clk)
		variable temp_add :std_logic_vector(vga_wadd-1 downto 0) := (others => '0');
	begin
		if rising_edge(clk) then
			if din = '1' then															--If flag is active
				dout3 <= "000" & radd(data_width-1 downto data_width-2);	--Address will be written
				dout2 <= "0" & radd(data_width-3 downto data_width-6);	--to VGARAM in order to
				dout1 <= "0" & radd(data_width-7 downto data_width-10);	--be displayed
				dout0 <= "10001";
				if radd < "1111111111" then		--wadd will be incremented while RAM not completely read FIX
					temp_add := temp_add + 4;
				end if;
			else
				dout3 <= (others => '1');			--All 1's means value will not be written
				dout2 <= (others => '1');
				dout1 <= (others => '1');
				dout0 <= (others => '1');
			end if;
			wadd3 <= temp_add;
			wadd2 <= temp_add+1;
			wadd1 <= temp_add+2;
			wadd0 <= temp_add+3;
		end if;
	end process;

end Behavioral;

