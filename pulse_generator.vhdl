library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity pulse_generator is
    generic (count : integer);
    port ( clk_in   : in  std_logic;
           pulse    : out std_logic;
           reset    : in  std_logic);
end pulse_generator;

architecture behavioral of pulse_generator is
   -- should this be a variable?
   signal clk_count : unsigned(0 to count) := (others => '0');
begin
   clkdiv: process (clk_in) is
   begin
      if reset = '1' then
         clk_count <= "0" & (others => '0');
         pulse <= '0';
      elsif rising_edge(clk_in) then
         clk_count <= clk_count + 1;
         if clk_count(0) = '1' then
            pulse <= '1';
         else
            pulse <= '0';
         end if;
      end if;
   end process;
end behavioral;

