library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity cipher is
   Port ( ascii_r : in STD_LOGIC_VECTOR (7 downto 0);
          key : in STD_LOGIC_VECTOR (7 downto 0);
          cphr_out : out STD_LOGIC_VECTOR (7 downto 0));
end cipher;
 
architecture arch of cipher is
signal sdin:  unsigned (7 downto 0);
signal skey:  unsigned (7 downto 0);
signal sdout: unsigned (7 downto 0);
signal tempdin: unsigned (7 downto 0);
signal calculated_mod: unsigned (7 downto 0);
signal signed_difference: signed (7 downto 0);

 
begin
  sdin <= (unsigned(ascii_r) + x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else
   unsigned(ascii_r); 
  skey <= unsigned(unsigned(key) - 97);
  tempdin <= unsigned(sdin - 97); -- index of input plain text
  signed_difference <= signed(tempdin - (skey/2));
  calculated_mod <= (unsigned(signed_difference) mod 13) when (signed_difference > 0) else 
   (unsigned(signed_difference) + 13);



   sdout <= 
      x"20" when (sdin=x"20") else
      (97 + (unsigned( 13 + calculated_mod ))) when (tempdin < 13) else 
      (97 + unsigned((tempdin + (skey/2)) mod 13)) when ((tempdin >= 13) and (tempdin <= 25)) else 
      sdin;
       
   cphr_out <= std_logic_vector(sdout - x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else
       std_logic_vector(sdout);
  
end arch;
