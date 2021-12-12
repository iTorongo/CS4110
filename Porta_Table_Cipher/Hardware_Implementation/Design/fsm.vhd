----------------------------------------------------------------------------------
-- Control Path
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity ctr_path is
   port(
      clk, reset: in std_logic;
      rx_done, tx_done: in std_logic;
	  ascii_r, ascii_t: in std_logic_vector(7 downto 0);
      clra_rom, inca_rom, clrb_ram, incb_ram, wr, tx_start: out std_logic
   );
end ctr_path;

architecture arch of ctr_path is
   type state_type is (s0, s1, s2, s3);
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
   process(state_reg, rx_done, tx_done, ascii_r, ascii_t)
   begin
   clra_rom <= '0';
   inca_rom <= '0';
   clrb_ram <= '0';
   incb_ram <= '0';
   wr <= '0';
   tx_start <= '0';
   state_next <= state_reg;
   
      case state_reg is
         -----------------
         -- S0
         -----------------
         when s0 =>
            clra_rom <= '1'; -- Clear rom key
			   clrb_ram <= '1'; -- Clear ram key
            state_next <= s1;
         -----------------
         -- S1
         -----------------
         when s1 =>
            if (rx_done='1') then
			      if ((ascii_r >= x"41" and ascii_r <= x"5A") or  -- Check for valid ASCII
			       (ascii_r >= x"61" and ascii_r <= x"7A") or 
			           ascii_r = x"20" or ascii_r = x"0D") then
                  wr <= '1'; -- Write enabled RAM
                  
                  if (ascii_r = x"20") then
                     incb_ram <= '1'; -- Increment ram key
                     state_next <= s1;
                     else
                     if (ascii_r=x"0D") then -- X"0D" = "Enter"-key (carriage return)
                        clrb_ram <= '1'; -- Clear ram key
                        state_next <= s2;
                     else
                        inca_rom <= '1';   -- Increment rom key
                        incb_ram <= '1';   -- Increment ram key
                     end if;
				      end if;
               end if;
			   end if;
         -----------------
         -- S2
         -----------------
         when s2 =>
            if (ascii_t=x"0D") then 
			   state_next <= s0;
			else 
			   tx_start <= '1';
			   state_next <= s3;
			end if;
         -----------------
         -- S3
         -----------------
         when s3 =>
            if (tx_done='1') then  
               incb_ram <= '1';
               state_next <= s2;
            end if;

      end case;
   end process;

end arch;