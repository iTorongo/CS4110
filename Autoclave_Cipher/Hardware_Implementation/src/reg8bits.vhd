-- Listing 4.5 modified
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY reg8bits IS
    PORT (
        clk, rst, load, clear : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END reg8bits;

ARCHITECTURE arch OF reg8bits IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            q <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF (clear = '1') THEN
                q <= (OTHERS => '0');
            ELSIF (load = '1') THEN
                q <= d;
            END IF;
        END IF;
    END PROCESS;

END arch;