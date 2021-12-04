-- Listing 7.1
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY uart_rx IS
   GENERIC (
      DBIT : INTEGER := 8; -- # data bits
      SB_TICK : INTEGER := 16 -- # ticks for stop bits
   );
   PORT (
      clk, reset : IN STD_LOGIC;
      rx : IN STD_LOGIC;
      s_tick : IN STD_LOGIC;
      rx_done_tick : OUT STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   );
END uart_rx;

ARCHITECTURE arch OF uart_rx IS
   TYPE state_type IS (idle, start, data, stop);
   SIGNAL state_reg, state_next : state_type;
   SIGNAL s_reg, s_next : unsigned(3 DOWNTO 0);
   SIGNAL n_reg, n_next : unsigned(2 DOWNTO 0);
   SIGNAL b_reg, b_next : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
   -- FSMD state & data registers
   PROCESS (clk, reset)
   BEGIN
      IF reset = '1' THEN
         state_reg <= idle;
         s_reg <= (OTHERS => '0');
         n_reg <= (OTHERS => '0');
         b_reg <= (OTHERS => '0');
      ELSIF (clk'event AND clk = '1') THEN
         state_reg <= state_next;
         s_reg <= s_next;
         n_reg <= n_next;
         b_reg <= b_next;
      END IF;
   END PROCESS;
   -- next-state logic & data path functional units/routing
   PROCESS (state_reg, s_reg, n_reg, b_reg, s_tick, rx)
   BEGIN
      state_next <= state_reg;
      s_next <= s_reg;
      n_next <= n_reg;
      b_next <= b_reg;
      rx_done_tick <= '0';
      CASE state_reg IS
         WHEN idle =>
            IF rx = '0' THEN
               state_next <= start;
               s_next <= (OTHERS => '0');
            END IF;
         WHEN start =>
            IF (s_tick = '1') THEN
               IF s_reg = 7 THEN
                  state_next <= data;
                  s_next <= (OTHERS => '0');
                  n_next <= (OTHERS => '0');
               ELSE
                  s_next <= s_reg + 1;
               END IF;
            END IF;
         WHEN data =>
            IF (s_tick = '1') THEN
               IF s_reg = 15 THEN
                  s_next <= (OTHERS => '0');
                  b_next <= rx & b_reg(7 DOWNTO 1);
                  IF n_reg = (DBIT - 1) THEN
                     state_next <= stop;
                  ELSE
                     n_next <= n_reg + 1;
                  END IF;
               ELSE
                  s_next <= s_reg + 1;
               END IF;
            END IF;
         WHEN stop =>
            IF (s_tick = '1') THEN
               IF s_reg = (SB_TICK - 1) THEN
                  state_next <= idle;
                  rx_done_tick <= '1';
               ELSE
                  s_next <= s_reg + 1;
               END IF;
            END IF;
      END CASE;
   END PROCESS;
   dout <= b_reg;
END arch;