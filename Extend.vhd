library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Extend is
    Port ( Extend_input : in  STD_LOGIC_VECTOR (5 downto 0);
           Extend_output : out  STD_LOGIC_VECTOR (15 downto 0));
end Extend;

architecture Behavioral of Extend is

signal intermediary_output : STD_LOGIC_VECTOR (15 downto 0);

begin

intermediary_output(15) <= Extend_input(5); 
intermediary_output(14) <= Extend_input(5); 
intermediary_output(13) <= Extend_input(5); 
intermediary_output(12) <= Extend_input(5); 
intermediary_output(11) <= Extend_input(5); 
intermediary_output(10) <= Extend_input(5); 
intermediary_output(9) <= Extend_input(5); 
intermediary_output(8) <= Extend_input(5); 
intermediary_output(7) <= Extend_input(5); 
intermediary_output(6) <= Extend_input(5); 
intermediary_output(5 downto 0) <= Extend_input;

Extend_output <= intermediary_output;

end Behavioral;

