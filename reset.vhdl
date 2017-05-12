library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity reset is
   port ( clk         : in   std_logic;
          reset_in_n  : in   std_logic;
          reset_out_n : out  std_logic);
end reset;

architecture behavioral of reset is
   signal reset_count : unsigned(0 to 2) := "000";
begin
   process (clk, reset_in_n) is
   begin
      if clk'event and clk = '1' then
         if reset_in_n = '0' then
            reset_count <= "000";
            reset_out_n <= '0';
         elsif reset_count /= "100" then
            reset_count <= reset_count + 1;
            reset_out_n <= '0';
         else
            reset_out_n <= '1';
         end if;
      end if;
   end process;
end behavioral;

