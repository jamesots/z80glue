library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity bank_register_test is
end bank_register_test;
 
architecture behavior of bank_register_test is
 
    -- Component Declaration for the Unit Under Test (UUT)
   component bank_register is
       port ( d     : in  std_logic_vector(7 downto 0);
              clk   : in  std_logic;
              oe    : in  std_logic;
              b     : out std_logic_vector(7 downto 0);
              reset : in  std_logic);
   end component;

   --Inputs
   signal d : std_logic_vector(7 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal oe : std_logic := '0';
   signal reset : std_logic := '0';

    --Outputs
   signal b : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
begin
 
   -- Instantiate the Unit Under Test (UUT)
   uut: bank_register port map (
          d => d,
          clk => clk,
          oe => oe,
          b => b,
          reset => reset
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
      reset <= '1';
      oe <= '1';

      wait for clk_period;      
      d <= "10101010";
      
      wait for clk_period;
      oe <= '0';
      
      wait for clk_period;
      reset <= '0';
      
      wait for clk_period;

      wait;
   end process;

end;