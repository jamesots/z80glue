library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity clk_div is
    generic (count : integer);
    port ( clk_in   : in  std_logic;
           clk_out  : out std_logic);
end clk_div;

architecture behavioral of clk_div is
   signal clk_count : unsigned(0 to count - 1) := (others => '0');
begin
   process (clk_in) is
   begin
      if rising_edge(clk_in) then
         clk_count <= clk_count + 1;
      end if;
   end process;
   
   clk_out <= clk_count(0);
end behavioral;

