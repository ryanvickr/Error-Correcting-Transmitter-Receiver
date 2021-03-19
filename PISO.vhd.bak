-- PISO (Parallel in, Serial out) Register
-- By Ryan Vickramasinghe

library IEEE; 

use IEEE.std_logic_1164.all;

entity PISO is

generic ( n : integer := 4);

port( 
	clk: in std_logic; 
	reset: in std_logic; 
	enable: in std_logic; --enables shifting 
	parallel_in: in std_logic_vector(n-1 downto 0); 
	s_out: out std_logic; --serial output
	tx: out std_logic

);

end PISO;

architecture behavioral of PISO is

signal temp_reg: std_logic_vector(n-1 downto 0) := (Others => '0');
TYPE POSSIBLE_STATES IS (waiting, shifting);
signal state : POSSIBLE_STATES;
begin

process(clk,reset)
    variable shift_counter: integer := 0;
begin

   if(reset = '1') then
      temp_reg <= (others => '0');   
      state <= waiting;
      shift_counter := 0;
   elsif(clk'event and clk='1') then
        case state is
            when waiting =>
					tx <= '0';
					s_out <= '0';
					shift_counter := 0;
					
					if(enable = '1') then
						temp_reg <= parallel_in;
						state <= shifting;
					else
						state <= waiting;
					end if;
					
            when shifting =>
					tx <= '1';
					s_out <= temp_reg(shift_counter);
					
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