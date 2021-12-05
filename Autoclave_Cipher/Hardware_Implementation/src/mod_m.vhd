----------------------------------------------------------------------------------
-- Listing 4.11 Mod-m counter
-- This baud-rate generator will generate sampling ticks

-- Frequency = 16x the required baud rate (16x oversampling)
-- 19200 bps * 16 = 307200 ticks/s
-- 100 MHz / 307200 = 325.52 = 326
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY mod_m_counter IS
   GENERIC (
      N : INTEGER := 9; -- number of bits
      M : INTEGER := 326 -- mod-M
   );
   PORT (
      clk, reset : IN STD_LOGIC;
      max_tick : OUT STD_LOGIC;
      q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
   );
END mod_m_counter;

ARCHITECTURE arch OF mod_m_counter IS
   SIGNAL r_reg : unsigned(N - 1 DOWNTO 0);
   SIGNAL r_next : unsigned(N - 1 DOWNTO 0);
BEGIN
   -- register
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         r_reg <= (OTHERS => '0');
      ELSIF (clk'event AND clk = '1') THEN
         r_reg <= r_next;
      END IF;
   END PROCESS;
   -- next-state logic
   r_next <= (OTHERS => '0') WHEN r_reg = (M - 1) ELSE
      r_reg + 1;
   -- output logic
   q <= STD_LOGIC_VECTOR(r_reg);
   max_tick <= '1' WHEN r_reg = (M - 1) ELSE
      '0';
END arch;