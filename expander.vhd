library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity expander is
   port ( reset    : in  std_logic;
          clk      : in  std_logic;
          data     : in  std_logic_vector(7 downto 0);
          wr       : in  std_logic;
          spi_e    : out std_logic;
          spi_data : out std_logic_vector(7 downto 0);
          spi_busy : in  std_logic;
          busy     : out std_logic);
end expander;

architecture behavioral of expander is
   signal busy_i : std_logic;
   signal data_i : std_logic_vector(4 downto 0);
   signal count : integer range 0 to 8 := 0;
begin
-- clocked process
-- when wr goes high, latch the data, set busy high
-- put first byte on spi_data, set spi_e
-- wait for spi_busy to be low
-- put second byte on spi_data, set spi_e
-- wait for spi_busy to be low
-- set busy to low
   process (clk, reset) is
   begin
      if reset = '1' then
         busy_i <= '0';
         count <= 0;
      elsif clk'event and clk = '1' then
         if busy_i = '0' then
            if wr = '1' then
               data_i <= data(4 downto 0);
               spi_data <= data(7) & data(6) & data(6) & data(5) & data(5) & data(4) & data(4) & data(3);
               spi_e <= '1';
               busy_i <= '1';
               count <= 1;
            else
               spi_data <= data;
            end if;
         else
            if count = 1 and spi_busy = '0' then
               spi_data <= data_i(3) & data_i(2) & data_i(2) & data_i(1) & data_i(1) & data_i(0) & data_i(0) & data_i(1);
               spi_e <= '1';
               count <= 2;
            elsif count = 2 and spi_busy = '0' then
               busy_i <= '0';
               count <= 0;
            end if;
         end if;
      end if;
   end process;
   
   busy <= busy_i;
end behavioral;

