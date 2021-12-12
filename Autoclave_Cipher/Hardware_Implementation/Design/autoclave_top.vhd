----------------------------------------------------------------------------------
-- Top design module
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity autoclave is
   generic(
     -- Default setting:
     -- 19,200 baud, 8 data bis, 1 stop bits
      DBIT: integer:=8;     -- # data bits
      SB_TICK: integer:=16; -- # ticks for stop bits, 16/24/32: for 1/1.5/2 stop bits
      DVSR: integer:= 326;  -- baud rate divisor: DVSR = 100M/(16*baud rate)
      DVSR_BIT: integer:=9; -- # bits of DVSR
      ROM_ADDR_WIDTH: integer:=5;   -- # maximum size of the ROM (key): 2^5 (32)
      KEY_LENGTH: integer:=19;       -- length of the key currently used
	  RAM_ADDR_WIDTH: integer:=10;  -- # maximum size of the RAM: 2^10 (1024)
	  RAM_DATA_WIDTH: integer:=8   -- # 8-bit data words
   );
   port(
      clk, reset, dec: in std_logic;
      rx: in std_logic;
      tx: out std_logic
   );
end autoclave;

architecture str_arch of autoclave is
   -- Baud and uart signals
   signal tick: std_logic;
   signal rx_done: std_logic;
   signal tx_start, tx_done: std_logic;
   signal ascii_r, ascii_t: std_logic_vector(7 downto 0);

   -- RAM signals
   signal clra_ram, inca_ram: std_logic;
   signal addra_ram: std_logic_vector(9 downto 0);
   signal wr: std_logic;

   -- Encoder and decoder signals
   signal key, cphr_out: std_logic_vector(7 downto 0);
   signal load_reg_a, clear_reg_a: std_logic;
   signal load_reg_b, clear_reg_b: std_logic;
   signal reg_a_out, reg_b_out: std_logic_vector(7 downto 0);
   signal mux_ctr_a, mux_ctr_b: std_logic;
   signal dec_mode: std_logic;
begin
   -- Assigning the value of key based on encode and decode condition dec_mode = 0 represents encode
   key <= reg_a_out when ((mux_ctr_a = '1') and (dec_mode = '0')) else  -- key will be reg_a_out when encode enabled
      x"62" when ((mux_ctr_a = '0') and (dec_mode = '0')) else  -- initial value of key 'B'

      reg_b_out when ((mux_ctr_b = '1') and (dec_mode = '1')) else -- key will be reg_b_out when devode enabled
      x"62" when ((mux_ctr_b = '0') and (dec_mode = '1')); -- initial value of key 'B'

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
   
   cnt_ram_unit: entity work.cnt_ram(arch)
      generic map(N=>RAM_ADDR_WIDTH)
      port map(
      clk=>clk, reset=>reset,
      syn_clr=>clra_ram, load=>'0', en=>inca_ram, up=>'1',
      d=>(others=>'0'),
      max_tick=>open, min_tick=>open,
      q=>addra_ram   
	  );

   ram_unit: entity work.xilinx_one_port_ram_sync(arch)
      generic map(ADDR_WIDTH=>RAM_ADDR_WIDTH, DATA_WIDTH=>RAM_DATA_WIDTH)
      port map(
      clk=>clk, wr=>wr,
      addr=>addra_ram,
      din=>cphr_out, dout=>ascii_t	  
	  );

   reg_a : ENTITY work.reg8bits(arch)
     PORT MAP(
        clk => clk, rst => reset, load => load_reg_a,
        clear => clear_reg_a, d => cphr_out, q => reg_a_out);


   reg_b : ENTITY work.reg8bits(arch)
     PORT MAP(
        clk => clk, rst => reset, load => load_reg_b,
        clear => clear_reg_b, d => ascii_r, q => reg_b_out);
        

   cipher_unit: entity work.cipher(arch)
      port map(
      ascii_r=>ascii_r, key=>key, dec => dec_mode,
      cphr_out=>cphr_out	  
	  );			   
 
   ctr_path_unit: entity work.ctr_path(arch)
      port map(
      clk=>clk, reset=>reset, dec_mode => dec_mode, dec=> dec,
      mux_ctr_a => mux_ctr_a,
      mux_ctr_b => mux_ctr_b,
      rx_done=>rx_done, ascii_r=>ascii_r, 
      clra_ram=>clra_ram, inca_ram=>inca_ram, 
      wr=>wr, ascii_t=>ascii_t, 
      tx_start=>tx_start, tx_done=>tx_done,
      load_reg_a => load_reg_a, clear_reg_a => clear_reg_a,
      load_reg_b => load_reg_b, clear_reg_b => clear_reg_b
	  );	
			   
end str_arch;