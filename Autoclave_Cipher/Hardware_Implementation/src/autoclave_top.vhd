library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity autoclave is
      DBIT: integer:=8;     -- # data bits
      SB_TICK: integer:=16; -- # ticks for stop bits, 16/24/32: for 1/1.5/2 stop bits
      DVSR: integer:= 326;  -- baud rate divisor: DVSR = 100M/(16*baud rate)
      DVSR_BIT: integer:=9; -- # bits of DVSR
      --KEY_LENGTH: integer:=19;       -- length of the key currently used
	  RAM_ADDR_WIDTH: integer:=10;  -- # maximum size of the RAM: 2^10 (1024)
	  RAM_DATA_WIDTH: integer:=8   -- # 8-bit data words
   );
   port(
      clk, reset: in std_logic;
      rx: in std_logic;
      tx: out std_logic
   );
end autoclave;

architecture str_arch of autoclave is
   signal tick: std_logic;
   signal rx_done: std_logic;
   signal ascii_r, ascii_t: std_logic_vector(7 downto 0);
   signal tx_start, tx_done: std_logic;
   signal clr_ram, inc_ram: std_logic;
   signal addr_ram: std_logic_vector(9 downto 0);
   signal key, cphr_out: std_logic_vector(7 downto 0);
   signal wr: std_logic;
   signal mux_ctr_cipher: std_logic;
   signal load_reg_a, load_reg_b, clear_reg_a, clear_reg_b: std_logic;
   signal reg_b_out: std_logic_vector(7 downto 0);
   signal reg_a_out: std_logic_vector(7 downto 0) :=x"62";

begin

   baud_gen_unit: entity work.mod_m_counter(arch)
      generic map(M=>DVSR, N=>DVSR_BIT)
      port map(
	  clk=>clk, reset=>reset,
      q=>open, max_tick=>tick
	  );

   uart_rx_unit: entity work.uart_rx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(
	  clk=>clk, reset=>reset, rx=>rx,
      s_tick=>tick, rx_done_tick=>rx_done,
      dout=>ascii_r
	  );

   uart_tx_unit: entity work.uart_tx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(
	  clk=>clk, reset=>reset,
      tx_start=>tx_start,
      s_tick=>tick, din=>ascii_t,
      tx_done_tick=> tx_done, tx=>tx
	  );

  -- Encode if mux control is 0 other wise decode
   -- ascii_r <= cphr_out WHEN mux_ctr_cipher = '1' ELSE ascii_r;
   -- reg_b_out <= x"62"; -- Setting Initial key as B as hex "x62"
   key <= reg_a_out;

   -- reg_a : entity work.reg8bits(arch)
   --    port map(
   --       clk => clk, rst => reset, load => load_reg_a,
   --       clear => clear_reg_a, d => cphr_out, q => reg_a_out);

   -- reg_b : entity work.reg8bits(arch)
   --    port map(
   --       clk => clk, rst => reset, load => load_reg_b,
   --       clear => clear_reg_b, d => cphr_out, q => reg_b_out);

   cnt_ram_unit: entity work.cnt_ram(arch)
      generic map(N=>RAM_ADDR_WIDTH)
      port map(
      clk=>clk, reset=>reset,
      syn_clr=>clrB_ram, load=>'0', en=>inc_ram, up=>'1',
      d=>(others=>'0'),
      max_tick=>open, min_tick=>open,
      q=>addr_ram   
	  );

   ram_unit: entity work.xilinx_one_port_ram_sync(arch)
      generic map(ADDR_WIDTH=>RAM_ADDR_WIDTH, DATA_WIDTH=>RAM_DATA_WIDTH)
      port map(
      clk=>clk, wr=>wr,
      addr=>addrb_ram,
      din=>cphr_out, dout=>ascii_t	  
	  );

   cipher_unit: entity work.cipher(arch)
      port map(
      ascii_r=>ascii_r, mux_ctr=>mux_ctr_cipher,
      cphr_out=>cphr_out	  
	  );			   
 
   ctr_path_unit: entity work.ctr_path(arch)
      port map(
      clk=>clk, reset=>reset,
      rx_done=>rx_done, tx_done=>tx_done,
      ascii_r=>ascii_r, ascii_t=>ascii_t,
      clr_ram=>clr_ram, inc_ram=>inc_ram, 
      wr=>wr, tx_start=>tx_start,
      load_reg_a=>load_reg_a, load_reg_b=>load_reg_b, mux_ctr=>mux_ctr_cipher,
      clear_reg_a=>clear_reg_a, clear_reg_b=>clear_reg_b
	  );	
			   
end str_arch;