library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity clk_div is
    port ( clk16 : in  std_logic;
           clk4  : out std_logic);
end clk_div;

architecture behavioral of clk_div is
   signal clk_count : unsigned(0 to 18) := "0000000000000000000";
begin
   clkdiv: process (clk16) is
   begin
      if rising_edge(clk16) then
         clk_count <= clk_count + 1;
      end if;
   end process;
   
   clk4 <= clk_count(0);
end behavioral;

