library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity decoder is
    port ( i   : in  std_logic_vector(2 downto 0);
           oe  : in  std_logic;
           d   : out std_logic_vector(7 downto 0));
end decoder;

architecture behavioral of decoder is
begin
   process (i, oe) is
   begin
		d <= "11111111";
		if oe = '0' then
			case i is
				when "000" =>
					d(0) <= '0';
				when "001" =>
					d(1) <= '0';
				when "010" =>
					d(2) <= '0';
				when "011" =>
					d(3) <= '0';
				when "100" =>
					d(4) <= '0';
				when "101" =>
					d(5) <= '0';
				when "110" =>
					d(6) <= '0';
				when "111" =>
					d(7) <= '0';
				when others =>
					d <= "11111111";
			end case;
		end if;
   end process;
end behavioral;

