library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity bank_register is
    port ( d   : in  std_logic_vector(7 downto 0);
           clk : in  std_logic;
           oe  : in  std_logic;
           b   : out std_logic_vector(7 downto 0));
end bank_register;

architecture behavioral of bank_register is
   signal data : std_logic_vector(7 downto 0);
begin
   process (clk, d) is
   begin
      if clk'event and clk = '1' then
         data <= d;
      end if;
   end process;
   
   b <= data when oe = '1';
   b <= "ZZZZZZZZ" when oe = '0';
end behavioral;

