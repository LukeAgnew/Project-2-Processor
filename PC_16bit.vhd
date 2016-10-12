library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC_16bit is
    Port ( PC_input : in  STD_LOGIC_VECTOR (15 downto 0);
			  PC_reset : in STD_LOGIC;
           PL : in  STD_LOGIC;
           PI : in  STD_LOGIC;
			  Clk : in STD_LOGIC;
           PC_output : out  STD_LOGIC_VECTOR (15 downto 0));
end PC_16bit;

architecture Behavioral of PC_16bit is

COMPONENT reg16 is
	PORT ( D : in  STD_LOGIC_VECTOR (15 downto 0);
          load : in  STD_LOGIC;
          Clk : in  STD_LOGIC;
          Q : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT reg16;

COMPONENT mux2_16bit is
	PORT ( in0 : in  STD_LOGIC_VECTOR (15 downto 0);
          in1 : in  STD_LOGIC_VECTOR (15 downto 0);
          s : in  STD_LOGIC;
          z : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT mux2_16bit;

COMPONENT ripple_carry_adder_16bit is
	PORT ( A : in  STD_LOGIC_VECTOR (15 downto 0);
          B : in  STD_LOGIC_VECTOR (15 downto 0);
          C0 : in  STD_LOGIC;
          S : out  STD_LOGIC_VECTOR (15 downto 0);
          C16 : out  STD_LOGIC);
END COMPONENT ripple_carry_adder_16bit;

signal reg_input : STD_LOGIC_VECTOR(15 downto 0);
signal PC_ADD : STD_LOGIC_VECTOR(15 downto 0);
signal carry_out : STD_LOGIC;
signal PC_Q : STD_LOGIC_VECTOR(15 downto 0);

begin

resetMuxPC : mux2_16bit PORT MAP (
	in0 => PC_input,
	in1 => X"0000",
	s => PC_reset,
	z => reg_input
);

regPC : reg16 PORT MAP (
	D => reg_input,
	load => PL,
	Clk => Clk,
	Q => PC_Q
);

adderPC : ripple_carry_adder_16bit PORT MAP (
	A => PC_Q,
	B => X"0001",
	C0 => '0',
	S => PC_ADD,
	C16 => carry_out
);

muxPC : mux2_16bit PORT MAP (
	in0 => PC_Q,
	in1 => PC_ADD,
	s => PI,
	z => PC_output
);

end Behavioral;

