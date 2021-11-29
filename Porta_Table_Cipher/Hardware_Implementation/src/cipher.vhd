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

begin
   sdin <= (unsigned(ascii_r) + x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else
    unsigned(ascii_r);    
   skey <= unsigned(key);
    -- TODO: Need to add equation to simplify and refactor
   sdout <= -- case of space:
         x"20" when (sdin=x"20") else
        -- in case of key A or B
        (sdin + 13) when (((sdin >= x"61") and (sdin <= x"6D")) and ((skey >= x"61") and (skey <= x"62"))) else
        (sdin - 13) when (((sdin > x"6D") and (sdin <= x"7A")) and ((skey >= x"61") and (skey <= x"62"))) else
        
        -- in case of key C or D
        -- for A and Z
        (sdin + 25) when (((sdin = x"61") and (sdin = x"7A")) and ((skey >= x"63") and (skey <= x"64"))) else
        (sdin - 25) when (((sdin = x"61") and (sdin = x"7A")) and ((skey >= x"63") and (skey <= x"64"))) else
        -- for others
        (sdin + 12) when (((sdin >= x"62") and (sdin <= x"6D")) and ((skey >= x"63") and (skey <= x"64"))) else
        (sdin - 12) when (((sdin > x"6D") and (sdin <= x"79")) and ((skey >= x"63") and (skey <= x"64"))) else
            

        -- in case of key E or F
        -- for A,B,Y,Z
        (sdin + 24) when (((sdin >= x"61") and (sdin <= x"62")) and ((skey >= x"65") and (skey <= x"66"))) else
        (sdin - 24) when (((sdin >= x"79") and (sdin <= x"7A")) and ((skey >= x"65") and (skey <= x"66"))) else
        -- for others
        (sdin + 11) when (((sdin >= x"63") and (sdin <= x"6D")) and ((skey >= x"65") and (skey <= x"66"))) else
        (sdin - 11) when (((sdin > x"6D") and (sdin <= x"78")) and ((skey >= x"65") and (skey <= x"66"))) else

        -- in case of key G or H
        -- for A,B,C,X,Y,Z
        (sdin + 23) when (((sdin >= x"61") and (sdin <= x"63")) and ((skey >= x"67") and (skey <= x"68"))) else
        (sdin - 23) when (((sdin >= x"78") and (sdin <= x"7A")) and ((skey >= x"67") and (skey <= x"68"))) else
        -- for others
        (sdin + 10) when (((sdin >= x"64") and (sdin <= x"6D")) and ((skey >= x"67") and (skey <= x"68"))) else
        (sdin - 10) when (((sdin > x"6D") and (sdin <= x"77")) and ((skey >= x"67") and (skey <= x"68"))) else

        -- in case of key I or J
        -- for A,B,C,D,W,X,Y,Z
        (sdin + 22) when (((sdin >= x"61") and (sdin <= x"64")) and ((skey >= x"69") and (skey <= x"6A"))) else
        (sdin - 22) when (((sdin >= x"77") and (sdin <= x"7A")) and ((skey >= x"69") and (skey <= x"6A"))) else
        -- for others
        (sdin + 9) when (((sdin >= x"65") and (sdin <= x"6D")) and ((skey >= x"69") and (skey <= x"6A"))) else
        (sdin - 9) when (((sdin > x"6D") and (sdin <= x"76")) and ((skey >= x"69") and (skey <= x"6A"))) else

        -- in case of key K or L
        -- for A,B,C,D,E,V,W,X,Y,Z
        (sdin + 21) when (((sdin >= x"61") and (sdin <= x"65")) and ((skey >= x"6B") and (skey <= x"6C"))) else
        (sdin - 21) when (((sdin >= x"76") and (sdin <= x"7A")) and ((skey >= x"6B") and (skey <= x"6C"))) else
        -- for others
        (sdin + 8) when (((sdin >= x"66") and (sdin <= x"6D")) and ((skey >= x"6B") and (skey <= x"6C"))) else
        (sdin - 8) when (((sdin > x"6D") and (sdin <= x"75")) and ((skey >= x"6B") and (skey <= x"6C"))) else

        -- in case of key M or N
        -- for A,B,C,D,E,F,U,V,W,X,Y,Z
        (sdin + 20) when (((sdin >= x"61") and (sdin <= x"66")) and ((skey >= x"6D") and (skey <= x"6E"))) else
        (sdin - 20) when (((sdin >= x"75") and (sdin <= x"7A")) and ((skey >= x"6D") and (skey <= x"6E"))) else
        -- for others
        (sdin + 7) when (((sdin >= x"67") and (sdin <= x"6D")) and ((skey >= x"6D") and (skey <= x"6E"))) else
        (sdin - 7) when (((sdin > x"6D") and (sdin <= x"74")) and ((skey >= x"6D") and (skey <= x"6E"))) else

        -- in case of key O or P
        -- for A,B,C,D,E,F,G,T,U,V,W,X,Y,Z
        (sdin + 19) when (((sdin >= x"61") and (sdin <= x"67")) and ((skey >= x"6F") and (skey <= x"70"))) else
        (sdin - 19) when (((sdin >= x"74") and (sdin <= x"7A")) and ((skey >= x"6F") and (skey <= x"70"))) else
        -- for others
        (sdin + 6) when (((sdin >= x"68") and (sdin <= x"6D")) and ((skey >= x"6F") and (skey <= x"70"))) else
        (sdin - 6) when (((sdin > x"6D") and (sdin <= x"73")) and ((skey >= x"6F") and (skey <= x"70"))) else

        -- in case of key Q or R
        -- for A,B,C,D,E,F,G,H,S,T,U,V,W,X,Y,Z
        (sdin + 18) when (((sdin >= x"61") and (sdin <= x"68")) and ((skey >= x"71") and (skey <= x"72"))) else
        (sdin - 18) when (((sdin >= x"73") and (sdin <= x"7A")) and ((skey >= x"71") and (skey <= x"72"))) else
        -- for others
        (sdin + 5) when (((sdin >= x"69") and (sdin <= x"6D")) and ((skey >= x"71") and (skey <= x"72"))) else
        (sdin - 5) when (((sdin > x"6D") and (sdin <= x"72")) and ((skey >= x"71") and (skey <= x"72"))) else

        -- in case of key S or T
        -- for A,B,C,D,E,F,G,H,I,R,S,T,U,V,W,X,Y,Z
        (sdin + 17) when (((sdin >= x"61") and (sdin <= x"69")) and ((skey >= x"73") and (skey <= x"74"))) else
        (sdin - 17) when (((sdin >= x"72") and (sdin <= x"7A")) and ((skey >= x"73") and (skey <= x"74"))) else
        -- for others
        (sdin + 4) when (((sdin >= x"6A") and (sdin <= x"6D")) and ((skey >= x"73") and (skey <= x"74"))) else
        (sdin - 4) when (((sdin > x"6D") and (sdin <= x"71")) and ((skey >= x"73") and (skey <= x"74"))) else

        -- in case of key U or V
        -- for A,B,C,D,E,F,G,H,I,J,Q,R,S,T,U,V,W,X,Y,Z
        (sdin + 16) when (((sdin >= x"61") and (sdin <= x"6A")) and ((skey >= x"75") and (skey <= x"76"))) else
        (sdin - 16) when (((sdin >= x"71") and (sdin <= x"7A")) and ((skey >= x"75") and (skey <= x"76"))) else
        -- for others
        (sdin + 3) when (((sdin >= x"6B") and (sdin <= x"6D")) and ((skey >= x"75") and (skey <= x"76"))) else
        (sdin - 3) when (((sdin > x"6D") and (sdin <= x"70")) and ((skey >= x"75") and (skey <= x"76"))) else

        -- in case of key W or X
        -- for A,B,C,D,E,F,G,H,I,J,K,P,Q,R,S,T,U,V,W,X,Y,Z
        (sdin + 15) when (((sdin >= x"61") and (sdin <= x"6B")) and ((skey >= x"77") and (skey <= x"78"))) else
        (sdin - 15) when (((sdin >= x"6E") and (sdin <= x"7A")) and ((skey >= x"77") and (skey <= x"78"))) else
        -- for others
        (sdin + 2) when (((sdin >= x"6C") and (sdin <= x"6D")) and ((skey >= x"77") and (skey <= x"78"))) else
        (sdin - 2) when (((sdin > x"6D") and (sdin <= x"6F")) and ((skey >= x"77") and (skey <= x"78"))) else

        -- in case of key Y or Z
        -- for A,B,C,D,E,F,G,H,I,J,K,L,O,P,Q,R,S,T,U,V,W,X,Y,Z
        (sdin + 14) when (((sdin >= x"61") and (sdin <= x"6C")) and ((skey >= x"79") and (skey <= x"7A"))) else
        (sdin - 14) when (((sdin >= x"6F") and (sdin <= x"7A")) and ((skey >= x"79") and (skey <= x"7A"))) else
        -- for others
        (sdin + 1) when ((sdin = x"6D") and ((skey >= x"79") and (skey <= x"7A"))) else
        (sdin - 1) when ((sdin = x"6E") and ((skey >= x"79") and (skey <= x"7A"))) else

        sdin;

         
    cphr_out <= std_logic_vector(sdout - x"20") when ((unsigned(ascii_r) >= x"41") and (unsigned(ascii_r) <= x"5A")) else
        std_logic_vector(sdout);
    
end arch;