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
   component clk_div is
       generic (count : integer);
       port ( clk_in  : in  std_logic;
              clk_out : out std_logic);
   end component;
   
   signal latched_data : std_logic_vector (7 downto 0);
   signal go : std_logic;
   signal stop : std_logic;   

   signal data : std_logic_vector (7 downto 0);
   signal count : integer range 0 to 9 := 0;
   signal busy_i : std_logic;
   signal clk_slow : std_logic;

begin
   -- 5 should be 125KHz
   c_sd_clk_div: clk_div generic map (5) port map (clk, clk_slow);

   process (clk, reset) is
   begin
      if reset = '1' then
         go <= '0';
      elsif clk'event and clk = '1' then
         if e = '1' then
            go <= '1';
            latched_data <= d_in;
         elsif stop = '1' then
            go <= '0';
         end if;
      end if;
   end process;
   
   process (clk_slow, reset) is
   begin
      if reset = '1' then
         busy_i <= '0';
         count <= 0;
         data <= "00000000";
         mosi <= '1';
         stop <= '0';
         d_out <= "00000000";
      elsif clk_slow'event and clk_slow = '1' then
         if go = '1' then
            if count = 0 then
               busy_i <= '0';
               data <= latched_data;
               stop <= '0';
               mosi <= '1';
            else 
               if count < 8 then
                  stop <= '0';
                  busy_i <= '1';
               elsif count = 8 then
                  stop <= '1';
                  busy_i <= '1';
               else 
                  stop <= '0';
                  busy_i <= '0';
               end if;
               mosi <= data(7);
               data <= data(6 downto 0) & miso;
            end if;
            count <= count + 1;
         else
            d_out <= data;
            busy_i <= '0';
            mosi <= '1';
            stop <= '0';
            count <= 0;
         end if;
      end if;
   end process;
   
   
   mclk <= busy_i and not clk_slow;
   busy <= busy_i;
end behavioral;
