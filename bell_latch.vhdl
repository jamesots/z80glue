library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity bell_latch is
   port ( wr     : in   std_logic;
          state  : in   std_logic;
          reset  : in   std_logic;
          bells  : out  std_logic);
end bell_latch;

architecture behavioral of bell_latch is
   signal bell_i : std_logic := '0';
begin
   process (wr, reset) is
   begin
      if reset = '1' then
         bell_i <= '0';
      elsif wr = '1' then
         bell_i <= state;
      end if;
   end process;
   bells <= bell_i;
end behavioral;

