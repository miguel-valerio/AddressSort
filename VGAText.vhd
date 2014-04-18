----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:41:25 04/17/2014 
-- Design Name: 
-- Module Name:    VGAText - Behavioral 
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

entity VGAText is
	generic(	add_width	:positive := 12;
				data_width	:positive := 5;
				rom_size		:positive := 5;
				line_width	:positive := 4;
				column_width:positive := 3);
	port(		blank			:in std_logic;
				hcount		:in std_logic_vector(10 downto 0);
				vcount		:in std_logic_vector(10 downto 0);
				red			:out std_logic_vector(3 downto 0);
				green			:out std_logic_vector(3 downto 0);
				blue			:out std_logic_vector(3 downto 0);
				ram_data		:in std_logic_vector(data_width-1 downto 0);			--LINHA
				ram_add		:out std_logic_vector(add_width-1 downto 0);			--TILE (de 80*40)
				rom_data		:in std_logic;
				rom_add		:out std_logic_vector(rom_size-1 downto 0);
				rom_line		:out std_logic_vector(line_width-1 downto 0);
				rom_column	:out std_logic_vector(column_width-1 downto 0));
end VGAText;

architecture Behavioral of VGAText is

	constant HBP		:integer := 48;				--Horizontal Back Porch End
	constant HAV		:integer := 688;				--Horizontal Active Video End
	
	constant VBP		:integer := 29;				--Vertical Back Porch End
	constant VAV		:integer := 509;				--Vertical Active Video End
	
	signal hc			:std_logic_vector(7 downto 0) := (others => '0');
	signal vc			:std_logic_vector(7 downto 0) := (others => '0');
	
	signal h				:integer range 0 to 7:= 0;
	signal v				:integer range 0 to 11:= 0;

begin

	h <= conv_integer(hcount-HBP) rem 8;
	v <= conv_integer(vcount-VBP) rem 12;

	hc <= hc + 1 when (h) = 0;
	vc <= vc + 1 when (v) = 0;

	ram_add <= conv_std_logic_vector(conv_integer(hc) + (conv_integer(vc)*40), add_width);
	rom_add <= ram_data;
	rom_line <= conv_std_logic_vector(v, line_width);
	rom_column <= conv_std_logic_vector(h, column_width);
	
	process(blank, rom_data, h, v, ram_data)
	begin
		if blank = '0' then
			if rom_data = '1' then
				green <= (others => '1');
			else
				green <= (others => '0');
			end if;
			red <= (others => '0');
			blue <= (others => '0');
		end if;
	end process;

end Behavioral;

