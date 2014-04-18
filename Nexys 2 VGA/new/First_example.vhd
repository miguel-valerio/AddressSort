library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v4_0;
use proc_common_v4_0.proc_common_pkg.all;
use proc_common_v4_0.proc_common_pkg.clog2;
use proc_common_v4_0.proc_common_pkg.max2;
use proc_common_v4_0.family_support.all;
use proc_common_v4_0.ipif_pkg.all;

library axi_lite_ipif_v2_0;
use axi_lite_ipif_v2_0.all;

-- Top level component definition --
entity GPIO_Control is
	port(
	   
		-- AXI Slave Interface --
		S_AXI_ACLK        : IN  STD_LOGIC;
		S_AXI_ARESETN     : IN  STD_LOGIC;
		S_AXI_AWADDR      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		S_AXI_AWVALID     : IN  STD_LOGIC;
		S_AXI_AWREADY     : OUT STD_LOGIC;
		S_AXI_WDATA       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		S_AXI_WSTRB       : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		S_AXI_WVALID      : IN  STD_LOGIC;
		S_AXI_WREADY      : OUT STD_LOGIC;
		S_AXI_BRESP       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		S_AXI_BVALID      : OUT STD_LOGIC;
		S_AXI_BREADY      : IN  STD_LOGIC;
		S_AXI_ARADDR      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		S_AXI_ARVALID     : IN  STD_LOGIC;
		S_AXI_ARREADY     : OUT STD_LOGIC;
		S_AXI_RDATA       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		S_AXI_RRESP       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		S_AXI_RVALID      : OUT STD_LOGIC;
		S_AXI_RREADY      : IN  STD_LOGIC;

		--Control Unit --
		--Used to read the inputs--
		Switches_IN       : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		--Used to output the result--
        Leds_OUT          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                
                        HSync             : out std_logic;
                        VSync             : out std_logic;  
                        VGARed            : out std_logic_vector(3 downto 0);
                        VGAGreen          : out std_logic_vector(3 downto 0);
                        VGABlue           : out std_logic_vector(3 downto 0)
	);

end GPIO_Control;

architecture RTL of GPIO_Control is

    -- Parameters for the IPIF instantiation --
    -- Definition of the addressing space --
    constant C_ARD_ADDR_RANGE_ARRAY: SLV64_ARRAY_TYPE :=  
         (
           X"0000_0000_0000_0000", -- IP user0 base address
           X"0000_0000_0000_0FFF"  -- IP user0 high address
         );

    -- Definition of the number of Chip Enable signals for each addressing space defined above--
    constant C_ARD_NUM_CE_ARRAY    : INTEGER_ARRAY_TYPE := 
        (
            0 =>1         -- User0 CE Number
        );
        
    -- Definition of the target board --
    constant C_FAMILY              : string  := "zynq";

    -- Definition of the minimum size of the addressing sapces defined above --
    -- Nao e bem isto
    constant  C_S_AXI_MIN_SIZE      : std_logic_vector(31 downto 0):= X"0000_0FFF";

    -- Signals used to connect the IPIF module to the calculator module. --
	Signal Bus2IP_Clk    : STD_LOGIC;
	Signal Bus2IP_Resetn : STD_LOGIC;
	Signal Bus2IP_Addr   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	Signal Bus2IP_RNW    : STD_LOGIC;
	Signal Bus2IP_CS     :  STD_LOGIC_VECTOR(0 DOWNTO 0);
	Signal Bus2IP_BE     : STD_LOGIC_VECTOR(3 DOWNTO 0);
	Signal Bus2IP_RdCE   : STD_LOGIC_VECTOR(0 DOWNTO 0);
	Signal Bus2IP_WrCE   : STD_LOGIC_VECTOR(0 DOWNTO 0);
	Signal Bus2IP_Data   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	Signal IP2Bus_Data   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	Signal IP2Bus_WrAck  : STD_LOGIC;
	Signal IP2Bus_RdAck  : STD_LOGIC;
	Signal IP2Bus_Error  : STD_LOGIC;

