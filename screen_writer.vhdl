library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity screen_writer is
   port ( clk    : in   std_logic;
          sel    : in   std_logic;
          e_n    : out  std_logic;
          wait_n : out  std_logic);
end screen_writer;

architecture behavioral of screen_writer is
   signal count : integer range 0 to 7 := 0;
begin
   process (clk) is
   begin
      if clk'event and clk = '1' then
         if sel = '1' then
            if count < 2 then
               e_n <= '0';
               wait_n <= '0';
               count <= count + 1;
            elsif count < 3 then
               e_n <= '1';
               wait_n <= '0';
               count <= count + 1;
            elsif count < 6 then
               e_n <= '1';
               wait_n <= '0';
               count <= count + 1;
            else
               e_n <= '0';
               wait_n <= '1';
               -- Question - Do we need an extra wait after e goes low? I don't think so.
            end if;
         else
            e_n <= '0';
            wait_n <= '1';
            count <= 0;
         end if;
      end if;
   end process;
end behavioral;

