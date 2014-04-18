library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity GPIO_LOGIC is
	port(
		-- IPIF --
		Bus2IP_Clk_IN     : IN  STD_LOGIC;
		Bus2IP_Resetn_IN  : IN  STD_LOGIC;
		Bus2IP_Addr_IN    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Bus2IP_RNW_IN     : IN  STD_LOGIC;
		Bus2IP_BE_IN      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		Bus2IP_CS_IN      : IN std_logic_vector(0 DOWNTO 0);
		Bus2IP_RdCE_IN    : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
		Bus2IP_WrCE_IN    : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
		Bus2IP_Data_IN    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		IP2Bus_Data_OUT   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		IP2Bus_WrAck_OUT  : OUT STD_LOGIC;
		IP2Bus_RdAck_OUT  : OUT STD_LOGIC;
		IP2Bus_Error_OUT  : OUT STD_LOGIC;
        
		--Control Unit --
		--Used to read the inputs--
		Switches_IN       : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		--Used to output the result--
		Leds_OUT          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		        clk               : in std_logic;
        		HSync             : out std_logic;
                VSync             : out std_logic;  
                VGARed            : out std_logic_vector(3 downto 0);
                VGAGreen          : out std_logic_vector(3 downto 0);
                VGABlue           : out std_logic_vector(3 downto 0)
	);

end GPIO_LOGIC;

architecture Behavioral of GPIO_LOGIC is
	Constant zeros_C      :  STD_LOGIC_VECTOR(31 DOWNTO 8) := (others => '0');
	-- IPIF --
	Signal iP2Bus_Data    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	Signal iP2Bus_WrAck   : STD_LOGIC;
	Signal iP2Bus_RdAck   : STD_LOGIC;
	--Control Unit --   
	Signal Leds           : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	Signal Switches       : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');

begin

	action : process(Bus2IP_Clk_IN)
	begin
		if falling_edge(Bus2IP_Clk_IN) then
			IP2Bus_WrAck <= '0';
			IP2Bus_RdAck <= '0';
			Switches <= Switches_IN;
			-- Regard less of the address, every read operation that falls between the defined range 
			-- Will read the switches
            if Bus2IP_RdCE_IN(0) = '1' then    --A read operation is requested
                IP2Bus_RdAck <= '1';        --Inform the PS that data requested is available to be read.
                
            -- Regard less of the address, every write operation that falls between the defined range 
            -- Will write to the leds
            elsif Bus2IP_WrCE_IN(0) = '1' then --A write operation is requested
                Leds <= Bus2IP_Data_IN(7 downto 0);
                IP2Bus_WrAck <= '1';        --Inform the PS that data sent has been acepted.
            end if;
         end if;
	end process action;
	
    -- Data to send to the PS is always ready.
    iP2Bus_Data <= zeros_C & Switches;    
    IP2Bus_Data_OUT  <= IP2Bus_Data;
    -- Data output to the leds
    Leds_OUT <= Leds;
                          
	IP2Bus_RdAck_OUT <= IP2Bus_RdAck;
	IP2Bus_WrAck_OUT <= iP2Bus_WrAck;
	
	IP2Bus_Error_OUT <= '0';
	
		VGA_comp:		entity work.VGA
        	port map (--UserReset : in STD_LOGIC;  -- Button0
        		   clk        => clk,
        		   HSync      => HSync,
        		   VSync      => VSync,
        		   VGARed     => VGARed,
        		   VGAGreen   => VGAGreen,
        		   VGABlue    => VGABlue,
        		   sw		  => Switches_IN,
        		   ASCII_in   => Leds);

end Behavioral;
