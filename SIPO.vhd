-- SIPO (Serial-In Parallel-Out) Register
-- By: Ryan Vickramasinghe

library IEEE; 
use IEEE.std_logic_1164.all;

entity SIPO is

generic ( n : integer := 4);

port( 
	clk: in std_logic;
	enable: in std_logic; --enables shifting
	s_in: in std_logic; --serial input
	
	parallel_out: out std_logic_vector(n-1 downto 0)
);

end SIPO;

architecture behavioral of SIPO is

signal temp_reg: std_logic_vector(n-1 downto 0) := (Others => '0');
TYPE POSSIBLE_STATES IS (waiting, shifting);
signal state : POSSIBLE_STATES;
begin

process(clk)
    variable shift_counter: integer := 0;
begin

   if(clk'event and clk='1') then
        case state is
            when waiting =>
					shift_counter := 0;
					
					if(enable = '1') then
						state <= shifting;
					else
						state <= waiting;
					end if;
					
            when shifting =>
					parallel_out(shift_counter) <= s_in;
					shift_counter := shift_counter + 1;
					
					if (shift_counter >= n) then
                  state <= waiting;
               else
                  state <= shifting;
               end if;
        end case;
    end if;
end process;

end behavioral;