----------------------------------------------------------------------------------
-- Control Path
----------------------------------------------------------------------------------
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
         -----------------
         -- S0
         -----------------
         when s0 =>
			   clra_ram <= '1'; -- clear ram key
            state_next <= s1;
         -----------------
         -- S1
         -- Run once in flow
         -----------------
         when s1 =>
            if (rx_done='1') then
               -- Check for valid ascii only for Alphabet lower and upper case, Space and Enter
               if ((ascii_r >= x"41" and ascii_r <= x"5A") or 
                  (ascii_r >= x"61" and ascii_r <= x"7A") or 
                     ascii_r = x"20" or ascii_r = x"0D") then
                     wr <= '1'; -- Write enabled RAM

                     if (ascii_r = x"20") then -- X"20" = "Space"-key
                        inca_ram <= '1';
                        state_next <= s1;
                     else
                        if (ascii_r=x"0D") then -- X"0D" = "Enter"-key (carriage return)
                           clra_ram <= '1';     -- Increment ram key
                           state_next <= s3;
                        else
                           inca_ram <= '1';     -- Increment ram key
                           load_reg_a <= '1';   -- Load register
                           load_reg_b <= '1';   -- Load register
                           state_next <= s2;
                        end if;
                     end if;
               end if;
			end if;

         -----------------
         -- S2
         -- Identical as s1 the only difference is mux control has been set in s2 
         -----------------
         when s2 =>
            if (rx_done='1') then
               -- Check for valid ascii only for Alphabet lower and upper case, Space and Enter
               if ((ascii_r >= x"41" and ascii_r <= x"5A") or 
                  (ascii_r >= x"61" and ascii_r <= x"7A") or 
                     ascii_r = x"20" or ascii_r = x"0D") then
                     wr <= '1';

                     if (ascii_r = x"20") then -- X"20" = "Space"-key 
                        inca_ram <= '1';
                        state_next <= s2;
                     else
                        if (ascii_r=x"0D") then -- X"0D" = "Enter"-key (carriage return)
                           clra_ram <= '1';
                           state_next <= s3;
                        else
                           inca_ram <= '1';     -- Increment ram key
                           mux_ctr_a <= '1';    -- Mux control while encryption,
                           mux_ctr_b <= '1';    -- Mux control while decryption
                           load_reg_a <= '1';   -- Load register
                           load_reg_b <= '1';   -- Load register
                        end if;
                     end if;
               end if;
			   end if;
         -----------------
         -- S3
         -----------------
         when s3 =>
            if (ascii_t=x"0D") then 
			   state_next <= s0;
			else 
			   tx_start <= '1';
			   state_next <= s4;
			end if;
         -----------------
         -- S4
         -----------------
         when s4 =>
            if (tx_done='1') then  
               inca_ram <= '1';
               state_next <= s3;
            end if;
      end case;
   end process;

   dec_mode <= dec;  -- Assigning encode/decode mode

end arch;