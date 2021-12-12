library ieee;

use ieee.std_logic_1164.all;
 
ENTITY autoclave_tb IS
   -- port ();
end autoclave_tb;
 
architecture arch OF autoclave_tb IS
   constant clk_period : time := 10 ns;
   constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us

   -- Defining input "return" for Encode
   constant rx_data_ascii_r : std_logic_vector(7 downto 0) := x"72"; -- receive r
   constant rx_data_ascii_e : std_logic_vector(7 downto 0) := x"65"; -- receive e
   constant rx_data_ascii_t : std_logic_vector(7 downto 0) := x"74"; -- receive t
   constant rx_data_ascii_u : std_logic_vector(7 downto 0) := x"75"; -- receive u
   constant rx_data_ascii_n : std_logic_vector(7 downto 0) := x"6e"; -- receive n
   

   -- Defining input "swpjan" for Decode
   constant rx_data_ascii_s : std_logic_vector(7 downto 0) := x"73"; -- receive s
   constant rx_data_ascii_w : std_logic_vector(7 downto 0) := x"77"; -- receive w
   constant rx_data_ascii_p : std_logic_vector(7 downto 0) := x"70"; -- receive p
   constant rx_data_ascii_j : std_logic_vector(7 downto 0) := x"6A"; -- receive j
   constant rx_data_ascii_a : std_logic_vector(7 downto 0) := x"61"; -- receive a

   -- Enter key to represents input ends
   constant rx_data_ascii_enter : std_logic_vector(7 downto 0) := x"0D"; -- receive enter
 
   component autoclave
       port (
           reset, clk, dec : in std_logic;
           rx : in std_logic;
           tx : OUT std_logic);
   end component;
 
   signal clk, reset, dec : std_logic;
   signal srx, stx : std_logic;
 
begin
 
   uut : autoclave
   port map(
       clk => clk, reset => reset, dec => dec,
       rx => srx, tx => stx);
 
   clk_process : process
   begin
       clk <= '0';
       wait for clk_period/2;
       clk <= '1';
       wait for clk_period/2;
   end process;
 
   stim : process
   begin
       reset <= '1';
       wait for clk_period * 2;
       reset <= '0';
       wait for clk_period * 2;
       
       dec <= '0';
       wait for clk_period * 2;

       -- Encryption test vector

        -- Test ASCII char r
       srx <= '0'; -- start bit = 0
       wait for bit_period;
       for i in 0 to 7 loop
           srx <= rx_data_ascii_r(i); -- 8 data bits
           wait for bit_period;
       end loop;
       srx <= '1'; -- stop bit = 1
       wait for 1ms;
 
       -- Test ASCII char e
       srx <= '0'; -- start bit = 0
       wait for bit_period;
       for i in 0 to 7 loop
           srx <= rx_data_ascii_e(i); -- 8 data bits
           wait for bit_period;
       end loop;
       srx <= '1'; -- stop bit = 1
       wait for 1ms;
 
       -- Test ASCII char t
       srx <= '0'; -- start bit = 0
       wait for bit_period;
       for i in 0 to 7 loop
           srx <= rx_data_ascii_t(i); -- 8 data bits
           wait for bit_period;
       end loop;
       srx <= '1'; -- stop bit = 1
       wait for 1ms;
 
       -- Test ASCII char u
       srx <= '0'; -- start bit = 0
       wait for bit_period;
       for i in 0 to 7 loop
           srx <= rx_data_ascii_u(i); -- 8 data bits
           wait for bit_period;
       end loop;
       srx <= '1'; -- stop bit = 1
       wait for 1ms;
 
       -- Test ASCII char r
       srx <= '0'; -- start bit = 0
       wait for bit_period;
       for i in 0 to 7 loop
           srx <= rx_data_ascii_r(i); -- 8 data bits
           wait for bit_period;
       end loop;
       srx <= '1'; -- stop bit = 1
       wait for 1ms;
 
       -- Test ASCII char n
       srx <= '0'; -- start bit = 0
       wait for bit_period;
       for i in 0 to 7 loop
           srx <= rx_data_ascii_n(i); -- 8 data bits
           wait for bit_period;
       end loop;
       srx <= '1'; -- stop bit = 1
       wait for 1ms;
 
       -- Test ACII Enter
       srx <= '0'; -- start bit = 0
       wait for bit_period;
       for i in 0 to 7 loop
           srx <= rx_data_ascii_enter(i); -- 8 data bits
           wait for bit_period;
       end loop;
       srx <= '1'; -- stop bit = 1
       WAIT;

       -- Decryption
 
    --    reset <= '1';
    --    wait for clk_period * 2;

    --    reset <= '0';
    --    wait for clk_period * 2;

    --    dec <= '1';
    --    wait for clk_period * 2;

    --    -- Test ASCII char s
    --    srx <= '0'; -- start bit = 0
    --    wait for bit_period;
    --    for i in 0 to 7 loop
    --        srx <= rx_data_ascii_s(i); -- 8 data bits
    --        wait for bit_period;
    --    end loop;
    --    srx <= '1'; -- stop bit = 1
    --    wait for 1ms;
 
    --    -- Test ASCII char w
    --    srx <= '0'; -- start bit = 0
    --    wait for bit_period;
    --    for i in 0 to 7 loop
    --        srx <= rx_data_ascii_w(i); -- 8 data bits
    --        wait for bit_period;
    --    end loop;
    --    srx <= '1'; -- stop bit = 1
    --    wait for 1ms;
 
    --    -- Test ASCII char p
    --    srx <= '0'; -- start bit = 0
    --    wait for bit_period;
    --    for i in 0 to 7 loop
    --        srx <= rx_data_ascii_p(i); -- 8 data bits
    --        wait for bit_period;
    --    end loop;
    --    srx <= '1'; -- stop bit = 1
    --    wait for 1ms;
 
    --    -- Test ASCII char j
    --    srx <= '0'; -- start bit = 0
    --    wait for bit_period;
    --    for i in 0 to 7 loop
    --        srx <= rx_data_ascii_j(i); -- 8 data bits
    --        wait for bit_period;
    --    end loop;
    --    srx <= '1'; -- stop bit = 1
    --    wait for 1ms;
 
    --    -- Test ASCII char a
    --    srx <= '0'; -- start bit = 0
    --    wait for bit_period;
    --    for i in 0 to 7 loop
    --        srx <= rx_data_ascii_a(i); -- 8 data bits
    --        wait for bit_period;
    --    end loop;
    --    srx <= '1'; -- stop bit = 1
    --    wait for 1ms;
 
    --    -- Test ASCII char n
    --    srx <= '0'; -- start bit = 0
    --    wait for bit_period;
    --    for i in 0 to 7 loop
    --        srx <= rx_data_ascii_n(i); -- 8 data bits
    --        wait for bit_period;
    --    end loop;
    --    srx <= '1'; -- stop bit = 1
    --    wait for 1ms;
 
    --    -- Test ACII Enter
    --    srx <= '0'; -- start bit = 0
    --    wait for bit_period;
    --    for i in 0 to 7 loop
    --        srx <= rx_data_ascii_enter(i); -- 8 data bits
    --        wait for bit_period;
    --    end loop;
    --    srx <= '1'; -- stop bit = 1
    --    WAIT;
 
   end process;
 
end arch;