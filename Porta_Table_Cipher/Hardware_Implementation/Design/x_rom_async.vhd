----------------------------------------------------------------------------------
-- ROM
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom_template is
   port(
      addr: in std_logic_vector(4 downto 0);
      data: out std_logic_vector(7 downto 0)
   );
end rom_template;

architecture arch of rom_template is
   constant ADDR_WIDTH: integer:=5;
   constant DATA_WIDTH: integer:=8;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
        
   -- ROM definition the secret key mister
   constant HEX2LED_ROM: rom_type:=(  -- mistermistermister
      x"6D",  -- addr 00: m
      x"69",  -- addr 01: i
      x"73",  -- addr 02: s
      x"74",  -- addr 03: t
      x"65",  -- addr 04: e
      x"72",  -- addr 05: r
      x"6D",  -- addr 06: m
      x"69",  -- addr 07: i
      x"73",  -- addr 08: s
      x"74",  -- addr 09: t
      x"65",  -- addr 10: e
      x"72",  -- addr 11: r
	   x"6D",  -- addr 12: m
      x"69",  -- addr 13: i
      x"73",  -- addr 14: s
      x"74",  -- addr 15: t
      x"65",  -- addr 16: e
      x"72",  -- addr 17: r
      x"FF",   -- addr 18: (void)
      x"FF",  -- addr 19: (void)
      x"FF",  -- addr 20: (void)
      x"FF",  -- addr 21: (void)
      x"FF",  -- addr 22: (void)
      x"FF",  -- addr 23: (void)
      x"FF",  -- addr 24: (void)
      x"FF",  -- addr 25: (void)
      x"FF",  -- addr 26: (void)
      x"FF",  -- addr 27: (void)
      x"FF",  -- addr 28: (void)
      x"FF",  -- addr 29: (void)
      x"FF",  -- addr 30: (void)
      x"FF"   -- addr 31: (void)
   );
begin
   data <= HEX2LED_ROM(to_integer(unsigned(addr)));
end arch;