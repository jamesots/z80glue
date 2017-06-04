LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY z80glue_test IS
END z80glue_test;
 
ARCHITECTURE behavior OF z80glue_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT z80glue
    PORT(
         clk16 : IN  std_logic;
         clk4 : OUT  std_logic;
         led : OUT  std_logic_vector(7 downto 0);
         a : IN  std_logic_vector(15 downto 0);
         d : INOUT  std_logic_vector(7 downto 0);
         b : OUT  std_logic_vector(18 downto 14);
         int_n : OUT  std_logic;
         nmi_n : OUT  std_logic;
         halt_n : IN  std_logic;
         mreq_n : IN  std_logic;
         iorq_n : IN  std_logic;
         rfsh_n : IN  std_logic;
         m1_n : IN  std_logic;
         reset_in_n : IN  std_logic;
         reset_out_n : OUT  std_logic;
         busrq_n : OUT  std_logic;
         wait_n : OUT  std_logic;
         busack_n : IN  std_logic;
         wr_n : IN  std_logic;
         rd_n : IN  std_logic;
         ftdi_txe_n : IN  std_logic;
         ftdi_rxf_n : IN  std_logic;
         ftdi_wr_n : OUT  std_logic;
         ftdi_rd_n : OUT  std_logic;
         bell : OUT  std_logic;
         ram_we_n : OUT  std_logic;
         ram_oe_n : OUT  std_logic;
         ram_ce_n : OUT  std_logic;
         rom_we_n : OUT  std_logic;
         rom_oe_n : OUT  std_logic;
         rom_ce_n : OUT  std_logic;
         rtc_we_n : OUT  std_logic;
         rtc_oe_n : OUT  std_logic;
         rtc_ce_n : OUT  std_logic;
         scr_rs : OUT  std_logic;
         scr_rw : OUT  std_logic;
         scr_e_n : OUT  std_logic;
         sd_cd : IN  std_logic;
         sd_cs_n : OUT  std_logic;
         sd_di : OUT  std_logic;
         sd_do : IN  std_logic;
         sd_clk : OUT  std_logic;
         rom_boot_n : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk16 : std_logic := '0';
   signal a : std_logic_vector(15 downto 0) := (others => '0');
   signal halt_n : std_logic := '1';
   signal mreq_n : std_logic := '1';
   signal iorq_n : std_logic := '1';
   signal rfsh_n : std_logic := '1';
   signal m1_n : std_logic := '1';
   signal reset_in_n : std_logic := '1';
   signal busack_n : std_logic := '1';
   signal wr_n : std_logic := '1';
   signal rd_n : std_logic := '1';
   signal ftdi_txe_n : std_logic := '1';
   signal ftdi_rxf_n : std_logic := '1';
   signal sd_cd : std_logic := '0';
   signal sd_do : std_logic := '0';
   signal rom_boot_n : std_logic := '1';

	--BiDirs
   signal d : std_logic_vector(7 downto 0);

 	--Outputs
   signal clk4 : std_logic;
   signal led : std_logic_vector(7 downto 0);
   signal b : std_logic_vector(18 downto 14);
   signal int_n : std_logic;
   signal nmi_n : std_logic;
   signal reset_out_n : std_logic;
   signal busrq_n : std_logic;
   signal wait_n : std_logic;
   signal ftdi_wr_n : std_logic;
   signal ftdi_rd_n : std_logic;
   signal bell : std_logic;
   signal ram_we_n : std_logic;
   signal ram_oe_n : std_logic;
   signal ram_ce_n : std_logic;
   signal rom_we_n : std_logic;
   signal rom_oe_n : std_logic;
   signal rom_ce_n : std_logic;
   signal rtc_we_n : std_logic;
   signal rtc_oe_n : std_logic;
   signal rtc_ce_n : std_logic;
   signal scr_rs : std_logic;
   signal scr_rw : std_logic;
   signal scr_e_n : std_logic;
   signal sd_cs_n : std_logic;
   signal sd_di : std_logic;
   signal sd_clk : std_logic;

   -- Clock period definitions
   constant clk16_period : time := 10 ns;
   constant clk4_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: z80glue PORT MAP (
          clk16 => clk16,
          clk4 => clk4,
          led => led,
          a => a,
          d => d,
          b => b,
          int_n => int_n,
          nmi_n => nmi_n,
          halt_n => halt_n,
          mreq_n => mreq_n,
          iorq_n => iorq_n,
          rfsh_n => rfsh_n,
          m1_n => m1_n,
          reset_in_n => reset_in_n,
          reset_out_n => reset_out_n,
          busrq_n => busrq_n,
          wait_n => wait_n,
          busack_n => busack_n,
          wr_n => wr_n,
          rd_n => rd_n,
          ftdi_txe_n => ftdi_txe_n,
          ftdi_rxf_n => ftdi_rxf_n,
          ftdi_wr_n => ftdi_wr_n,
          ftdi_rd_n => ftdi_rd_n,
          bell => bell,
          ram_we_n => ram_we_n,
          ram_oe_n => ram_oe_n,
          ram_ce_n => ram_ce_n,
          rom_we_n => rom_we_n,
          rom_oe_n => rom_oe_n,
          rom_ce_n => rom_ce_n,
          rtc_we_n => rtc_we_n,
          rtc_oe_n => rtc_oe_n,
          rtc_ce_n => rtc_ce_n,
          scr_rs => scr_rs,
          scr_rw => scr_rw,
          scr_e_n => scr_e_n,
          sd_cd => sd_cd,
          sd_cs_n => sd_cs_n,
          sd_di => sd_di,
          sd_do => sd_do,
          sd_clk => sd_clk,
          rom_boot_n => rom_boot_n
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
      wait for 215 ns;	

      iorq_n <= '0';
      wr_n <= '0';
      a <= "0000000000000010";
      d <= "10000000";
      
      wait for clk4_period;
      
      iorq_n <= '1';
      wr_n <= '1';
      d <= "ZZZZZZZZ";
      
      wait for clk4_period;
      
      mreq_n <= '0';
      a <= "1000000000000000";
      rd_n <= '0';
      
      wait for clk4_period;
      
      mreq_n <= '1';
      rd_n <= '1';
      

      -- insert stimulus here 

      wait;
   end process;

END;
