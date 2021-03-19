-- SIPO (Serial-in, Parallel-out) Register
-- By: Ryan Vickramasinghe

library ieee; 
use ieee.std_logic_1164.all;

entity SIPO is

generic ( n : integer := 4);

port( 
	clk: in std_logic; 
	reset: in std_logic; 
	rx: in std_logic; --enables shifting 
	s_in: in std_logic; --serial input
		
	parallel_out: out std_logic_vector(n-1 downto 0);  --parallel out
	done: out std_logic
);
end SIPO;

architecture behavioral of SIPO is

begin

process(clk,reset)
	variable tempReg: std_logic_vector(n-1 downto 0);
   variable i: integer := 0;
begin

   if (reset = '1') then
		tempReg := (others => '0');
		parallel_out <= (others => '0');
		done <= '0';
		i := 0;
	elsif (clk'event and clk = '1' and rx = '1') then
		tempReg(i) := s_in;
		done <= '0';
		i := i + 1;
	elsif (clk'event and clk = '1' and rx = '0') then
		parallel_out <= tempReg;
		done <= '1';
		i := 0;
	end if;
end process;

end behavioral;