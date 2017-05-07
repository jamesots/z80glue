library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity decoder_test is
end decoder_test;
 
architecture behavior of decoder_test is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	component decoder is
		 port ( i   : in  std_logic_vector(2 downto 0);
				  oe  : in  std_logic;
				  d   : out std_logic_vector(7 downto 0));
   end component;
    
   --Inputs
   signal i : std_logic_vector(2 downto 0) := (others => '0');
   signal oe : std_logic := '0';

 	--Outputs
   signal d : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
   
   signal clock : std_logic;
 
   constant clock_period : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decoder port map (
          i => i,
          oe => oe,
          d => d
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      oe <= '0';
      i <= "000";
      wait for clock_period;

      oe <= '0';
      i <= "001";
      wait for clock_period;

      oe <= '0';
      i <= "010";
      wait for clock_period;

      oe <= '0';
      i <= "011";
      wait for clock_period;

      oe <= '1';
      i <= "011";
      wait for clock_period;

      -- insert stimulus here 

      wait;
   end process;

END;
