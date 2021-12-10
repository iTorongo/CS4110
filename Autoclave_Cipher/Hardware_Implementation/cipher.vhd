library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity cipher is
   Port ( 
         ascii_r : in STD_LOGIC_VECTOR (7 downto 0);
         key : in STD_LOGIC_VECTOR (7 downto 0);
         dec : in std_logic;
         cphr_out : out STD_LOGIC_VECTOR (7 downto 0));
end cipher;
 
architecture arch of cipher is
signal sdin:  unsigned (7 downto 0);
signal skey:  unsigned (7 downto 0);
signal sdout: unsigned (7 downto 0);
signal tempdin: unsigned (7 downto 0);
signal signed_diff: signed (7 downto 0);

begin
  sdin <= (unsigned(ascii_r) + x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else
   unsigned(ascii_r); 
  skey <= unsigned(unsigned(key) - 97);
  tempdin <= unsigned(sdin - 97); -- index of input plain text
  signed_diff <= signed (tempdin - skey);

   sdout <= 
      x"20" when (sdin=x"20") else
      X"0D" when (sdin = X"0D") else
      
         -- encryption
      ( 97 + ( tempdin + skey ) - 26 ) when (((tempdin + skey) > 25 ) and (dec = '0')) else -- Case when addition is more than 26
      ( 97 + ( tempdin + skey ) ) when (((tempdin + skey) >= 0) and ((tempdin + skey) <= 25) and (dec = '0')) else -- Case when addition is less than or equal to 25
  
         -- decryption
      ( 97 + ( tempdin - skey ) + 26 ) when ((signed_diff < 0 ) and (dec = '1')) else -- Case when subtraction is les than 0
      ( 97 + ( tempdin - skey ) ) when ((signed_diff >= 0 ) and (dec = '1')) else -- Case when subtraction is more than or equal to 0

      sdin;
       
   cphr_out <= std_logic_vector(sdout - x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else
       std_logic_vector(sdout);
  
end arch;
