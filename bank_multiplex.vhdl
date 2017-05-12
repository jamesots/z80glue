library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity bank_multiplex is
   port ( clk   : in  std_logic;
          sel   : in  std_logic_vector(1 downto 0);
          bank0 : in  std_logic_vector(7 downto 0);
          bank1 : in  std_logic_vector(7 downto 0);
          bank2 : in  std_logic_vector(7 downto 0);
          bank3 : in  std_logic_vector(7 downto 0);
          banks : out std_logic_vector(7 downto 0));
end bank_multiplex;

architecture behavioral of bank_multiplex is
   signal bank_i: std_logic_vector(7 downto 0);
begin
   process(sel, bank0, bank1, bank2, bank3) is
   begin
      case sel is
         when "00" =>
            bank_i <= bank0;
         when "01" =>
            bank_i <= bank1;
         when "10" =>
            bank_i <= bank2;
         when "11" =>
            bank_i <= bank3;
         when others =>
            bank_i <= bank0;
      end case;
   end process;
   
   banks <= bank_i;
end behavioral;

