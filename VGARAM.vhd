----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:09:04 04/15/2014 
-- Design Name: 
-- Module Name:    VGARAM - Behavioral 
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

entity VGARAM is
	generic(	add_width	: positive := 12;											--8x12 Tiles spread by 640*480 = 40*60 = 3600 = 12 bits needed
				data_width	: positive := 5);											--5 bits needed to represent Tiles
	port(		clk			: in std_logic;											--Clock
				we				: in std_logic;											--Write Enable
				wadd0			: in std_logic_vector(add_width-1 downto 0);		--Address where din will be written to
				wadd1			: in std_logic_vector(add_width-1 downto 0);
				wadd2			: in std_logic_vector(add_width-1 downto 0);
				wadd3			: in std_logic_vector(add_width-1 downto 0);
				din0			: in std_logic_vector(data_width-1 downto 0);	--Data received from Decoder
				din1			: in std_logic_vector(data_width-1 downto 0);
				din2			: in std_logic_vector(data_width-1 downto 0);
				din3			: in std_logic_vector(data_width-1 downto 0);
				radd			: in std_logic_vector(add_width-1 downto 0);		--Address where dout will be read from
				dout			: out std_logic_vector(data_width-1 downto 0));	--Data sent to VGAText
				
end VGARAM;

architecture Behavioral of VGARAM is

	type RAM is array (2**add_width-1 downto 0) of std_logic_vector(data_width-1 downto 0);
	signal my_ram: RAM;

begin

	process(clk)
	begin
		if rising_edge(clk) then
			if we = '1' then
				if din3 /= "11111" then
					my_ram(conv_integer(wadd3)) <= din3;
				end if;
				if din2 /= "11111" then
					my_ram(conv_integer(wadd2)) <= din2;
				end if;
				if din1 /= "11111" then
					my_ram(conv_integer(wadd1)) <= din1;
				end if;
				if din0 /= "11111" then
					my_ram(conv_integer(wadd0)) <= din0;
				end if;
			end if;
		end if;
	end process;
	
	dout <= my_ram(conv_integer(radd));

end Behavioral;

