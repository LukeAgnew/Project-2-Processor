library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux8_1bit is
    Port ( in0 : in  STD_LOGIC;
           in1 : in  STD_LOGIC;
           in2 : in  STD_LOGIC;
           in3 : in  STD_LOGIC;
           in4 : in  STD_LOGIC;
           in5 : in  STD_LOGIC;
           in6 : in  STD_LOGIC;
           in7 : in  STD_LOGIC;
           s0 : in  STD_LOGIC;
			  s1 : in STD_LOGIC;
			  S2 : in STD_LOGIC;
           z : out  STD_LOGIC);
end mux8_1bit;

architecture Behavioral of mux8_1bit is

begin
z <= in0 after 5ns when s0 = '0' and s1 = '0' and s2 = '0' else
	  in1 after 5ns when s0 = '0' and s1 = '0' and s2  = '1' else
	  in2 after 5ns when s0 = '0' and s1 = '1' and s2  = '0' else
	  in3 after 5ns when s0 = '0' and s1 = '1' and s2 = '1' else
	  in4 after 5ns when s0 = '1' and s1 = '0' and s2 = '0' else
	  in5 after 5ns when s0 = '1' and s1 = '0' and s2 = '1' else
	  in6 after 5ns when s0 = '1' and s1 = '1' and s2 = '0' else
	  in7 after 5ns when s0 = '1' and s1 = '1' and s2 = '1' else
	  "0000000000000000" after 5ns;

end Behavioral;

