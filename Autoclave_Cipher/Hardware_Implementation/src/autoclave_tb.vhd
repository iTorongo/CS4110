LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY autoclave_tb IS
    -- Port ();
END autoclave_tb;

ARCHITECTURE arch OF autoclave_tb IS
    CONSTANT clk_period : TIME := 10 ns;
    CONSTANT bit_period : TIME := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us

    CONSTANT rx_data_ascii_r : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"72"; -- receive r
    CONSTANT rx_data_ascii_e : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"65"; -- receive e
    CONSTANT rx_data_ascii_t : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"74"; -- receive t
    CONSTANT rx_data_ascii_u : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"75"; -- receive u
    CONSTANT rx_data_ascii_r1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"72"; -- receive r
    CONSTANT rx_data_ascii_n : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"6e"; -- receive n
    CONSTANT rx_data_ascii_enter : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"0D"; -- receive enter

    COMPONENT autoclave
        PORT (
            reset, clk : IN STD_LOGIC;
            rx : IN STD_LOGIC;
            tx : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL clk, reset : STD_LOGIC;
    SIGNAL srx, stx : STD_LOGIC;

BEGIN

    uut : autoclave
    PORT MAP(
        clk => clk, reset => reset,
        rx => srx, tx => stx);

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    stim : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR clk_period * 2;
        reset <= '0';
        WAIT FOR clk_period * 2;

        -- Test ASCII char m
        srx <= '0'; -- start bit = 0
        WAIT FOR bit_period;
        FOR i IN 0 TO 7 LOOP
            srx <= rx_data_ascii_r(i); -- 8 data bits
            WAIT FOR bit_period;
        END LOOP;
        srx <= '1'; -- stop bit = 1
        WAIT FOR 1ms;

        -- Test ASCII char r
        srx <= '0'; -- start bit = 0
        WAIT FOR bit_period;
        FOR i IN 0 TO 7 LOOP
            srx <= rx_data_ascii_e(i); -- 8 data bits
            WAIT FOR bit_period;
        END LOOP;
        srx <= '1'; -- stop bit = 1
        WAIT FOR 1ms;

        -- Test ASCII char e
        srx <= '0'; -- start bit = 0
        WAIT FOR bit_period;
        FOR i IN 0 TO 7 LOOP
            srx <= rx_data_ascii_t(i); -- 8 data bits
            WAIT FOR bit_period;
        END LOOP;
        srx <= '1'; -- stop bit = 1
        WAIT FOR 1ms;

        -- Test ASCII char t
        srx <= '0'; -- start bit = 0
        WAIT FOR bit_period;
        FOR i IN 0 TO 7 LOOP
            srx <= rx_data_ascii_u(i); -- 8 data bits
            WAIT FOR bit_period;
        END LOOP;
        srx <= '1'; -- stop bit = 1
        WAIT FOR 1ms;

        -- Test ASCII char r
        srx <= '0'; -- start bit = 0
        WAIT FOR bit_period;
        FOR i IN 0 TO 7 LOOP
            srx <= rx_data_ascii_r1(i); -- 8 data bits
            WAIT FOR bit_period;
        END LOOP;
        srx <= '1'; -- stop bit = 1
        WAIT FOR 1ms;

        -- Test ASCII char n
        srx <= '0'; -- start bit = 0
        WAIT FOR bit_period;
        FOR i IN 0 TO 7 LOOP
            srx <= rx_data_ascii_n(i); -- 8 data bits
            WAIT FOR bit_period;
        END LOOP;
        srx <= '1'; -- stop bit = 1
        WAIT FOR 1ms;

        -- Test ACII Enter
        srx <= '0'; -- start bit = 0
        WAIT FOR bit_period;
        FOR i IN 0 TO 7 LOOP
            srx <= rx_data_ascii_enter(i); -- 8 data bits
            WAIT FOR bit_period;
        END LOOP;
        srx <= '1'; -- stop bit = 1
        WAIT;

    END PROCESS;

END arch;