library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity z80glue is
    port ( clk16 : in    std_logic;
		     clk4  : out   std_logic;
			  led_r : out   std_logic;
			  led_g : out   std_logic;
			  led_y : out   std_logic;
			  a     : in    std_logic_vector(15 downto 0);
			  d     : inout std_logic_vector(7 downto 0);
			  int	  : out   std_logic;
			  nmi   : out   std_logic;
			  halt  : in    std_logic;
			  mreq  : in    std_logic;
			  iorq  : in    std_logic;
			  rfsh  : in    std_logic;
			  m1    : in    std_logic;
			  reset : out   std_logic;
			  busrq : out   std_logic;
			  waitx : out   std_logic;
			  busack : in   std_logic;
			  wr    : in    std_logic;
			  rd    : in    std_logic;
			  ftdi_txe : in std_logic;
			  ftdi_rxf : in std_logic;
			  ftdi_wr : out std_logic;
			  ftdi_rd : out std_logic);
end z80glue;

architecture behavioral of z80glue is
	component clk_div is
		 port ( clk16 : in  std_logic;
				  clk4  : out std_logic);
	end component;
	signal wait_sig : std_logic;
begin
	clk_div_i: clk_div port map (clk16, clk4);
	
	ftdi: process (rd, mreq) is
	begin
		if (rd = '0' and mreq = '0') then
			ftdi_rd <= '0';
			if ftdi_rxf = '1' then
				wait_sig <= '0';
			else
				wait_sig <= '1';
			end if;
		else
			ftdi_rd <= '1';
			wait_sig <= '1';
		end if;
	end process;
	
	led_g <= wait_sig;
	led_y <= a(1);
	led_r <= a(0);
	waitx <= wait_sig;
end behavioral;

