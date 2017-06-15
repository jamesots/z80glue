library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity clk_div_test is
end clk_div_test;
 
architecture behavior of clk_div_test is
 
    -- Component Declaration for the Unit Under Test (UUT)
 
   component clk_div is
       port ( clk_in  : in  std_logic;
              clk_out  : out std_logic);
   end component;

   --Inputs
   signal clk16 : std_logic := '0';

    --Outputs
   signal clk4 : std_logic;

   -- Clock period definitions
   constant clk16_period : time := 10 ns;
begin
 
   -- Instantiate the Unit Under Test (UUT)
   uut: clk_div port map (clk16, clk4);

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
      wait;
   end process;

end;
