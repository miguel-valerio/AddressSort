library IEEE;
use IEEE.STD_LOGIC_1164.all;

package pack is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

	constant data_size		:positive := 10;
	
	constant ndata				:positive := 216;
	
	constant vga_wadd_size	:positive := 10;
	constant vga_din_size	:positive := 5;
	constant vga_radd_size	:positive := 12;
	constant vga_dout_size	:positive := 5;
	
	constant hcount_size		:positive := 11;
	constant vcount_size		:positive := 11;
	constant HBP				:positive := 48;				--Horizontal Back Porch End
	constant HAV				:positive := 688;				--Horizontal Active Video End
	constant HFP				:positive := 704;				--Horizontal Front Porch End
	constant HMAX				:positive := 800;				--Horizontal Single Pulse End
	constant VBP				:positive := 33;				--Vertical Back Porch End
	constant VAV				:positive := 513;				--Vertical Active Video End
	constant VFP				:positive := 523;				--Vertical Front Porch End
	constant VMAX				:positive := 525;				--Vertical Single Pulse End
	constant SPP				:std_logic := '0';			--Synch Pulse Polarity (Negative)
	
	constant rgb_size			:positive := 4;
	
	constant rom_radd_size	:positive := 5;
	constant rom_line_size	:positive := 4;
	constant rom_column_size:positive := 3;
	
	constant vga_add_size	:positive := 12;
	
	constant vga_ram_add		:positive := 10;

end pack;

package body pack is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end pack;
