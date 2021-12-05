LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY autoclave is
  generic(
  DBIT: INTEGER:= 8; -- # data bits
  SB_TICK: INTEGER:= 16; -- # ticks for stop bits, 16/24/32: for 1/1.5/2 stop bits
  DVSR: INTEGER:= 326; -- baud rate divisor: DVSR = 100M/(16*baud rate)
  DVSR_BIT: INTEGER:= 9; -- # bits of DVSR
  ROM_ADDR_WIDTH: integer:=5;
  KEY_LENGTH: integer:=19;
  RAM_ADDR_WIDTH: INTEGER:= 10; -- # maximum size of the RAM: 2^10 (1024)
  RAM_DATA_WIDTH: INTEGER:= 8 -- # 8-bit data words
  );
  PORT (
     clk, reset: IN STD_LOGIC;
     rx: IN STD_LOGIC;
     tx: OUT STD_LOGIC
  );
END autoclave;
 
ARCHITECTURE str_arch OF autoclave IS
  SIGNAL tick: STD_LOGIC;
  SIGNAL rx_done: STD_LOGIC;
  SIGNAL ascii_r, ascii_t: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL tx_start, tx_done: STD_LOGIC;
  SIGNAL clr_ram, inc_ram: STD_LOGIC;
  SIGNAL addr_ram: STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL key, cphr_out: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL wr: STD_LOGIC;
  SIGNAL mux_ctr_cipher: STD_LOGIC;
  SIGNAL load_reg_a, load_reg_b, clear_reg_a, clear_reg_b: STD_LOGIC;
  SIGNAL reg_b_out: STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal reg_a_out: std_logic_vector(7 downto 0):= x"62";
  signal reg_a_in: std_logic_vector(7 downto 0);
  signal clr_rom, inc_rom: std_logic;
  signal addr_rom: std_logic_vector(4 downto 0);
 
BEGIN
  key <= reg_a_out;
 
  baud_gen_unit : ENTITY work.mod_m_counter(arch)
     GENERIC MAP(M => DVSR, N => DVSR_BIT)
     PORT MAP(
        clk => clk, reset => reset,
        q => OPEN, max_tick => tick
     );
 
  uart_rx_unit : ENTITY work.uart_rx(arch)
     GENERIC MAP(DBIT => DBIT, SB_TICK => SB_TICK)
     PORT MAP(
        clk => clk, reset => reset, rx => rx,
        s_tick => tick, rx_done_tick => rx_done,
        dout => ascii_r
     );
 
  uart_tx_unit : ENTITY work.uart_tx(arch)
     GENERIC MAP(DBIT => DBIT, SB_TICK => SB_TICK)
     PORT MAP(
        clk => clk, reset => reset,
        tx_start => tx_start,
        s_tick => tick, din => ascii_t,
        tx_done_tick => tx_done, tx => tx
     );
 
  -------- ROM
  -- cnt_rom_unit: entity work.cnt_rom(arch)
  --    generic map(N=>ROM_ADDR_WIDTH, M=>KEY_LENGTH)
  --     port map(
  --     clk=>clk, reset=>reset,
  --     syn_clr=>clr_rom, load=>'0', en=>inc_rom, up=>'1',
  --     d=>(others=>'0'),
  --     max_tick=>open, min_tick=>open,
  --     q=>addr_rom    
  --    );
  -- rom_unit: entity work.rom(arch)
  --     port map(
  --     addr=>addr_rom,
  --     data=>key   
  --    );
 
  --------
  -- Encode if mux control is 0 other wise decode
  -- ascii_r <= cphr_out WHEN mux_ctr_cipher = '1' ELSE
  --    ascii_r;
 
  reg_a : ENTITY work.reg8bits(arch)
     PORT MAP(
        clk => clk, rst => reset, load => load_reg_a,
        clear => clear_reg_a, d => cphr_out, q => reg_a_out);
 
  reg_b : ENTITY work.reg8bits(arch)
     PORT MAP(
        clk => clk, rst => reset, load => load_reg_b,
        clear => clear_reg_b, d => cphr_out, q => reg_b_out);
 
  cnt_ram_unit : ENTITY work.cnt_ram(arch)
     GENERIC MAP(N => RAM_ADDR_WIDTH)
     PORT MAP(
        clk => clk, reset => reset,
        syn_clr => clr_ram, load => '1', en => inc_ram, up => '0',
        d => (OTHERS => '0'),
     max_tick => OPEN, min_tick => OPEN,
        q => addr_ram
        );
 
  ram_unit : ENTITY work.xilinx_one_port_ram_sync(arch)
     GENERIC MAP(ADDR_WIDTH => RAM_ADDR_WIDTH, DATA_WIDTH => RAM_DATA_WIDTH)
     PORT MAP(
        clk => clk, wr => wr,
         addr => addr_ram,
        din => cphr_out, dout => ascii_t
        );
 
  cipher_unit : ENTITY work.cipher(arch)
     PORT MAP(
     ascii_r => ascii_r, key => key, mux_ctr => mux_ctr_cipher,
        cphr_out => cphr_out
        );
 
  ctr_path_unit : ENTITY work.ctr_path(arch)
     PORT MAP(
        clk => clk, reset => reset, mux_ctr => mux_ctr_cipher,
        clr_rom=>clr_rom, inc_rom=>inc_rom,
        rx_done => rx_done, ascii_r => ascii_r,
        clr_ram => clr_ram, inc_ram => inc_ram,
        wr => wr, ascii_t => ascii_t,
        tx_start => tx_start, tx_done => tx_done,
        load_reg_a => load_reg_a, load_reg_b => load_reg_b,
        clear_reg_a => clear_reg_a, clear_reg_b => clear_reg_b
        );
       
end str_arch;

