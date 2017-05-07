library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity bank_multiplex is
   port ( sel   : in  std_logic_vector(1 downto 0);
          bank0 : in  std_logic_vector(7 downto 0);
          bank1 : in  std_logic_vector(7 downto 0);
          bank2 : in  std_logic_vector(7 downto 0);
          bank3 : in  std_logic_vector(7 downto 0);
          banks : out std_logic_vector(7 downto 0));
end bank_multiplex;

architecture behavioral of bank_multiplex is

begin
   process(sel, bank0, bank1, bank2, bank3) is
   begin
      case sel is
         when "00" =>
            banks <= bank0;
         when "01" =>
            banks <= bank1;
         when "10" =>
            banks <= bank2;
         when "11" =>
            banks <= bank3;
         when others =>
            banks <= bank0;
      end case;
   end process;
end behavioral;

