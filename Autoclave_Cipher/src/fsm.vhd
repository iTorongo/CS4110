-- (adapted from) Listing 5.1
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY ctr_path IS
   PORT (
      clk, reset : IN STD_LOGIC;
      rx_done, tx_done : IN STD_LOGIC;
      ascii_r, ascii_t : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      clr_ram, inc_ram, wr, tx_start : OUT STD_LOGIC;
      load_reg_a, load_reg_b, mux_ctr : OUT STD_LOGIC;
      clear_reg_a, clear_reg_b : OUT STD_LOGIC
   );
END ctr_path;

ARCHITECTURE arch OF ctr_path IS
   TYPE state_type IS (s0, s1, s2, s3);
   SIGNAL state_reg, state_next : state_type;
BEGIN

   -- state register
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         state_reg <= s0;
      ELSIF rising_edge(clk) THEN
         state_reg <= state_next;
      END IF;
   END PROCESS;

   -- next-state and outputs logic
   PROCESS (state_reg, rx_done, tx_done, ascii_r, ascii_t)
   BEGIN
      clr_ram <= '0';
      inc_ram <= '0';
      load_reg_a <= '0';
      load_reg_b <= '0';
      clear_reg_a <= '0';
      clear_reg_b <= '0';
      wr <= '0';
      tx_start <= '0';
      state_next <= state_reg;

      CASE state_reg IS
         WHEN s0 =>
            clr_ram <= '1';
            load_reg_a <= '1';
            state_next <= s1;
         WHEN s1 =>
            IF (rx_done = '1') THEN
               IF ((ascii_r >= x"41" AND ascii_r <= x"5A") OR
                  (ascii_r >= x"61" AND ascii_r <= x"7A") OR
                  ascii_r = x"20" OR ascii_r = x"0D") THEN
                  wr <= '1';
                  IF (ascii_r = x"31") THEN
                     mux_ctr <= '1';
                     state_next <= s1;
                  ELSE
                     IF (ascii_r = x"20") THEN
                        inc_ram <= '1';
                        state_next <= s1;
                     ELSE
                        IF (ascii_r = x"0D") THEN
                           clr_ram <= '1';
                           state_next <= s2;
                        ELSE
                           inc_ram <= '1';
                           load_reg_b <= '1';
                           load_reg_a <= '1';
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         WHEN s2 =>
            IF (ascii_t = x"0D") THEN
               state_next <= s0;
            ELSE
               tx_start <= '1';
               state_next <= s3;
            END IF;
         WHEN s3 =>
            IF (tx_done = '1') THEN
               inc_ram <= '1';
               state_next <= s2;
            END IF;
      END CASE;
   END PROCESS;

END arch;