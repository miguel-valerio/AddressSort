----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:30:57 04/17/2014 
-- Design Name: 
-- Module Name:    ClockGenerator - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClockGenerator is
	port(	clk	:in std_logic;					--Input Clock (100 MHz)
			clk25	:out std_logic);				--Output Clock(25 MHz)
end ClockGenerator;

architecture Behavioral of ClockGenerator is

	signal temp_clk	:std_logic := '0';	--Temporary Clock
	constant max		:integer := 4;			--25*4 = 100 MHz

begin

	process(clk)
		variable count :integer range 0 to max:= 0;
	begin
		if rising_edge(clk) then
			if count < max/2 then				--50% Duty Cycle
				clk25 <= '1';
				count := count + 1;
			elsif count < max then
				clk25 <= '0';
				count := count + 1;
			else
				count := 0;
				clk25 <= '1';
			end if;
		end if;
	end process;

end Behavioral;

