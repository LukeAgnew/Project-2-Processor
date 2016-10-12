library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IR_16bit is
    Port ( IR_input : in  STD_LOGIC_VECTOR (15 downto 0);
           IL : in  STD_LOGIC;
			  Clk : in STD_LOGIC;
           Opcode : out  STD_LOGIC_VECTOR (6 downto 0);
           DR : out  STD_LOGIC_VECTOR (2 downto 0);
           SA : out  STD_LOGIC_VECTOR (2 downto 0);
           SB : out  STD_LOGIC_VECTOR (2 downto 0));
end IR_16bit;

architecture Behavioral of IR_16bit is

COMPONENT reg16 is
	PORT ( D : in  STD_LOGIC_VECTOR (15 downto 0);
          load : in  STD_LOGIC;
          Clk : in  STD_LOGIC;
          Q : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT reg16;

signal IR_Q : STD_LOGIC_VECTOR (15 downto 0);

begin

regIR : reg16 PORT MAP (
	D =>	IR_input,
	load => IL,
	Clk => Clk,
	Q => IR_Q
);

Opcode <= IR_Q(15 downto 9);
DR <= IR_Q(8 downto 6);
SA <= IR_Q(5 downto 3);
SB <= IR_Q(2 downto 0);

end Behavioral;

