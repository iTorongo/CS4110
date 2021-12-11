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

begin
  sdin <= (unsigned(ascii_r) + x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else
   unsigned(ascii_r); 
  skey <= unsigned(unsigned(key) - 97);
  tempdin <= unsigned(sdin - 97); -- index of input plain text

   sdout <= 
      x"20" when (sdin=x"20") else
      X"0D" when (sdin = X"0D") else

      -- encryption
      ( 97 + ( tempdin + skey ) mod 26 ) when (dec = '0') else 
      ( 97 + (( tempdin - skey ) + 26) mod 26 ) when (dec = '1');

   cphr_out <= std_logic_vector(sdout - x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else
       std_logic_vector(sdout);
  
end arch;
