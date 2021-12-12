----------------------------------------------------------------------------------
-- Cipher
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity cipher is
   Port ( 
         ascii_r : in std_logic_vector (7 downto 0);
         key : in std_logic_vector (7 downto 0);
         dec : in std_logic;
         cphr_out : out std_logic_vector (7 downto 0));
end cipher;
 
architecture arch of cipher is
signal sdin:  unsigned (7 downto 0);
signal skey:  unsigned (7 downto 0);
signal sdout: unsigned (7 downto 0);
signal tempdin: unsigned (7 downto 0);

begin
   -- Input has been converted to lower case if the input is upper case for simplifying the calculation
   sdin <= (unsigned(ascii_r) + x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else -- Converting uppercase character to lowercase
      unsigned(ascii_r); 
   skey <= unsigned(unsigned(key) - 97); -- Position index of key letter
   tempdin <= unsigned(sdin - 97); -- Position index of plain text letter

   sdout <= 
      x"20" when (sdin=x"20") else -- Assign space as output if input is space
      X"0D" when (sdin = X"0D") else 
      ( 97 + ( tempdin + skey ) mod 26 ) when (dec = '0') else  -- Encryption operation (message + key) mod 26
      ( 97 + (( tempdin - skey ) + 26) mod 26 ) when (dec = '1'); -- Decryption operation ((message - key) + 26) mod 26

   -- The output is again converted to upper case if the input was upper case otherwise keep it lowercase
   cphr_out <= std_logic_vector(sdout - x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else -- Converting lowercase character to uppercase for output
       std_logic_vector(sdout);
  
end arch;
