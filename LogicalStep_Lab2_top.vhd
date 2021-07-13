-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity LogicalStep_Lab2_top is port (
		pb									: in	std_logic_vector(6 downto 0); -- push buttons used for data input selection/operation control
		sw 									: in  std_logic_vector(15 downto 0);-- The switch inputs used for data inputs
		leds									: out std_logic_vector(5 downto 0) 	--  leds for outputs
												); 
end LogicalStep_Lab2_top;

architecture Circuit of LogicalStep_Lab2_top is

-------------------------------------
-- Declare any Components to be Used --
-------------------------------------

 component hex_mux -- Quad-bit 4 to 1 Mux definition
 	port (
			hex_num3, hex_num2, hex_num1, hex_num0 : in std_logic_vector(3 downto 0);
			mux_select 										: in std_logic_vector(1 downto 0); 
			hex_out 										: out std_logic_vector(3 downto 0)
			);
 end component;
 
 component mux_2_in -- Penta-bit 2 to 1 Mux definition
 port (
			num1 				: in std_logic_vector(4 downto 0);
			num0				: in std_logic_vector(4 downto 0);
			mux_sel				: in std_logic; 
			mux_out				: out std_logic_vector(4 downto 0)
			);
end component;
 
 component full_adder_4bit -- 4bit full adder definition
 	port (
			cin			: in std_logic;
			hex_val_A, hex_val_B	: in std_logic_vector(3 downto 0);
			hex_sum 		: out std_logic_vector(3 downto 0);
		  	carry_out		: out std_logic
			);
 end component;

 component logic_proc -- Logical processor definition
 	port (
			logic_in1, logic_in0 	: in std_logic_vector(3 downto 0);
			logic_select  		: in std_logic_vector(1 downto 0); 
			logic_out 		: out std_logic_vector(3 downto 0)
			);
 end component;

---------------------------------------------------------
-- Declare any signals here to be used within the design --
---------------------------------------------------------

---- groups of logic signals with each group defined as std_logic_vector(MSB downto LSB)


-- 5 bit adder and logic final mux inputs
signal Adder_final, Logic_final 		: std_logic_vector(4 downto 0);


-- input operands
signal Operand1, Operand2, Operand3, Operand4 	: std_logic_vector(3 downto 0);


-- Mux A and B outputs and 4-bit adder and logic processor outputs
signal mux_A_out, mux_B_out, Adder_result, Logical_result	: std_logic_vector(3 downto 0);


-- Mux A, B and logical processor mux selectors
signal Operand_Select_A, Operand_Select_B, Logic_Function_Select	: std_logic_vector(1 downto 0);
	
	
-- Final mux selector and 4-bit adder carry bit
signal ALProcessor_Select, Adder_carry	: std_logic ;
-----------------------------------------------------------------
-----------------------------------------------------------------

begin

---- assign (connect) one end of each input group (bus) to sepecific switch inputs

-- Operands connected to set inputs
Operand1 <= sw(3 downto 0);
Operand2 <= sw(7 downto 4);
Operand3 <= sw(11 downto 8);
Operand4 <= sw(15 downto 12);

-- Mux selectors connected to set inputs
Operand_Select_A	<= pb(1 downto 0);
Operand_Select_B 	<= pb(3 downto 2);
Logic_Function_Select 	<= pb(5 downto 4);
ALProcessor_Select 	<= pb(6);


-- Instance of Mux A instance connected with operands and selector 
mux_A: hex_mux port map			(
										hex_num0 => Operand1, hex_num1 => Operand2, hex_num2 => Operand3, hex_num3 => Operand4,
										mux_select => Operand_Select_A,
										hex_out => mux_A_out
										);


-- Instance of Mux B instance connected with operands and selector 										
mux_B: hex_mux port map			(
										hex_num0 => Operand1, hex_num1 => Operand2, hex_num2 => Operand3, hex_num3 => Operand4,
										mux_select => Operand_Select_B,
										hex_out => mux_B_out
										);

										
-- Instance of 4-bit adder connected to the Mux A and B outputs 										
Adder_4_Bit: full_adder_4bit port map	(
													cin => '0', hex_val_A => mux_A_out, hex_val_B => mux_B_out ,
													carry_out => Adder_carry,
													hex_sum => Adder_result(3 downto 0)
													);

													
-- Instance of Logical Processor connected to the Mux A and B outputs													
Logic_Function: logic_proc port map		(
													logic_in0 => mux_A_out, logic_in1 => mux_B_out,
													logic_select => Logic_Function_Select,
													logic_out => Logical_result (3 downto 0)
													);		

-- Adding a bit to the beginning of logic output and the adder carry to the adder output													
Logic_final <= ('0' & Logical_result);	
Adder_final <= ( Adder_carry & Adder_result);				
									
						
-- Instance of Final ALU mux to select between Adder and Logic Processors						
AdderLogic_mux: mux_2_in port map		(
													num0 => Adder_final, num1 => Logic_final,
													mux_sel => ALProcessor_Select,
													mux_out => leds(4 downto 0)
													);
													
-- Connecting 	led 5 with ALU selector												
leds(5) <= (ALProcessor_Select);													
													
end Circuit;

