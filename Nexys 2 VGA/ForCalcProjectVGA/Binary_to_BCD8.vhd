library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BinToBCD8 is	-- max value of data item is 9999 and max size is 14
generic( size_of_data_to_convert : 	integer := 8 ); 
port ( 	clk 	: in  STD_LOGIC;
          	reset 	: in  STD_LOGIC; 
         	ready 	: out STD_LOGIC;
          	binary 	: in  STD_LOGIC_VECTOR (size_of_data_to_convert-1 downto 0);
          	BCD2 	: out  STD_LOGIC_VECTOR (3 downto 0);
          	BCD1 	: out  STD_LOGIC_VECTOR (3 downto 0);
          	BCD0 	: out  STD_LOGIC_VECTOR (3 downto 0));
end BinToBCD8;
architecture Behavioral of BinToBCD8 is
type state is (idle, op, done);
signal c_s, n_s 	: state;
signal BCD2_c, BCD1_c, BCD0_c, BCD2_n, BCD1_n, BCD0_n 
: unsigned(3 downto 0);
signal BCD1_tmp, BCD0_tmp 	: unsigned(3 downto 0); 
signal BCD2_tmp  			: unsigned(2 downto 0);
signal int_rg_c, int_rg_n 			: STD_LOGIC_VECTOR (size_of_data_to_convert-1 downto 0); 
signal index_c, index_n 			: unsigned(3 downto 0);
signal get_outputs	: std_logic;
begin 
process(clk, reset)
begin
	if rising_edge(clk) then
		if reset = '1' then
			c_s <= idle;	-- idle state at the beginning
			BCD2_c <= (others => '0'); 
			BCD1_c <= (others => '0');
			BCD0_c <= (others => '0');
			BCD0 <= (others=>'0');	BCD1 <= (others=>'0'); BCD2 <= (others=>'0');
		else
			c_s <= n_s;		-- next values are copied to current values
			BCD2_c <= BCD2_n;
			BCD1_c <= BCD1_n;
			BCD0_c <= BCD0_n;
			index_c <= index_n;
			int_rg_c <= int_rg_n;
				if (get_outputs = '1') then
					BCD0 <= std_logic_vector(BCD0_n);
					BCD1 <= std_logic_vector(BCD1_n);
					BCD2 <= std_logic_vector(BCD2_n);
				end if;
		end if;
	end if;
end process;
process (c_s, BCD2_c, BCD1_c, BCD0_c, BCD2_tmp,
		BCD1_tmp, BCD0_tmp, binary, int_rg_c, index_c, index_n)
begin	
get_outputs <= '0';	
n_s <= c_s;		
BCD2_n <= BCD2_c;	BCD1_n <= BCD1_c;
BCD0_n <= BCD0_c;	index_n <= index_c;
int_rg_n <= int_rg_c;	ready <= '0';
case c_s is	-- at the beginning ready is 0
when idle => n_s <= op;	
	ready <= '0';
	int_rg_n <= binary;
	index_n <= "1000";		
when op =>	ready <= '0';
	int_rg_n <= int_rg_c(size_of_data_to_convert-2 downto 0) & '0';
	BCD0_n <= BCD0_tmp(2 downto 0) & int_rg_c(size_of_data_to_convert-1);
	BCD1_n <= BCD1_tmp(2 downto 0) & BCD0_tmp(3);
	BCD2_n <= BCD2_tmp(2 downto 0) & BCD1_tmp(3);
	index_n <= index_c - 1;
	if (index_n = 0) then 	n_s <= done; get_outputs <= '1';
	end if;
when done => n_s <= idle; 		-- remains in done until the next reset
	BCD2_n <= (others => '0');
	BCD1_n <= (others => '0');
	BCD0_n <= (others => '0');
	ready <= '1'; -- now ready is 1, i.e. a new conversion can be done
end case;
end process;
BCD0_tmp <= BCD0_c + 3 when BCD0_c > 4 else BCD0_c;
BCD1_tmp <= BCD1_c + 3 when BCD1_c > 4 else BCD1_c;
BCD2_tmp <= BCD2_c(2 downto 0) + 3 when BCD2_c > 4 else BCD2_c(2 downto 0);
end Behavioral;