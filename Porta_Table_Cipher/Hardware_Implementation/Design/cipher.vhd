----------------------------------------------------------------------------------
-- Cipher
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity cipher is
   Port ( ascii_r : in std_logic_vector (7 downto 0);
          key : in std_logic_vector (7 downto 0);
          cphr_out : out std_logic_vector (7 downto 0));
end cipher;
 
architecture arch of cipher is
signal sdin:  unsigned (7 downto 0);
signal skey:  unsigned (7 downto 0);
signal sdout: unsigned (7 downto 0);
signal tempdin: unsigned (7 downto 0);
signal calculated_mod: unsigned (7 downto 0);
signal signed_difference: signed (7 downto 0);

 
begin
  
   sdin <= (unsigned(ascii_r) + x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else  -- Input has been converted to lower case if the input is upper case for simplifying the calculation
      unsigned(ascii_r); 
   skey <= unsigned(unsigned(key) - 97); -- Position index of key letter
   tempdin <= unsigned(sdin - 97); -- Position index of input plain letter
   signed_difference <= signed(tempdin - (skey/2)); -- Storing the signed value for difference as the different value can be negative
   calculated_mod <= (unsigned(signed_difference) mod 13) when (signed_difference > 0) else 
      (unsigned(signed_difference) + 13);


   sdout <= 
      x"20" when (sdin=x"20") else -- Assign space as output if input is space
      (97 + (unsigned( 13 + calculated_mod ))) when (tempdin < 13) else  -- If input position index is less than 13 then, 13+ (message −(key/2)) mod13
      (97 + unsigned((tempdin + (skey/2)) mod 13)) when ((tempdin >= 13) and (tempdin <= 25)) else  -- If input position index is not less than 13 and greater than 25 then, message + (key/2)) mod13
         sdin;

   cphr_out <= std_logic_vector(sdout - x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else -- The output is again converted to upper case if the input was upper case otherwise keep it lowercase
       std_logic_vector(sdout);
  
end arch;
