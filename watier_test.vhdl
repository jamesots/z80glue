library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity watier_test is
end watier_test;
 
architecture behavior of watier_test is
   component waiter is
       port ( clk    :  in std_logic;
              start  :  in std_logic;
              wait_n : out std_logic);
   end component;
    
   --Inputs
   signal clk : std_logic := '0';
   signal start : std_logic := '0';

 	--Outputs
   signal wait_n : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: waiter PORT MAP (
          clk => clk,
          start => start,
          wait_n => wait_n
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
      wait for clk_period*10.5;
      
      start <= '1';
      
      wait for clk_period;
      
      start <= '0';
      
      wait for clk_period * 5;
      
      start <= '1';
      
      wait for clk_period;
      
      start <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
