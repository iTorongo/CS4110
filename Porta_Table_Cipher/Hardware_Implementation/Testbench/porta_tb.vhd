library ieee;
use ieee.std_logic_1164.ALL;

entity porta_tb is
   -- Port ();
end porta_tb;

architecture arch of porta_tb is
constant clk_period : time := 10 ns;
constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us

-- Defining the input chief for the UUT
constant rx_data_ascii_c: std_logic_vector(7 downto 0) := x"63"; -- receive c
constant rx_data_ascii_h: std_logic_vector(7 downto 0) := x"68"; -- receive h
constant rx_data_ascii_i: std_logic_vector(7 downto 0) := x"69"; -- receive i
constant rx_data_ascii_e: std_logic_vector(7 downto 0) := x"65"; -- receive e
constant rx_data_ascii_f: std_logic_vector(7 downto 0) := x"66"; -- receive f
constant rx_data_ascii_enter: std_logic_vector(7 downto 0) := x"0D"; -- receive enter

Component porta
Port ( reset, clk: in std_logic;
           rx:      in std_logic;
           tx:     out std_logic);
end Component;

signal clk, reset: std_logic;
signal srx, stx: std_logic;

begin

    uut: porta
    Port Map(clk => clk, reset => reset, 
              rx => srx, tx => stx);
    
    clk_process: process 
            begin
               clk <= '0';
               wait for clk_period/2;
               clk <= '1';
               wait for clk_period/2;
            end process; 
        
     stim: process
        begin
        reset <= '1';
        wait for clk_period*2;
        reset <= '0';
        wait for clk_period*2;
        -- Encryption test vector
        -- Test ASCII char c
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_c(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 1ms;

        -- Test ASCII char h
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_h(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 1ms;

        -- Test ASCII char i
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_i(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 1ms;
        
        -- Test ASCII char e
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_e(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 1ms;
 
         -- Test ASCII char f
                srx <= '0';                      -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_f(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1';                      -- stop bit = 1
                wait for 1ms;
                                                
         -- Test ASCII Enter
                srx <= '0';                      -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_enter(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1';                      -- stop bit = 1
                wait;
       
        end process;

end arch;