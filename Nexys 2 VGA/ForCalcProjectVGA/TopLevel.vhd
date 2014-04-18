library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.Monitor.ALL;

entity VGA is
	port (--UserReset : in STD_LOGIC;  -- Button0
		   clk : in STD_LOGIC;
		   HSync     : out STD_LOGIC;
		   VSync     : out STD_LOGIC;
		   VGARed    : out STD_LOGIC_VECTOR(3 downto 0);
		   VGAGreen  : out STD_LOGIC_VECTOR(3 downto 0);
		   VGABlue   : out STD_LOGIC_VECTOR(3 downto 0);
		   sw		 : in std_logic_vector(7 downto 0);
		   ASCII_in  : in std_logic_vector(7 downto 0));
end VGA;

architecture Behavioral of VGA is

	constant ADDRESSLENGTH : natural := BitsNecessary(TOTALCHARS - 1);
	constant PIXELXLENGTH  : natural := BitsNecessary(HP);
	constant PIXELYLENGTH  : natural := BitsNecessary(VP);

	signal Clock50In 			: STD_LOGIC;
	signal ClockVGA         : STD_LOGIC;
	signal Locked           : STD_LOGIC;
	signal Reset            : STD_LOGIC;
	signal PixelX           : STD_LOGIC_VECTOR(PIXELXLENGTH - 1 downto 0);
	signal PixelY           : STD_LOGIC_VECTOR(PIXELYLENGTH -1 downto 0);
	signal VideoONBadTiming : STD_LOGIC;
	signal HSyncBadTiming   : STD_LOGIC;
	signal VSyncBadTiming   : STD_LOGIC;
	signal WriteAddress     : STD_LOGIC_VECTOR(ADDRESSLENGTH - 1 downto 0);
	signal ReadAddress      : STD_LOGIC_VECTOR(ADDRESSLENGTH - 1 downto 0);
	signal SymbolPos        : STD_LOGIC_VECTOR(7 downto 0);
	signal ROMData          : STD_LOGIC_VECTOR(0 to 7);
	signal LineAddress      : STD_LOGIC_VECTOR(3 downto 0);
	signal TileRed          : STD_LOGIC;
	signal TileGreen        : STD_LOGIC;
	signal TileBlue         : STD_LOGIC;
	signal ASCII            : STD_LOGIC_VECTOR(7 downto 0);
	
	signal RAMData          : STD_LOGIC_VECTOR(0 to 7);
	signal RAMWriteAddress 	: STD_LOGIC_VECTOR(ADDRESSLENGTH - 1 downto 0);
	signal RAMWriteEnable 	: STD_LOGIC;

begin

divider:	entity work.clock_divider
port map		( 	clk, '0',Clock50In);

	Reset <= '0';
	ClockVGA <= Clock50In;

	VGA_Synchronization: entity work.VGASync
		generic map (	PixelXBits => PIXELXLENGTH,
							PixelYBits => PIXELYLENGTH)
		port map (	Reset   => Reset,
						Clock   => ClockVGA,
						PixelX  => PixelX,
						PixelY  => PixelY,
						HSync   => HSync,
						VSync   => VSync);
				  
---------- APPLICATION-SPECIFIC BLOCK  B e g i n
---------- output to VGA RAM 				  
	Arithmetic: entity work.ArithmeticBlock
	 generic map (AddressBits => ADDRESSLENGTH,
						StateMaxValue => 58,
						NumberOfColumns => 100 )
    port map ( 	        ASCII_in 	=> ASCII_in,
						ASCII_out 	=> RAMData,
						Address_out => RAMWriteAddress,
						clk 			=> ClockVGA,
						rst 			=> Reset,
						sw				=> sw);
						
	
-------- APPLICATION-SPECIFIC BLOCK  E n d				  

	VGA_RAM: entity work.RAM
		generic map (	AddressBits => ADDRESSLENGTH,
							DataBits    => 8)
		port map (	Clock        => ClockVGA,
						WriteAddress => RAMWriteAddress,
						WriteEnable  => '1',
						DataIn       => RAMData,
						ReadAddress  => ReadAddress,
						DataOut      => SymbolPos);

	Symbol_ROM: entity work.SymbolROM
		port map (	SymbolPos   => SymbolPos,
						LineAddress => LineAddress,
						Data        => ROMData);

	VGA_Tile_Matrix: entity work.VGATileMatrix
		generic map (PixelXBits => PIXELXLENGTH,
					 PixelYBits => PIXELYLENGTH,
					 AddressBits => ADDRESSLENGTH)
		port map (	Reset       => Reset,
						Clock       => ClockVGA,
						PixelX      => PixelX,
						PixelY      => PixelY,
						ROMData     => ROMData,
						LineAddress => LineAddress,
						ReadAddress => ReadAddress,
						TileRed     => TileRed,
						TileGreen   => TileGreen,
						TileBlue    => TileBlue);

	RGB_Multiplexer: entity work.RGBMux
		generic map (RedBits   => VGARed'length,
					 GreenBits => VGAGreen'length,
					 BlueBits  => VGABlue'length)
		port map (	TileRed       => TileRed,
						TileGreen     => TileGreen,
						TileBlue      => TileBlue,
						RedOut        => VGARed,
						GreenOut      => VGAGreen,
						BlueOut       => VGABlue);
end Behavioral;
