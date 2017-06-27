library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity spi_test is
end spi_test;
 
architecture behavior of spi_test is
 
    -- Component Declaration for the Unit Under Test (UUT)
 
   component spi is
      port ( clk   : in   std_logic;
             reset : in   std_logic;
             d_in  : in   std_logic_vector (7 downto 0);
             d_out : out  std_logic_vector (7 downto 0);
             e     : in   std_logic;
             busy  : out  std_logic;
             mosi  : out  std_logic;
             miso  : in   std_logic;
             mclk  : out  std_logic;
             fast  : in   std_logic);
   end component;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal d_in : std_logic_vector(7 downto 0) := (others => '0');
   signal e : std_logic := '0';
   signal miso : std_logic := '0';
   signal fast : std_logic := '0';

 	--Outputs
   signal d_out : std_logic_vector(7 downto 0);
   signal busy : std_logic;
   signal mosi : std_logic;
   signal mclk : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi port map(
          clk => clk,
          reset => reset,
          d_in => d_in,
          d_out => d_out,
          e => e,
          busy => busy,
          mosi => mosi,
          miso => miso,
          mclk => mclk,
          fast => fast
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      fast <= '0';
      wait for clk_period / 2;
      reset <= '1';
      wait for clk_period;
      reset <= '0';
      
      wait for clk_period * 5;
      
      e <= '1';
      d_in <= "10110001";
      miso <= '1';
      wait for clk_period * 5;
      e <= '0';
      
      wait for clk_period * 240;
      miso <= '0';
      
      wait for clk_period * 373;

      e <= '1';
      d_in <= "01100110";
      miso <= '0';
      wait for clk_period * 2;
      e <= '0';

      wait;
   end process;

END;
