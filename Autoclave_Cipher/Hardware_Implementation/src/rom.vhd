-- (adapted from) Listing 11.5
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom is
   port(
      addr: in std_logic_vector(4 downto 0);
      data: out std_logic_vector(7 downto 0)
   );
end rom;

architecture arch of rom is
   constant ADDR_WIDTH: integer:=5;
   constant DATA_WIDTH: integer:=8;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant HEX2LED_ROM: rom_type:=(  -- jeanjacquesrousseau
        x"62",  -- addr 00: b
        x"73",  -- addr 01: (void)
        x"77",  -- addr 02: (void)
        x"70",  -- addr 03: (void)
        x"6a",  -- addr 04: (void)
        x"61",  -- addr 05: (void)
        x"FF",  -- addr 06: (void)
        x"FF",  -- addr 07: (void)
        x"FF",  -- addr 08: (void)
        x"FF",  -- addr 09: (void)
        x"FF",  -- addr 10: (void)
        x"FF",  -- addr 11: (void)
        x"FF",  -- addr 12: (void)
        x"FF",  -- addr 13: (void)
        x"FF",  -- addr 14: (void)
        x"FF",  -- addr 15: (void)
        x"FF",  -- addr 16: (void)
        x"FF",  -- addr 17: (void)
        x"FF",  -- addr 18: (void)
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