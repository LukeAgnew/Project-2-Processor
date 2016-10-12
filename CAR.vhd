library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CAR is
    Port ( CAR_input : in  STD_LOGIC_VECTOR (7 downto 0);
			  CAR_reset : in STD_LOGIC;
           CAR_select : in  STD_LOGIC;
			  Clk : in STD_LOGIC;
           CAR_output : out  STD_LOGIC_VECTOR (7 downto 0));
end CAR;

architecture Behavioral of CAR is

COMPONENT ripple_carry_adder_16bit is
	PORT ( A : in  STD_LOGIC_VECTOR (15 downto 0);
          B : in  STD_LOGIC_VECTOR (15 downto 0);
          C0 : in  STD_LOGIC;
          S : out  STD_LOGIC_VECTOR (15 downto 0);
          C16 : out  STD_LOGIC);
END COMPONENT ripple_carry_adder_16bit;

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

signal mux_intermediary : STD_LOGIC_VECTOR (15 downto 0);
signal reg_intermediary : STD_LOGIC_VECTOR (15 downto 0);
signal REG_Q : STD_LOGIC_VECTOR(15 downto 0);
signal ADD_Q : STD_LOGIC_VECTOR(15 downto 0);
signal carry_out : STD_LOGIC_VECTOR;
signal CAR_Q : STD_LOGIC_VECTOR(15 downto 0);

begin

mux_intermediary(15 downto 8) <= X"00";
mux_intermediary(7 downto 0) <= CAR_input;

resetMuxCar : mux2_16bit PORT MAP (
	in0 => mux_intermediary,
	in1 => X"0000",
	s => CAR_reset,
	z => reg_intermediary
);

regCAR : reg16 PORT MAP (
	D => reg_intermediary,
	load => CAR_select,
	Clk => Clk,
	Q => REG_Q
);

adderCAR : ripple_carry_adder_16bit PORT MAP (
	A => REG_Q,
	B => X"0001",
	C0 => '0',
	S => ADD_Q,
	C16 => carry_out
);

muxCAR : mux2_16bit PORT MAP (
	in0 => REG_Q,
	in1 => ADD_Q,
	s => CAR_select,
	z => CAR_Q
);

CAR_output <= CAR_Q(7 downto 0);

end Behavioral;

