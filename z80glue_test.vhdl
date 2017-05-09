library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity z80glue_test is
end z80glue_test;
 
architecture behavior of z80glue_test is
 
    -- Component Declaration for the Unit Under Test (UUT)
    
   component z80glue is
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
   end component;

    

   --Inputs
   signal clk16 : std_logic := '0';
   signal a : std_logic_vector(15 downto 0) := (others => '0');
   signal halt : std_logic := '0';
   signal mreq : std_logic := '0';
   signal iorq : std_logic := '0';
   signal rfsh : std_logic := '0';
   signal m1 : std_logic := '0';
   signal reset : std_logic := '0';
   signal busack : std_logic := '0';
   signal wr : std_logic := '0';
   signal rd : std_logic := '0';
   signal ftdi_txe : std_logic := '0';
   signal ftdi_rxf : std_logic := '0';

   --BiDirs
   signal d : std_logic_vector(7 downto 0);

   --Outputs
   signal clk4 : std_logic;
   signal led_r : std_logic;
   signal led_g : std_logic;
   signal led_y : std_logic;
   signal b : std_logic_vector(18 downto 14);
   signal int : std_logic;
   signal nmi : std_logic;
   signal busrq : std_logic;
   signal waitx : std_logic;
   signal ftdi_wr : std_logic;
   signal ftdi_rd : std_logic;
   signal ram_we : std_logic;
   signal ram_oe : std_logic;
   signal ram_ce : std_logic;

   -- Clock period definitions
   constant clk16_period : time := 10 ns;
 
begin
 
   -- Instantiate the Unit Under Test (UUT)
   uut: z80glue port map (
          clk16 => clk16,
          clk4 => clk4,
          led_r => led_r,
          led_g => led_g,
          led_y => led_y,
          a => a,
          d => d,
          b => b,
          int => int,
          nmi => nmi,
          halt => halt,
          mreq => mreq,
          iorq => iorq,
          rfsh => rfsh,
          m1 => m1,
          reset => reset,
          busrq => busrq,
          waitx => waitx,
          busack => busack,
          wr => wr,
          rd => rd,
          ftdi_txe => ftdi_txe,
          ftdi_rxf => ftdi_rxf,
          ftdi_wr => ftdi_wr,
          ftdi_rd => ftdi_rd,
          ram_we => ram_we,
          ram_oe => ram_oe,
          ram_ce => ram_ce
        );

   -- Clock process definitions
   clk16_process :process
   begin
      clk16 <= '0';
      wait for clk16_period/2;
      clk16 <= '1';
      wait for clk16_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin
      -- hold reset state for 100 ns.
      reset <= '0';
      wait for 100 ns;
      
      reset <= '1';

      wait for clk16_period*10;

      -- insert stimulus here 

      wait;
   end process;

end;
