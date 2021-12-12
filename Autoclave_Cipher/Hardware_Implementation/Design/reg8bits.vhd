----------------------------------------------------------------------------------
-- Register 8 bits
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity reg8bits is
   port(clk, rst, load, clear: in std_logic;
        d: in std_logic_vector(7 downto 0);
        q: out std_logic_vector(7 downto 0));
end reg8bits;

architecture arch of reg8bits is

begin
   process(clk,rst)
   begin
      if (rst='1') then
         q <=(others=>'0');
      elsif rising_edge(clk) then
			if (clear='1') then
				q <=(others=>'0');
			elsif (load='1') then
				q <= d;
			end if;
      end if;
   end process;
   
end arch;