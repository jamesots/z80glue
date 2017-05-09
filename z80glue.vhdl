library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity z80glue is
    port ( clk16      : in    std_logic;
           clk4       : out   std_logic;
           led_r      : out   std_logic;
           led_g      : out   std_logic;
           led_y      : out   std_logic;
           a          : in    std_logic_vector(15 downto 0);
           d          : inout std_logic_vector(7 downto 0);
           b          : out   std_logic_vector(18 downto 14);
           int_n      : out   std_logic;
           nmi_n      : out   std_logic;
           halt_n     : in    std_logic;
           mreq_n     : in    std_logic;
           iorq_n     : in    std_logic;
           rfsh_n     : in    std_logic;
           m1_n       : in    std_logic;
           reset_n    : in    std_logic;
           busrq_n    : out   std_logic;
           wait_n     : out   std_logic;
           busack_n   : in    std_logic;
           wr_n       : in    std_logic;
           rd_n       : in    std_logic;
           ftdi_txe_n : in    std_logic;
           ftdi_rxf_n : in    std_logic;
           ftdi_wr_n  : out   std_logic;
           ftdi_rd_n  : out   std_logic;
           ram_we_n   : out   std_logic;
           ram_oe_n   : out   std_logic;
           ram_ce_n   : out   std_logic);
end z80glue;

architecture behavioral of z80glue is
   component clk_div is
       port ( clk16 : in  std_logic;
              clk4  : out std_logic);
   end component;
   component bank_register is
       port ( d     : in  std_logic_vector(7 downto 0);
              clk   : in  std_logic;
              b     : out std_logic_vector(7 downto 0);
              reset : in  std_logic);
   end component;
      component decoder is
         port ( i   : in  std_logic_vector(2 downto 0);
                oe  : in  std_logic;
                d   : out std_logic_vector(7 downto 0));
   end component;
   component bank_multiplex is
      port ( clk   : in  std_logic;
             sel   : in  std_logic_vector(1 downto 0);
             bank0 : in  std_logic_vector(7 downto 0);
             bank1 : in  std_logic_vector(7 downto 0);
             bank2 : in  std_logic_vector(7 downto 0);
             bank3 : in  std_logic_vector(7 downto 0);
             banks : out std_logic_vector(7 downto 0));
   end component;

   signal wait_n_i : std_logic;
   
   signal bank0 : std_logic_vector(7 downto 0);
   signal bank1 : std_logic_vector(7 downto 0);
   signal bank2 : std_logic_vector(7 downto 0);
   signal bank3 : std_logic_vector(7 downto 0);
   
   signal bank_i : std_logic_vector(7 downto 0);
   
   signal sel    : std_logic_vector(7 downto 0);
   signal sel_oe : std_logic;
   
   signal mem_rd_n  : std_logic;
   signal ftdi_rd_i : std_logic;
   signal reset     : std_logic;

   type selection is
      (sel_bank0, sel_bank1, sel_bank2, sel_bank3,
       sel_screen_rd, sel_screen_wr, sel_bell, sel_ftdi_status);       
       
   signal ram_sel_n  : std_logic;
   signal rom_sel_n  : std_logic;
   signal ftdi_sel_n : std_logic;
   
   signal clk4_i : std_logic;
begin
   clk_div_i: clk_div port map (clk16, clk4_i);
   clk4 <= clk4_i;
   
   bank_multi: bank_multiplex port map (clk4_i, a(15 downto 14), bank0, bank1, bank2, bank3, bank_i);
   
   bank_0: bank_register port map (d, sel(0), bank0, reset);
   bank_1: bank_register port map (d, sel(1), bank1, reset);
   bank_2: bank_register port map (d, sel(2), bank2, reset);
   bank_3: bank_register port map (d, sel(3), bank3, reset);

   decoder_i: decoder port map (a(2 downto 0), sel_oe, sel);
   sel_oe <= not(a(7) or a(6) or a(5) or a(4) or a(3));
   
   reset <= not(reset_n);
   
   ftdi_sel_n <= not(bank_i(7)) or not(bank_i(6));    -- ftdi = 11xxxxxx
   ram_sel_n <= bank_i(7);                            -- ram  = 0xxxxxxx
   rom_sel_n <= not(bank_i(7)) or bank_i(6);          -- rom  = 10xxxxxx
   
   ftdi_rd_i <= mem_rd_n or ftdi_sel_n;
   wait_n_i <= ftdi_rd_i or not(ftdi_rxf_n);
   ftdi_rd_n <= ftdi_rd_i;
   mem_rd_n <= rd_n or mreq_n;
   
   ram_ce_n <= ram_sel_n;
   ram_we_n <= wr_n or mreq_n;
   ram_oe_n <= mem_rd_n;
   
   led_g <= wait_n_i;
   led_y <= a(1);
   led_r <= a(0);
   wait_n <= wait_n_i;
   b <= bank_i(4 downto 0);
   
   d <= "ZZZZZZZZ";
end behavioral;

