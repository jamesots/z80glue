library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity waiter is
    port ( clk    :  in std_logic;
           start  :  in std_logic;
           wait_n : out std_logic);
end waiter;

architecture behavioral of waiter is
   signal prev_start : std_logic;
   signal prev_wait : std_logic;
begin
   process(clk) is
   begin
      if clk'event and clk = '1' then
         prev_start <= start;
         if start = '1' and prev_start = '0' then
            prev_wait <= '0';
         else
            prev_wait <= '1';
         end if;
         wait_n <= prev_wait;
      end if;
   end process;
end behavioral;

