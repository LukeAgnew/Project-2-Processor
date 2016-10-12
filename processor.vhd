library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity processor is
    Port (	
				PR : in STD_LOGIC;
				CR : in STD_LOGIC;
				Clk : in STD_LOGIC
			);
end processor;

architecture Behavioral of processor is

COMPONENT datapath
PORT (
			  src_s0_A : in  STD_LOGIC;
           src_s1_A : in  STD_LOGIC;
           src_s2_A : in  STD_LOGIC;
			  src_s3_A : in  STD_LOGIC;
           src_s0_B : in  STD_LOGIC;
           src_s1_B : in  STD_LOGIC;
           src_s2_B : in  STD_LOGIC;
			  src_s3_B : in  STD_LOGIC;
           des_A0 : in  STD_LOGIC;
           des_A1 : in  STD_LOGIC;
           des_A2 : in  STD_LOGIC;
			  des_A3 : in STD_LOGIC;
           Clk : in  STD_LOGIC;
           load_write : in  STD_LOGIC;
			  constant_in : in STD_LOGIC_VECTOR(15 downto 0);
			  MBselect : in STD_LOGIC;
			  FSInput : in STD_LOGIC_VECTOR (4 downto 0);
			  data_in : in STD_LOGIC_VECTOR (15 downto 0);
			  MDselect : in STD_LOGIC;
			  V : out STD_LOGIC;
			  C : out STD_LOGIC;
			  N : out STD_LOGIC;
			  Z : out STD_LOGIC;
			  address_out : out STD_LOGIC_VECTOR (15 downto 0);
			  data_out : out STD_LOGIC_VECTOR (15 downto 0)
		);
END COMPONENT datapath;

COMPONENT control_memory_16bit is
    Port ( MW : out  STD_LOGIC;
           MM : out  STD_LOGIC;
           RW : out  STD_LOGIC;
           MD : out  STD_LOGIC;
           FS : out  STD_LOGIC_VECTOR (4 downto 0);
           MB : out  STD_LOGIC;
           TB : out  STD_LOGIC;
           TA : out  STD_LOGIC;
           TD : out  STD_LOGIC;
           PL : out  STD_LOGIC;
           PI : out  STD_LOGIC;
           IL : out  STD_LOGIC;
           MC : out  STD_LOGIC;
           MS : out  STD_LOGIC_VECTOR (2 downto 0);
           NA : out  STD_LOGIC_VECTOR (7 downto 0);
           IN_CAR : in  STD_LOGIC_VECTOR (7 downto 0));
END COMPONENT control_memory_16bit;

