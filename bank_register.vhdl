library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity bank_register is
    port ( d     : in  std_logic_vector(7 downto 0);
           clk   : in  std_logic;
           b     : out std_logic_vector(7 downto 0);
           reset : in  std_logic);
end bank_register;

architecture behavioral of bank_register is
   signal data : std_logic_vector(7 downto 0) := "11000000";
begin
   process (clk, reset) is
   begin
      if reset = '1' then
         data <= "11000000";
      else
         if clk'event and clk = '1' then
            data <= d;
         end if;
      end if;
   end process;
   
   b <= data;
end behavioral;

