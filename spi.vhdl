library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity spi is
   port ( clk   : in   std_logic;
          reset : in   std_logic;
          d_in  : in   std_logic_vector (7 downto 0);
          d_out : out  std_logic_vector (7 downto 0);
          e     : in   std_logic;
          busy  : out  std_logic;
          mosi  : out  std_logic;
          miso  : in   std_logic;
          mclk  : out  std_logic);
end spi;

architecture behavioral of spi is
   signal data : std_logic_vector (7 downto 0);
   signal count : integer range 0 to 7 := 7;
   signal busy_i : std_logic;
begin
   process (clk, reset) is
   begin
      if reset = '1' then
         busy_i <= '0';
         count <= 7;
         data <= "00000000";
         mosi <= '1';
      elsif clk'event and clk = '1' then
         if e = '1' then
            mosi <= d_in(7);
            data <= d_in(6 downto 0) & miso;
            busy_i <= '1';
            count <= 0;
         elsif count < 7 then
            mosi <= data(7);
            data <= data(6 downto 0) & miso;
            count <= count + 1;
            busy_i <= '1';
         else
            d_out <= data;
            busy_i <= '0';
            mosi <= '1';
         end if;
      end if;
   end process;
   
   mclk <= busy_i and not clk;
   busy <= busy_i;
end behavioral;
