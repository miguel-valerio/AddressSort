----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:07:43 04/13/2014 
-- Design Name: 
-- Module Name:    TopLevel - Behavioral 
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

entity TopLevel is
	generic(	data_width:	positive := 10;
				dec_size:	positive := 16);
	port(		clk:			in std_logic;
				led:			out std_logic_vector(15 downto 0));
end TopLevel;

architecture Behavioral of TopLevel is

	signal random_num:	std_logic_vector(data_width-1 downto 0) := (others => '0');
	signal WE:				std_logic := '1';
	signal EN:				std_logic := '0';
	signal over:			std_logic := '0';
	signal RADDR:			std_logic_vector(data_width-5 downto 0) := (others => '0');		--latches warning
	signal receive:		std_logic_vector(dec_size-1 downto 0);
	signal data:			std_logic_vector(dec_size-1 downto 0);
	signal dividedc:		std_logic;
						
begin

	generator:	entity work.RNG port map(clk, random_num, over);
	
	ram:			entity work.RAM port map(clk, WE, random_num, RADDR, '1', receive);
	
	decoder:		entity work.Decoder port map(clk, EN, receive, data);
	
	c_divider:	entity work.clock_divider port map (clk, '0', dividedc);
	
	WE <= '0' when over = '1' else '1';
	
	EN <= '1' when over = '1' else '0';
	
	process(dividedc)
		variable count : integer := 0;
	begin
		if rising_edge(dividedc) then
			if over = '1' then
				if count < 64 then
					led <= data;
					count := count + 1;
					RADDR <= RADDR + 1;	--latches warning 4 less significant bits not being used when incrementing + 16
				end if;
			end if;
		end if;
	end process;

end Behavioral;

