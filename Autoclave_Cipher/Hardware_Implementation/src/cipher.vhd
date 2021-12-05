LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY cipher IS
    PORT (
        ascii_r : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        key : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        mux_ctr : IN STD_LOGIC;
        cphr_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END cipher;

ARCHITECTURE arch OF cipher IS
    SIGNAL sdin : unsigned (7 DOWNTO 0);
    SIGNAL skey : unsigned (7 DOWNTO 0);
    SIGNAL sdout : unsigned (7 DOWNTO 0);
    SIGNAL sum : unsigned (7 downto 0);


BEGIN
    sdin <= unsigned(ascii_r);
    skey <= unsigned(key);
    sum <= (((sdin - x"61") + (skey - x"61")) - 26) when (((sdin - x"61") + (skey - x"61")) > 25) else ((sdin - x"61") + (skey - x"61"));
    sdout <=
        x"20" WHEN (sdin = x"20") ELSE
        (x"61" + sum);
        -- (x"61" + (sdin - x"61") - (skey - x"61"));
    cphr_out <= STD_LOGIC_VECTOR(sdout);

END arch;