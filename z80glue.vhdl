library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity z80glue is
    port ( clk16      : in    std_logic;
           clk4       : out   std_logic;
           led        : out   std_logic_vector(7 downto 0);
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
           reset_in_n : in    std_logic;
           reset_out_n: out   std_logic;
           busrq_n    : out   std_logic;
           wait_n     : out   std_logic;
           busack_n   : in    std_logic;
           wr_n       : in    std_logic;
           rd_n       : in    std_logic;
           ftdi_txe_n : in    std_logic;
           ftdi_rxf_n : in    std_logic;
           ftdi_wr_n  : out   std_logic;
           ftdi_rd_n  : out   std_logic;
           bell       : out   std_logic;
           ram_we_n   : out   std_logic;
           ram_oe_n   : out   std_logic;
           ram_ce_n   : out   std_logic;
           rom_we_n   : out   std_logic;
           rom_oe_n   : out   std_logic;
           rom_ce_n   : out   std_logic;
           scr_rs     : out   std_logic;
           scr_rw     : out   std_logic;
           scr_e_n     : out   std_logic);
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
   component reset is
      port ( clk         : in   std_logic;
             reset_in_n  : in   std_logic;
             reset_out_n : out  std_logic);
   end component;
   component bell_latch is
      port ( wr    : in   std_logic;
             state : in   std_logic;
             reset : in   std_logic;
             bells : out  std_logic);
   end component;
   component screen_writer is
      port ( clk    : in   std_logic;
             sel    : in   std_logic;
             e_n    : out  std_logic;
             wait_n : out  std_logic);
   end component;

   signal wait_n_i : std_logic;
   
   signal bank0 : std_logic_vector(7 downto 0);
   signal bank1 : std_logic_vector(7 downto 0);
   signal bank2 : std_logic_vector(7 downto 0);
   signal bank3 : std_logic_vector(7 downto 0);
   
   signal bank0_wr : std_logic;
   signal bank1_wr : std_logic;
   signal bank2_wr : std_logic;
   signal bank3_wr : std_logic;
   
   signal bank_i : std_logic_vector(7 downto 0);
   
   signal sel    : std_logic_vector(7 downto 0);
   signal decoder_oe : std_logic;
   
   signal mem_rd_n  : std_logic;
   signal mem_wr_n  : std_logic;
   
   signal ftdi_rd_n_i : std_logic;
   signal ftdi_wr_n_i : std_logic;
   
   signal reset_i   : std_logic;
   signal long_reset_n_i : std_logic;

   type selection is
      (sel_bank0, sel_bank1, sel_bank2, sel_bank3,
       sel_screen_inst, sel_screen_data, sel_bell, sel_ftdi_status);       
       
   signal scr_sel    : std_logic;
   signal scr_wait_n : std_logic;
       
   signal ram_sel_n  : std_logic;
   signal rom_sel_n  : std_logic;
   signal ftdi_sel_n : std_logic;
   
   signal bell_sel : std_logic;
   
   signal clk4_i : std_logic;
begin
   clk_div_c: clk_div port map (clk16, clk4_i);
   clk4 <= clk4_i;

   -- the reset component makes sure the reset pulse is at least 3 clocks long
   c_reset: reset port map (clk4_i, reset_in_n, long_reset_n_i);
   reset_i <= not(long_reset_n_i);
   reset_out_n <= long_reset_n_i;
   
   -- decoder_oe enables the decoder output when an IO request is happening on 00000XXX.
   decoder_oe <= not(a(7) or a(6) or a(5) or a(4) or a(3) or iorq_n);
   c_decoder: decoder port map (a(2 downto 0), decoder_oe, sel);
   
   -- bankX_wr is high when trying to do an OUT to the bank's address
   bank0_wr <= sel(0) and not(wr_n);
   bank1_wr <= sel(1) and not(wr_n);
   bank2_wr <= sel(2) and not(wr_n);
   bank3_wr <= sel(3) and not(wr_n);
   
   bank_0: bank_register port map (d, bank0_wr, bank0, reset_i);
   bank_1: bank_register port map (d, bank1_wr, bank1, reset_i);
   bank_2: bank_register port map (d, bank2_wr, bank2, reset_i);
   bank_3: bank_register port map (d, bank3_wr, bank3, reset_i);

   -- bank_i should be set at all times, depending on what is on a14 and 15
   c_bank_multiplex: bank_multiplex port map (clk4_i, a(15 downto 14), bank0, bank1, bank2, bank3, bank_i);
   
   bell_sel <= not(wr_n) and sel(6);
   c_bell_latch: bell_latch port map (bell_sel, d(0), reset_i, bell);
   
   scr_sel <= sel(4) or sel(5);
   c_screen_writer: screen_writer port map (clk4_i, scr_sel, scr_e_n, scr_wait_n);
   scr_rs <= a(0);
   scr_rw <= wr_n;

   ftdi_sel_n <= not(bank_i(7)) or not(bank_i(6)) or mreq_n;     -- ftdi = 11xxxxxx
   ram_sel_n <= bank_i(7) or mreq_n;                             -- ram  = 0xxxxxxx
   rom_sel_n <= not(bank_i(7)) or bank_i(6) or mreq_n;           -- rom  = 10xxxxxx
--   ftdi_sel_n <= '0';
--   ram_sel_n <= '1';
--   rom_sel_n <= '1';
   
   mem_rd_n <= rd_n or mreq_n;
   mem_wr_n <= wr_n or mreq_n;
   
--   ftdi_wr_n_i <= mem_wr_n or ftdi_sel_n;
--   ftdi_wr_n <= ftdi_wr_n_i;
   ftdi_wr_n <= '1';

   -- try to read from the ftdi if we're doing a memory read and the ftdi is selected
   ftdi_rd_n_i <= mreq_n or rd_n or ftdi_sel_n;
   ftdi_rd_n <= ftdi_rd_n_i;

   -- ftdi_rxf_n is low when data is available
   -- need to wait if we're reading from the ftdi but data is not available
   wait_n_i <= (ftdi_rd_n_i or not(ftdi_rxf_n))
      or scr_wait_n;
--      or (ftdi_wr_n_i or not(ftdi_txe_n));


   -- enable the ram chip when ram is selected in the current bank
   ram_ce_n <= ram_sel_n;
   ram_we_n <= mem_wr_n;
   ram_oe_n <= mem_rd_n;
   
   rom_ce_n <= '1';
   rom_we_n <= '1';
   rom_oe_n <= '1';

   led(0) <= wait_n_i;
   led(1) <= a(1);
   led(2) <= a(0);
   led(3) <= ftdi_sel_n;
   led(4) <= ftdi_rxf_n;
   led(5) <= ftdi_rd_n_i;
   led(6) <= long_reset_n_i;
   led(7) <= clk4_i;
   
   wait_n <= wait_n_i;
   b <= bank_i(4 downto 0);
   
   -- don't control the data bus
   d <= "ZZZZZZZZ";
end behavioral;

