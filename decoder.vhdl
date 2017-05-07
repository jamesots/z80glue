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
		d <= "00000000";
		if oe = '0' then
			case i is
				when "000" =>
					d(0) <= '1';
				when "001" =>
					d(1) <= '1';
				when "010" =>
					d(2) <= '1';
				when "011" =>
					d(3) <= '1';
				when "100" =>
					d(4) <= '1';
				when "101" =>
					d(5) <= '1';
				when "110" =>
					d(6) <= '1';
				when "111" =>
					d(7) <= '1';
				when others =>
					d <= "00000000";
			end case;
		end if;
   end process;
end behavioral;

