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
           b     : out   std_logic_vector(18 downto 14);
           int     : out   std_logic;
           nmi   : out   std_logic;
           halt  : in    std_logic;
           mreq  : in    std_logic;
           iorq  : in    std_logic;
           rfsh  : in    std_logic;
           m1    : in    std_logic;
           reset : in    std_logic;
           busrq : out   std_logic;
           waitx : out   std_logic;
           busack : in   std_logic;
           wr    : in    std_logic;
           rd    : in    std_logic;
           ftdi_txe : in std_logic;
           ftdi_rxf : in std_logic;
           ftdi_wr : out std_logic;
           ftdi_rd : out std_logic;
           ram_we : out  std_logic;
           ram_oe : out  std_logic;
           ram_ce : out  std_logic);
end z80glue;

architecture behavioral of z80glue is
   component clk_div is
       port ( clk16 : in  std_logic;
              clk4  : out std_logic);
   end component;
   component bank_register is
       port ( d     : in  std_logic_vector(7 downto 0);
              clk   : in  std_logic;
              oe    : in  std_logic;
              b     : out std_logic_vector(7 downto 0);
              reset : in  std_logic);
   end component;
	component decoder is
		 port ( i   : in  std_logic_vector(2 downto 0);
				  oe  : in  std_logic;
				  d   : out std_logic_vector(7 downto 0));
	end component;

   signal wait_sig : std_logic;
   
   signal bank0 : std_logic_vector(7 downto 0);
   signal bank1 : std_logic_vector(7 downto 0);
   signal bank2 : std_logic_vector(7 downto 0);
   signal bank3 : std_logic_vector(7 downto 0);
   
   signal bank_sig : std_logic_vector(7 downto 0);
   signal bank_sig0 : std_logic_vector(7 downto 0);
   signal bank_sig1 : std_logic_vector(7 downto 0);
   signal bank_sig2 : std_logic_vector(7 downto 0);
   signal bank_sig3 : std_logic_vector(7 downto 0);
   
   signal sel : std_logic_vector(7 downto 0);
   signal sel_oe : std_logic;
	
   type selection is
      (sel_bank0, sel_bank1, sel_bank2, sel_bank3,
       sel_screen_rd, sel_screen_wr, sel_bell, sel_ftdi_status);       
       
   signal bank_0_oe: std_logic;
   signal bank_1_oe: std_logic;
   signal bank_2_oe: std_logic;
   signal bank_3_oe: std_logic;
begin
   clk_div_i: clk_div port map (clk16, clk4);
   
   bank_0: bank_register port map (d, sel(0), bank_0_oe, bank_sig0, reset);
   bank_1: bank_register port map (d, sel(1), bank_1_oe, bank_sig1, reset);
   bank_2: bank_register port map (d, sel(2), bank_2_oe, bank_sig2, reset);
   bank_3: bank_register port map (d, sel(3), bank_3_oe, bank_sig3, reset);
   bank_0_oe <= not(a(15)) or not(a(14));
   bank_1_oe <= not(a(15)) or a(14);
   bank_2_oe <= a(15) or not(a(14));
   bank_3_oe <= a(15) or a(14);

	decoder_i: decoder port map (a(2 downto 0), sel_oe, sel);
   sel_oe <= a(7) or a(6) or a(5) or a(4) or a(3);
      
   ftdi: process (rd, mreq, bank_sig) is
   begin
      if (bank_sig(7 downto 4) = "1100" and rd = '0' and mreq = '0') then
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
   bank_sig <= bank_sig3 or bank_sig2 or bank_sig1 or bank_sig0;
	b <= bank_sig(4 downto 0);
end behavioral;

