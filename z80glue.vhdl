library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity z80glue is
    port ( clk16 : in    std_logic;
		     clk4  : out   std_logic;
			  led_r : out   std_logic;
			  led_g : out   std_logic;
			  led_y : out   std_logic;
			  a     : in    std_logic_vector(15 downto 0);
			  d     : inout std_logic_vector(7 downto 0);
			  b     : out   std_logic_vector(18 downto 14);
			  int	  : out   std_logic;
			  nmi   : out   std_logic;
			  halt  : in    std_logic;
			  mreq  : in    std_logic;
			  iorq  : in    std_logic;
			  rfsh  : in    std_logic;
			  m1    : in    std_logic;
			  reset : in    std_logic;
			  busrq : out   std_logic;
			  waitx : out   std_logic;
			  busack : in   std_logic;
			  wr    : in    std_logic;
			  rd    : in    std_logic;
			  ftdi_txe : in std_logic;
			  ftdi_rxf : in std_logic;
			  ftdi_wr : out std_logic;
			  ftdi_rd : out std_logic;
			  ram_we : out  std_logic;
			  ram_oe : out  std_logic;
			  ram_ce : out  std_logic);
end z80glue;

architecture behavioral of z80glue is
	component clk_div is
		 port ( clk16 : in  std_logic;
				  clk4  : out std_logic);
	end component;
	signal wait_sig : std_logic;
	
	signal bank0 : std_logic_vector(7 downto 0);
	signal bank1 : std_logic_vector(7 downto 0);
	signal bank2 : std_logic_vector(7 downto 0);
	signal bank3 : std_logic_vector(7 downto 0);
	
	signal bank_sig : std_logic_vector(7 downto 0);
	
	signal sel : std_logic_vector(7 downto 0);
	
	type selection is
		(sel_bank0, sel_bank1, sel_bank2, sel_bank3,
		 sel_screen_rd, sel_screen_wr, sel_bell, sel_ftdi_status);		 
begin
	clk_div_i: clk_div port map (clk16, clk4);
	
	io_select: process (a, iorq) is
	begin
		if iorq = '0' then
			case a(7 downto 0) is
				when "00000000" =>
					sel <= "00000001";
				when "00000001" =>
					sel <= "00000010";
				when "00000010" =>
					sel <= "00000100";
				when "00000011" =>
					sel <= "00001000";
				when "00000100" =>
					sel <= "00010000";
				when "00000101" =>
					sel <= "00100000";
				when "00000110" =>
					sel <= "01000000";
				when "00000111" =>
					sel <= "10000000";
				when others =>
					sel <= "00000000";
			end case;
		else
			sel <= "00000000";
		end if;
	end process;
	
	bank_regs: process (sel, a(14), a(15), reset, d, wr) is
	begin
		if reset = '0' then
			bank0 <= "00000000";
			bank1 <= "00000000";
			bank2 <= "00000000";
			bank3 <= "00000000";
		else 
			if wr = '0' then
				if sel(selection'pos(sel_bank0)) = '1' then
					bank0 <= d;
				elsif sel(selection'pos(sel_bank1)) = '1' then
					bank1 <= d;
				elsif sel(selection'pos(sel_bank2)) = '1' then
					bank2 <= d;
				elsif sel(selection'pos(sel_bank3)) = '1' then
					bank3 <= d;
				end if;
			end if;
		end if;
		
		case a(15 downto 14) is
			when "00" =>
				bank_sig <= bank0;
			when "01" =>
				bank_sig <= bank1;
			when "10" =>
				bank_sig <= bank2;
			when "11" =>
				bank_sig <= bank2;
			when others =>
		end case;
	end process;
	
	ftdi: process (rd, mreq) is
	begin
		if (rd = '0' and mreq = '0') then
			ftdi_rd <= '0';
			if ftdi_rxf = '1' then
				wait_sig <= '0';
			else
				wait_sig <= '1';
			end if;
		else
			ftdi_rd <= '1';
			wait_sig <= '1';
		end if;
	end process;
	
	led_g <= wait_sig;
	led_y <= a(1);
	led_r <= a(0);
	waitx <= wait_sig;
	b <= bank_sig(4 downto 0);
end behavioral;