begin

    -- calculator module instantiation --
	i_GPIO_LOGIC : entity work.GPIO_LOGIC
		port map(
		    -- IPIF interface --
			Bus2IP_Clk_IN     => Bus2IP_Clk,
			Bus2IP_Resetn_IN  => Bus2IP_Resetn,
			Bus2IP_Addr_IN    => Bus2IP_Addr,
			Bus2IP_RNW_IN     => Bus2IP_RNW,
			Bus2IP_BE_IN      => Bus2IP_BE,
			Bus2IP_CS_IN      => Bus2IP_CS,
			Bus2IP_RdCE_IN    => Bus2IP_RdCE,
			Bus2IP_WrCE_IN    => Bus2IP_WrCE,
			Bus2IP_Data_IN    => Bus2IP_Data,
			IP2Bus_Data_OUT   => IP2Bus_Data,
			IP2Bus_WrAck_OUT  => IP2Bus_WrAck,
			IP2Bus_RdAck_OUT  => IP2Bus_RdAck,
			IP2Bus_Error_OUT  => IP2Bus_Error,
			--Used to read the inputs--
			Switches_IN => Switches_IN,
			--Used to output the result--
			Leds_OUT  => Leds_OUT,
			            clk      => S_AXI_ACLK,
						HSync    => HSync,
                        VSync   => VSync,  
                        VGARed  => VGARed,
                        VGAGreen    => VGAGreen,
                        VGABlue     => VGABlue
		);

    -- IPFI module instantiation --
    -- Tranlates the AXI interface to the IPIF interface, allowing easy communication between the PS and PL. --
	i_IPFI : entity axi_lite_ipif_v2_0.axi_lite_ipif
	   -- generic paramters defined above --
	    generic map (
	       C_S_AXI_MIN_SIZE       => C_S_AXI_MIN_SIZE,
	       C_ARD_ADDR_RANGE_ARRAY => C_ARD_ADDR_RANGE_ARRAY,
	       C_ARD_NUM_CE_ARRAY     => C_ARD_NUM_CE_ARRAY,
	       C_FAMILY               => C_FAMILY
	    )
		PORT MAP(
		    -- AXI interface --  
		    S_AXI_ACLK    => S_AXI_ACLK,
			S_AXI_ARESETN => S_AXI_ARESETN,
			S_AXI_AWADDR  => S_AXI_AWADDR,
			S_AXI_AWVALID => S_AXI_AWVALID,
			S_AXI_AWREADY => S_AXI_AWREADY,
			S_AXI_WDATA   => S_AXI_WDATA,
			S_AXI_WSTRB   => S_AXI_WSTRB,
			S_AXI_WVALID  => S_AXI_WVALID,
			S_AXI_WREADY  => S_AXI_WREADY,
			S_AXI_BRESP   => S_AXI_BRESP,
			S_AXI_BVALID  => S_AXI_BVALID,
			S_AXI_BREADY  => S_AXI_BREADY,
			S_AXI_ARADDR  => S_AXI_ARADDR,
			S_AXI_ARVALID => S_AXI_ARVALID,
			S_AXI_ARREADY => S_AXI_ARREADY,
			S_AXI_RDATA   => S_AXI_RDATA,
			S_AXI_RRESP   => S_AXI_RRESP,
			S_AXI_RVALID  => S_AXI_RVALID,
			S_AXI_RREADY  => S_AXI_RREADY,
			
			-- IPIF inteface --
			Bus2IP_Clk    => Bus2IP_Clk,
			Bus2IP_Resetn => Bus2IP_Resetn,
			Bus2IP_Addr   => Bus2IP_Addr,
			Bus2IP_RNW    => Bus2IP_RNW,
			Bus2IP_BE     => Bus2IP_BE,
			Bus2IP_CS     => Bus2IP_CS,
			Bus2IP_RdCE   => Bus2IP_RdCE,
			Bus2IP_WrCE   => Bus2IP_WrCE,
			Bus2IP_Data   => Bus2IP_Data,
			IP2Bus_Data   => IP2Bus_Data,
			IP2Bus_WrAck  => IP2Bus_WrAck,
			IP2Bus_RdAck  => IP2Bus_RdAck,
			IP2Bus_Error  => IP2Bus_Error
		);

end RTL;
