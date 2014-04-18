library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ArithmeticBlock is
	 generic (AddressBits 		: natural;
				 StateMaxValue 	: natural;
				 NumberOfColumns	: natural);
    Port ( ASCII_in 		: in  STD_LOGIC_VECTOR (7 downto 0);
           ASCII_out 	: out  STD_LOGIC_VECTOR (7 downto 0);
           Address_out 	: out  STD_LOGIC_VECTOR (AddressBits - 1 downto 0);
           clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
			  sw				: in std_logic_vector(7 downto 0));
end ArithmeticBlock;

architecture Behavioral of ArithmeticBlock is
	signal VGAstate		:  integer range 0 to StateMaxValue;
	
	signal line, line_local   		: integer range 0 to 13;
	signal column, column_local 	: integer range 0 to 35;
	signal binary1, binary2, binaryR	: std_logic_vector(7 downto 0);
	signal BCD0_1,BCD1_1,BCD2_1		: std_logic_vector(3 downto 0);
	signal BCD0_2,BCD1_2,BCD2_2		: std_logic_vector(3 downto 0);
	signal BCD0_R,BCD1_R,BCD2_R		: std_logic_vector(3 downto 0);

	signal ASCII_local      		: std_logic_vector(7 downto 0);

	constant Operand1	: string(1 to 16)	:= "Operand 1   =   ";
	constant Operand2	: string(1 to 16)	:= "Operand 2   =   ";
	constant Result 	: string(1 to 16)	:= "Result      =   ";
	
begin
	binary1 <= "0000"&sw(7 downto 4);
	binary2 <= "0000"&sw(3 downto 0);
	binaryR <= ASCII_in;--sw(7 downto 4) * sw(3 downto 0);

	process(clk, rst)
	begin
		if rst = '1' then 
			VGAstate <= 0;
		elsif falling_edge(clk) then
				if VGAstate=StateMaxValue then VGAstate<=0; else VGAstate<= VGAstate + 1; end if;
		end if;
	end process;
	
  process(clk, rst)
	begin
		if rst= '1' then
			null;
		elsif rising_edge(clk) then
			line_local <= 0; column_local <= 0; ASCII_local <= "00100000";
			case VGAstate is
				when 1 to 16 =>  
								line_local <= 9;
								column_local <= 14 + VGAstate;
								ASCII_local <= conv_std_logic_vector(character'pos(Operand1(VGAstate)), 8);
				when 17 to 32 =>  
								line_local <= 11;
								column_local <= 14 + VGAstate - 16;
								ASCII_local <= conv_std_logic_vector(character'pos(Operand2(VGAstate-16)), 8);
				when 33 to 48 =>  
								line_local <= 13;
								column_local <= 14 + VGAstate - 32;
								ASCII_local <= conv_std_logic_vector(character'pos(Result(VGAstate-32)), 8);				
				when 49 to 51 => line_local <= 9;
								column_local <= 14 + VGAstate - 48 + 18;
								if VGAstate = 49 then ASCII_local <= "0011"&BCD2_1;
								elsif VGAstate = 50 then ASCII_local <= "0011"&BCD1_1;
								else ASCII_local <= "0011"&BCD0_1;
								end if;
				when 52 to 54 => line_local <= 11;
								column_local <= 14 + VGAstate - 51 + 18;
								if VGAstate = 52 then ASCII_local <= "0011"&BCD2_2;
								elsif VGAstate = 53 then ASCII_local <= "0011"&BCD1_2;
								else ASCII_local <= "0011"&BCD0_2;
								end if;
				when 55 to 57 => line_local <= 13;
								column_local <= 14 + VGAstate - 54 + 18;
								if VGAstate = 55 then ASCII_local <= "0011"&BCD2_R;
								elsif VGAstate = 56 then ASCII_local <= "0011"&BCD1_R;
								elsif VGAstate = 57 then ASCII_local <= "0011"&BCD0_R;
								else ASCII_local <= "00100000";
								end if;
				when others  =>	ASCII_local <= "10100000";
			end case;
		end if;
	end process;

ASCII_out <= ASCII_local;
column <= column_local;
line <= line_local;
Address_out <= conv_std_logic_vector((line*NumberOfColumns + column),AddressBits);	

BinToBCD1	:	entity work.BinToBCD8
	port map(clk,'0',open,binary1,BCD2_1,BCD1_1,BCD0_1);

BinToBCD2	:	entity work.BinToBCD8
	port map(clk,'0',open,binary2,BCD2_2,BCD1_2,BCD0_2);

BinToBCDR	:	entity work.BinToBCD8
	port map(clk,'0',open,binaryR,BCD2_R,BCD1_R,BCD0_R);
 
end Behavioral;