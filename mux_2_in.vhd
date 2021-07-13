-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2_in is

    Port ( mux_sel 	: in  STD_LOGIC;
           num1  		: in  STD_LOGIC_VECTOR (4 downto 0);
           num0  		: in  STD_LOGIC_VECTOR (4 downto 0);
           mux_out 	: out STD_LOGIC_VECTOR (4 downto 0)
			 );
			  
end mux_2_in;

architecture mux_2 of mux_2_in is

begin

 -- Creation of the mux process using with select
 with mux_sel select 
 mux_out <= num0 when '0', 
				num1 when '1';
	 
end mux_2;