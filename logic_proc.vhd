-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
library ieee;
use ieee.std_logic_1164.all;
library work;

entity logic_proc is
 	port (
			logic_in1, logic_in0 : in std_logic_vector(3 downto 0);
			logic_select 			: in std_logic_vector(1 downto 0); 
			logic_out				: out std_logic_vector(3 downto 0)
			);

 end logic_proc;

 architecture mux_logic_proc of logic_proc is
 
 
 
 begin
 
  -- Creation of the logic process using with select and basic boolean operations
  
 with logic_select (1 downto 0) select 
 logic_out <= 	(logic_in0 AND logic_in1)	when "00", 
					(logic_in0 OR logic_in1) 	when "01",
					(logic_in0 XOR logic_in1) 	when "10",
					(logic_in0 XNOR logic_in1) when "11";
 
 end mux_logic_proc;
 
 