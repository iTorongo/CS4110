-- (adapted from) Listing 4.10
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY cnt_ram IS
   GENERIC (N : INTEGER := 10);
   PORT (
      clk, reset : IN STD_LOGIC;
      syn_clr, load, en, up : IN STD_LOGIC;
      d : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      max_tick, min_tick : OUT STD_LOGIC;
      q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
   );
END cnt_ram;

ARCHITECTURE arch OF cnt_ram IS
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
   r_next <= (OTHERS => '0') WHEN syn_clr = '1' ELSE
      unsigned(d) WHEN load = '1' ELSE
      r_reg + 1 WHEN en = '1' AND up = '1' ELSE
      r_reg - 1 WHEN en = '1' AND up = '0' ELSE
      r_reg;
   -- output logic
   q <= STD_LOGIC_VECTOR(r_reg);
   max_tick <= '1' WHEN r_reg = (2 ** N - 1) ELSE
      '0';
   min_tick <= '1' WHEN r_reg = 0 ELSE
      '0';
END arch;