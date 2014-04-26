library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use work.pack.all;

entity ClockGenerator is
	port(	clk	:in std_logic;					--Input Clock (100 MHz)
			clk25	:out std_logic);				--Output Clock(25 MHz)
end ClockGenerator;

architecture Behavioral of ClockGenerator is

		signal temp_clk	:std_logic := '0';	--Temporary Clock
		constant max	:integer := 4;				--25*4 = 100 MHz

begin

		process(clk)
			variable count :integer range 0 to max:= 0;
		begin
		if rising_edge(clk) then
			if count < max/2 then	--50% Duty Cycle
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

