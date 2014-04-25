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
				addr			: positive := 10;											--1 Port Ram Address
				data_width	: positive := 5);											--5 bits needed to represent Tiles
	port(		clk			: in std_logic;											--Clock
				we				: in std_logic;											--Write Enable
				wadd0			: in std_logic_vector(add_width-3 downto 0);		--Address where din will be written to
				wadd1			: in std_logic_vector(add_width-3 downto 0);
				wadd2			: in std_logic_vector(add_width-3 downto 0);
				wadd3			: in std_logic_vector(add_width-3 downto 0);
				din0			: in std_logic_vector(data_width-1 downto 0);	--Data received from Decoder
				din1			: in std_logic_vector(data_width-1 downto 0);
				din2			: in std_logic_vector(data_width-1 downto 0);
				din3			: in std_logic_vector(data_width-1 downto 0);
				radd			: in std_logic_vector(add_width-1 downto 0);		--Address where dout will be read from
				dout			: out std_logic_vector(data_width-1 downto 0));	--Data sent to VGAText
				
end VGARAM;

architecture Behavioral of VGARAM is

--	signal we0		:std_logic := '1';
--	signal we1		:std_logic := '1';
--	signal we2		:std_logic := '1';
--	signal we3		:std_logic := '1';
	signal radd0	:std_logic_vector(addr-1 downto 0);
	signal radd1	:std_logic_vector(addr-1 downto 0);
	signal radd2	:std_logic_vector(addr-1 downto 0);
	signal radd3	:std_logic_vector(addr-1 downto 0);
	signal dout0	:std_logic_vector(data_width-1 downto 0);
	signal dout1	:std_logic_vector(data_width-1 downto 0);
	signal dout2	:std_logic_vector(data_width-1 downto 0);
	signal dout3	:std_logic_vector(data_width-1 downto 0);

begin

	ram0		:entity work.OnePortRam port map (clk => clk, we => we, wadd => wadd0, radd => radd0, 
															din => din0, dout => dout0);
															
	ram1		:entity work.OnePortRam port map (clk => clk, we => we, wadd => wadd1, radd => radd1, 
															din => din1, dout => dout1);
															
	ram2		:entity work.OnePortRam port map (clk => clk, we => we, wadd => wadd2, radd => radd2, 
															din => din2, dout => dout2);
														
	ram3		:entity work.OnePortRam port map (clk => clk, we => we, wadd => wadd3, radd => radd3, 
															din => din3, dout => dout3);
	
--	radd3 <= radd(add_width-1 downto 2) when radd(1 downto 0) = "11";
--	radd3 <= radd(add_width-1 downto 2) when radd(1 downto 0) = "11";
--	radd2 <= radd(add_width-1 downto 2) when radd(1 downto 0) = "10";
--	radd1 <= radd(add_width-1 downto 2) when radd(1 downto 0) = "01";
--	radd0 <= radd(add_width-1 downto 2) when radd(1 downto 0) = "00";
	
	process(clk)
	begin
		if rising_edge(clk) then
			if radd(1 downto 0) = "11" then
				radd3 <= radd(add_width-1 downto 2);
				dout <= dout3;
			elsif radd(1 downto 0) = "10" then
				radd2 <= radd(add_width-1 downto 2);
				dout <= dout2;
			elsif radd(1 downto 0) = "01" then
				radd1 <= radd(add_width-1 downto 2);
				dout <= dout1;
			else
				radd0 <= radd(add_width-1 downto 2);
				dout <= dout0;
			end if;
		end if;
	end process;

--	process(clk)
--	begin
--		if rising_edge(clk) then
--			if we = '1' then
--				if din3 /= "11111" then
--					my_ram(conv_integer(wadd3)) <= din3;
--				end if;
--				if din2 /= "11111" then
--					my_ram(conv_integer(wadd2)) <= din2;
--				end if;
--				if din1 /= "11111" then
--					my_ram(conv_integer(wadd1)) <= din1;
--				end if;
--				if din0 /= "11111" then
--					my_ram(conv_integer(wadd0)) <= din0;
--				end if;
--				end if;
--			end if;
--		end if;
--	end process;
--	
--	dout <= my_ram(conv_integer(radd));

end Behavioral;