COMPONENT memory_m_16bit is
    Port ( address : in  unsigned STD_LOGIC_VECTOR (15 downto 0);
           write_data : in  STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC; 
			  MemRead : in  STD_LOGIC;
			  Clk : in STD_LOGIC;
           read_data : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT memory_m_16bit;

COMPONENT PC_16bit is
    Port ( PC_input : in  STD_LOGIC_VECTOR (15 downto 0);
			  PC_reset : in STD_LOGIC_VECTOR (15 downto 0);
           PL : in  STD_LOGIC;
           PI : in  STD_LOGIC;
			  Clk : in STD_LOGIC;
           PC_output : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT PC_16bit;

COMPONENT IR_16bit is
    Port ( IR_input : in  STD_LOGIC_VECTOR (15 downto 0);
           IL : in  STD_LOGIC;
			  Clk : in STD_LOGIC;
           Opcode : out  STD_LOGIC_VECTOR (6 downto 0);
           DR : out  STD_LOGIC_VECTOR (2 downto 0);
           SA : out  STD_LOGIC_VECTOR (2 downto 0);
           SB : out  STD_LOGIC_VECTOR (2 downto 0));
END COMPONENT IR_16bit;

COMPONENT CAR is
    Port ( CAR_input : in  STD_LOGIC_VECTOR (7 downto 0);
			  CAR_reset : in STD_LOGIC;
           CAR_select : in  STD_LOGIC;
			  Clk : in STD_LOGIC;
           CAR_output : out  STD_LOGIC_VECTOR (7 downto 0));
END COMPONENT CAR;

COMPONENT mux8_1bit is
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
END COMPONENT mux8_1bit;

COMPONENT mux2_8bit is
    Port ( in0 : in  STD_LOGIC_VECTOR (7 downto 0);
           in1 : in  STD_LOGIC_VECTOR (7 downto 0);
           s : in  STD_LOGIC;
           z : out  STD_LOGIC_VECTOR (7 downto 0));
END COMPONENT mux2_8bit;

COMPONENT mux2_16bit is
    Port ( in0 : in  STD_LOGIC_VECTOR (15 downto 0);
           in1 : in  STD_LOGIC_VECTOR (15 downto 0);
           s : in  STD_LOGIC;
           z : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT mux2_8bit;

COMPONENT Extend is
	Port ( Extend_input : in  STD_LOGIC_VECTOR (5 downto 0);
          Extend_output : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT Extend;

COMPONENT Zero_fill is
	Port ( Zero_fill_input : in  STD_LOGIC_VECTOR (2 downto 0);
          Zero_fill_output : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT Zero_fill;
	
signal intermediary_data_out, intermediary_address_out : STD_LOGIC_VECTOR (15 downto 0);
signal intermediary_MUX_C, intermediary_CAR_out : STD_LOGIC_VECTOR (7 downto 0);
signal intermediary_MUX_S : STD_LOGIC_VECTOR;
signal intermediary_condition_code_flags : STD_LOGIC_VECTOR (3 downto 0);
signal intermediary_read_data : STD_LOGIC_VECTOR (15 downto 0);
signal intermediary_extend_out : STD_LOGIC_VECTOR (15 downto 0);
signal intermediary_PC_out : STD_LOGIC_VECTOR (15 downto 0);
signal intermediary_opcode : STD_LOGIC_VECTOR (6 downto 0);
signal intermediary_zero_out : STD_LOGIC_VECTOR (15 downto 0);
signal intermediary_NA : STD_LOGIC_VECTOR (7 downto 0);
signal intermediary_AA, intermediary_BA, intermediary_DA : STD_LOGIC_VECTOR (3 downto 0);
signal intermediary_MW, intermediary_MM, intermediary_RW, intermediary_MD, intermediary_MB, 
	intermediary_TB, intermediary_TA, intermediary_TD, intermediary_PL, intermediary_PI, 
	intermediary_IL,intermediary_MC : STD_LOGIC; 
signal intermediary_FS : STD_LOGIC_VECTOR (4 downto 0);	
signal intermediary_MS : STD_LOGIC_VECTOR (2 downto 0);
signal intermediary_NA, intermediary_CAR_out : STD_LOGIC_VECTOR (7 downto 0);
    
begin

processor_datapath : datapath PORT MAP (
	src_s0_A => intermediary_AA(0),
   src_s1_A => intermediary_AA(1),
   src_s2_A => intermediary_AA(2),
	src_s3_A => intermediary_AA(3),
   src_s0_B => intermediary_BA(0),
   src_s1_B => intermediary_BA(1),
   src_s2_B => intermediary_BA(2),
	src_s3_B => intermediary_BA(3),
   des_A0 =>  intermediary_DA(0),
   des_A1 => intermediary_DA(1),
   des_A2 => intermediary_DA(2),
	des_A3 =>  intermediary_DA(3),
   Clk => Clk,
   load_write => intermediary_RW,
	constant_in => intermediary_zero_out,
	MBselect => intermediary_MB,
	FSInput => intermediary_FS,
	data_in => intermediary_read_data,
	MDselect => intermediary_MD,
	V => intermediary_condition_code_flags(0),
	C => intermediary_condition_code_flags(1),
	N => intermediary_condition_code_flags(2),
	Z => intermediary_condition_code_flags(3),
	address_out => intermediary_address_out,
	data_out => intermediary_data_out
);

processor_control : control_memory_16bit PORT MAP (
	MW => intermediary_MW,
   MM => intermediary_MM,
   RW => intermediary_RW,
   MD => intermediary_MD,
   FS => intermediary_FS,
   MB => intermediary_MB,
   TB => intermediary_BA(3),
   TA => intermediary_AA(3),
   TD => intermediary_DA(3),
   PL => intermediary_PL,
   PI => intermediary_PI,
   IL => intermediary_IL,
   MC => intermediary_MC,
   MS => intermediary_MS,
   NA => intermediary_NA,
   IN_CAR => intermediary_CAR_out

);

processor_memory_m : memory_m_16bit PORT MAP (
	address => intermediary_address_out,
   write_data => intermediary_data_out,
   MemWrite => intermediary_MW,
	MemRead => MR,
	Clk => Clk,
   read_data => intermediary_read_data

);

processor_PC : PC_16bit PORT MAP (
	PC_input =>  intermediary_extend_out,
	PC_reset => PR,
   PL => intermediary_PL,
	PI => intermediary_PI,
	Clk => Clk,
	PC_output => intermediary_PC_out
	
);

processor_IR : IR_16bit PORT MAP (
	IR_input => intermediary_read_data,
	IL => intermediary_IL,
	Clk => Clk,
	Opcode => intermediary_opcode, 
	DR => intermediary_DA(2 downto 0),
	SA => intermediary_AA(2 downto 0),
	SB => intermediary_BA(2 downto 0)

);

processor_CAR : CAR PORT MAP (
	CAR_input => intermediary_MUX_C,
	CAR_reset => CR,
	CAR_select => intermediary_MUX_S,
	Clk => Clk,
	CAR_output => intermediary_CAR_out
	
);

processor_MUX_S : mux8_1bit PORT MAP (
	in0 => '0',
	in1 => '1',
	in2 => intermediary_condition_code_flags(1),
	in3 => intermediary_condition_code_flags(0),
	in4 => intermediary_condition_code_flags(3),
	in5 => intermediary_condition_code_flags(2),
	in6 => not (intermediary_condition_code_flags(1)),
	in7 => not (intermediary_condition_code_flags(3)),
	s0 => intermediary_MS(0),
	s1 => intermediarly_MS(1),
	S2 => intermediary_MS(2),
   z => intermediary_MUX_S
	
);

processor_MUX_C : mux2_8bit PORT MAP (
	in0 => intermediary_NA,
	in1 => intermediary_opcode,
	s => intermediary_MC,
	z => intermediary_MUX_C

);

processor_MUX_M : mux2_16bit PORT MAP (
	in0 => intermediary_address_out,
	in1 => intermediary_PC_out,
	s => intermediary_MM,
	z => intermediary_address_out

);

processor_Extend : Extend PORT MAP (
	Extend_input => intermediary_extend_in,
	Extend_output => intermediary_extend_out

);

processor_Zero_fill : Zero_fill PORT MAP (
	Zero_fill_input => intermediary_zero_in,
	Zero_fill_output => intermediary_zero_out

);

end Behavioral;

