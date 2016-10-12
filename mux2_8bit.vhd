library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_8bit is
    Port ( in0 : in  STD_LOGIC_VECTOR (7 downto 0);
           in1 : in  STD_LOGIC_VECTOR (7 downto 0);
           s : in  STD_LOGIC;
           z : out  STD_LOGIC_VECTOR (7 downto 0));
end mux2_8bit;

architecture Behavioral of mux2_8bit is

begin
z <= in0 after 5ns when s = '0' else
	  in1 after 5ns when s = '1' else
	  "0000000000000000" after 5ns;

end Behavioral;

