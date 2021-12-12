library ieee;
use ieee.std_logic_1164.all;
entity ctr_path is
   port(
      clk, reset: in std_logic;
      dec : in std_logic;
      rx_done, tx_done: in std_logic;
	   ascii_r, ascii_t: in std_logic_vector(7 downto 0);
      clra_ram, inca_ram, wr, tx_start: out std_logic;
      load_reg_a, clear_reg_a : out std_logic;
      load_reg_b, clear_reg_b : out std_logic;
      mux_ctr_a, mux_ctr_b: out std_logic;
      dec_mode : out std_logic
   );
end ctr_path;

architecture arch of ctr_path is
   type state_type is (s0, s1, s2, s3, s4);
   signal state_reg, state_next: state_type;
begin

   -- state register
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= s0;
      elsif rising_edge(clk) then
         state_reg <= state_next;
      end if;
   end process;
   
   -- next-state and outputs logic
   process(state_reg, dec, rx_done, tx_done, ascii_r, ascii_t)
   begin
   -- Reset
   clra_ram <= '0';
   inca_ram <= '0';
   mux_ctr_a <= '0';
   mux_ctr_b <= '0';
   wr <= '0';
   tx_start <= '0';
   load_reg_a <= '0';
   clear_reg_a <= '0';
   load_reg_b <= '0';
   clear_reg_b <= '0';
   state_next <= state_reg;
   
      case state_reg is
         when s0 =>
			   clra_ram <= '1';
            state_next <= s1;
         -- State s1 will only run once in flow
         when s1 =>
            if (rx_done='1') then
               -- Validation for valid ascii
               if ((ascii_r >= x"41" and ascii_r <= x"5A") or 
                  (ascii_r >= x"61" and ascii_r <= x"7A") or 
                     ascii_r = x"20" or ascii_r = x"0D") then
                     wr <= '1';
                     -- Handling 
                     if (ascii_r = x"20") then
                        inca_ram <= '1';
                        state_next <= s1;
                     else
                        if (ascii_r=x"0D") then
                           clra_ram <= '1';
                           state_next <= s3;
                        else
                           inca_ram <= '1';
                           load_reg_a <= '1';
                           load_reg_b <= '1';
                           state_next <= s2;
                        end if;
                     end if;
               end if;
			end if;
         -- State s2 is identical as s1 the only difference is mux control has been set in s2 
         when s2 =>
            if (rx_done='1') then
               -- Validation for valid ascii
               if ((ascii_r >= x"41" and ascii_r <= x"5A") or 
                  (ascii_r >= x"61" and ascii_r <= x"7A") or 
                     ascii_r = x"20" or ascii_r = x"0D") then
                     wr <= '1';
                     -- Check for space input
                     if (ascii_r = x"20") then
                        inca_ram <= '1';
                        state_next <= s2;
                     else
                        -- Check for Enter input
                        if (ascii_r=x"0D") then
                           clra_ram <= '1';
                           state_next <= s3;
                        else
                           inca_ram <= '1';
                           mux_ctr_a <= '1'; -- while encryption,
                           mux_ctr_b <= '1';  -- while decryption
                           load_reg_a <= '1';
                           load_reg_b <= '1';
                        end if;
                     end if;
               end if;
			end if;
         when s3 =>
            if (ascii_t=x"0D") then 
			   state_next <= s0;
			else 
			   tx_start <= '1';
			   state_next <= s4;
			end if;
		 when s4 =>
		    if (tx_done='1') then  
			   inca_ram <= '1';
			   state_next <= s3;
			end if;
      end case;
   end process;

   dec_mode <= dec;

end arch;