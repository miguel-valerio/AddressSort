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
	generic(	data_width:	positive := 10;																--Data Size
				dec_size:	positive := 4);																--Number of Decoder Inputs bits
	port(		clk:			in std_logic;																	--Clock
				led:			out std_logic_vector(15 downto 0));										--Temporary Output
end TopLevel;

architecture Behavioral of TopLevel is

	signal random_num:	std_logic_vector(data_width-1 downto 0) := (others => '0');		--RNG Output
	signal WE:				std_logic := '1';																--RAM Write Enable
	signal EN:				std_logic := '0';																--Decoder Enable
	signal over:			std_logic := '0';																--Signals RAM populated with 216 values
	signal RADDR:			std_logic_vector(data_width-5 downto 0) := (others => '0');		--latches warning
	signal receive:		std_logic_vector(2**dec_size-1 downto 0);								--RAM output
	signal data:			std_logic_vector(2**dec_size-1 downto 0);								--Decoder output
	signal dividedc:		std_logic;																		--Divided Clock
						
begin

	generator:	entity work.RNG port map(clk, random_num, over);								--Random Number Generator
	
	ram:			entity work.RAM port map(clk, WE, random_num, RADDR, '1', receive);		--RAM
	
	decoder:		entity work.Decoder port map(clk, EN, receive, data);							--Decoder
	
	c_divider:	entity work.clock_divider port map (clk, '0', dividedc);						--Clock Divider
	
	WE <= '0' 	when over = '1' else '1';																--WE is disabled after 216 values 
																													--beign written to the RAM
																													
	EN <= '1' 	when over = '1' else '0';																--Decoder is enabled after 216 values 
																													--beign written to the RAM
	process(dividedc)
		variable count : integer := 0;								--Block counter
	begin
		if rising_edge(dividedc) then
			if over = '1' then
				if count < (2**(data_width-dec_size)-1) then		--Max nº of blocks
					led <= data;
					count := count + 1;
					RADDR <= RADDR + 1;
				end if;
			end if;
		end if;
	end process;

end Behavioral;

