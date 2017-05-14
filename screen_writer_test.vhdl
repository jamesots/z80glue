library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity screen_writer_test is
end screen_writer_test;
 
architecture behavior of screen_writer_test is
 
    -- Component Declaration for the Unit Under Test (UUT)
 
   component screen_writer is
      port ( clk    : in   std_logic;
             sel    : in   std_logic;
             e_n    : out  std_logic;
             wait_n : out  std_logic);
   end component;
    

   --Inputs
   signal clk : std_logic := '0';
   signal sel : std_logic := '0';

 	--Outputs
   signal e_n : std_logic;
   signal wait_n : std_logic;

   -- Clock period definitions
   constant clk_period : time := 125 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: screen_writer port map (
          clk => clk,
          sel => sel,
          e_n => e_n,
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
      wait for clk_period;

      sel <= '1';
      
      wait for clk_period*10;
      
      sel <= '0';
      
      wait;
   end process;

END;
