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
          mclk  : out  std_logic;
          fast  : in   std_logic);
end spi;

architecture behavioral of spi is
   signal latched_data : std_logic_vector (7 downto 0);
   signal go : std_logic;

   signal data : std_logic_vector (7 downto 0);
   signal count : integer range 0 to 9 := 0;
   signal busy_i : std_logic;
   signal clk_slow : std_logic;
   
   signal last_clk_count : std_logic;
   
   -- 4 will divide 10MHz down to 312.5KHz
   -- then clk_slow is divided down to 156.25KHz
   signal clk_count : unsigned(0 to 4) := (others => '0');
begin
   process (clk, reset) is
   begin
      if reset = '1' then
         go <= '0';
         busy_i <= '0';
         count <= 0;
         data <= "00000000";
         mosi <= '1';
         d_out <= "00000000";
         clk_slow <= '0';
         clk_count <= (others => '0');
         last_clk_count <= '1';
      elsif clk'event and clk = '1' then
         if e = '1' then
            go <= '1';
            latched_data <= d_in;
         end if;
         clk_count <= clk_count + 1;
         last_clk_count <= clk_count(0);
         if (clk_count(0) = '1' and last_clk_count = '0') or (fast = '1') then
            clk_slow <= not clk_slow;
            if clk_slow = '1' then
               if go = '1' then
                  if count = 0 then
                     busy_i <= '0';
                     data <= latched_data;
                     mosi <= '1';
                  else 
                     if count < 8 then
                        busy_i <= '1';
                     elsif count = 8 then
                        go <= '0';
                        busy_i <= '1';
                     else 
                        busy_i <= '0';
                     end if;
                     mosi <= data(7);
                  end if;
                  count <= count + 1;
               else
                  busy_i <= '0';
                  mosi <= '1';
                  count <= 0;
               end if;
            else
               if (count > 1) then
                  data <= data(6 downto 0) & miso;
                  d_out <= data(6 downto 0) & miso;
               end if;
            end if;
         end if;
      end if;
   end process;
   
   mclk <= busy_i and clk_slow;
   busy <= busy_i or go;
end behavioral;
