-- (adapted from) Listing 11.1
-- Single-port RAM with synchronous read
-- Modified from XST 8.1i rams_07
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY xilinx_one_port_ram_sync IS
   GENERIC (
      ADDR_WIDTH : INTEGER := 10; -- 1KB RAM
      DATA_WIDTH : INTEGER := 8
   );
   PORT (
      clk : IN STD_LOGIC;
      wr : IN STD_LOGIC;
      addr : IN STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
      din : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
      dout : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
   );
END xilinx_one_port_ram_sync;

ARCHITECTURE arch OF xilinx_one_port_ram_sync IS
   TYPE ram_type IS ARRAY (2 ** ADDR_WIDTH - 1 DOWNTO 0)
   OF STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
   SIGNAL ram : ram_type;

BEGIN
   PROCESS (clk)
   BEGIN
      IF rising_edge(clk) THEN
         IF (wr = '1') THEN
            ram(to_integer(unsigned(addr))) <= din;
         END IF;
      END IF;
   END PROCESS;
   dout <= ram(to_integer(unsigned(addr)));
END arch;