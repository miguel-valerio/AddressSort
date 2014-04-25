----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:50:34 04/15/2014 
-- Design Name: 
-- Module Name:    VGASync - Behavioral 
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

entity VGASync is
	port(		reset:	in std_logic;
				clk:		in std_logic;
				hs:		out std_logic;
				vs:		out std_logic;
				blank:	out std_logic;
				hcount:	out std_logic_vector(10 downto 0);
				vcount:	out std_logic_vector(10 downto 0));
end VGASync;

architecture Behavioral of VGASync is

	constant HBP	:integer := 48;				--Horizontal Back Porch End
	constant HAV	:integer := 688;				--Horizontal Active Video End
	constant HFP	:integer := 704;				--Horizontal Front Porch End
	constant HMAX	:integer := 800;				--Horizontal Single Pulse End
	
	constant VBP	:integer := 33;				--Vertical Back Porch End
	constant VAV	:integer := 513;				--Vertical Active Video End
	constant VFP	:integer := 523;				--Vertical Front Porch End
	constant VMAX	:integer := 525;				--Vertical Single Pulse End
	
	constant SPP	:std_logic := '0';			--Synch Pulse Polarity (Negative)
	
	signal hcounter:std_logic_vector(10 downto 0);	--Horizontal Counter
	signal vcounter:std_logic_vector(10 downto 0);	--Vertical Counter
	
	signal videoEN	:std_logic;

begin

	hcount <= hcounter;
	vcount <= vcounter;
	
	blank <= not videoEN when rising_edge(clk);
	
	videoEN <= '1' when (hcounter > HBP) and (hcounter <= HAV) and (vcounter > VBP) and (vcounter <= VAV) else '0';

	process(reset, clk)								--increment horizontal counter
	begin
		if rising_edge (clk) then
			if reset = '1' then
				hcounter <= (others => '0');
			elsif hcounter = HMAX then
				hcounter <= (others => '0');
			else
				hcounter <= hcounter + 1;
			end if;
		end if;
	end process;
	
	process(reset, clk)								--increment vertical counter
	begin
		if rising_edge (clk) then
			if reset = '1' then
				vcounter <= (others => '0');
			elsif hcounter = HMAX then
				if vcounter = VMAX then
					vcounter <= (others => '0');
				else
					vcounter <= vcounter + 1;
				end if;
			end if;
		end if;
	end process;
	
	process (clk)
	begin
		if rising_edge (clk) then
			if hcounter > HFP and hcounter <= HMAX then
				hs <= SPP;
			else
				hs <= not SPP;
			end if;
		end if;
	end process;
	
	process (clk)
	begin
		if rising_edge(clk) then
			if vcounter > VFP and vcounter <= VMAX then
				vs <= SPP;
			else
				vs <= not SPP;
			end if;
		end if;
	end process;

end Behavioral;

