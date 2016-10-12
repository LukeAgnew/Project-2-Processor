library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Zero_fill is
    Port ( Zero_fill_input : in  STD_LOGIC_VECTOR (2 downto 0);
           Zero_fill_output : out  STD_LOGIC_VECTOR (15 downto 0));
end Zero_fill;

architecture Behavioral of Zero_fill is

signal intermediary_output : STD_LOGIC_VECTOR(15 downto 0);

begin

intermediary_output(15) <= '0';
intermediary_output(14) <= '0';
intermediary_output(13) <= '0';
intermediary_output(12) <= '0';
intermediary_output(11) <= '0';
intermediary_output(10) <= '0';
intermediary_output(9) <= '0';
intermediary_output(8) <= '0';
intermediary_output(7) <= '0';
intermediary_output(6) <= '0';
intermediary_output(5) <= '0';
intermediary_output(4) <= '0';
intermediary_output(3) <= '0';
intermediary_output(2 downto 0) <= Zero_fill_input;

Zero_fill_output <= intermediary_output;

end Behavioral;

