library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity bank_register is
    port ( d     : in  std_logic_vector(7 downto 0);
           clk   : in  std_logic;
           oe    : in  std_logic;
           b     : out std_logic_vector(7 downto 0);
			  reset : in  std_logic);
end bank_register;

architecture behavioral of bank_register is
   signal data : std_logic_vector(7 downto 0);
begin
   process (clk, d) is
   begin
		if reset = '0' then
         data <= "11000000";
		else
			if clk'event and clk = '1' then
				data <= d;
			end if;
		end if;
   end process;
   
   b <= data when oe = '0';
   b <= "ZZZZZZZZ" when oe = '1';
end behavioral;

