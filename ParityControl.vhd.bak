-- Parity Controller (20-bit)
-- By Ryan Vickramasinghe

library IEEE;
use IEEE.std_logic_1164.all;

entity ParityControl is
	port (
		msgIn: in STD_LOGIC_VECTOR(19 downto 0);
		load: in STD_LOGIC;
		parOut: out STD_LOGIC_VECTOR(4 downto 0)
	);
end ParityControl;

architecture impl of ParityControl is
begin
	process(load)
	begin
		if(load = '1') then
			-- if we are loading, create and push parity bits
			
			parOut(0) <= msgIn(0) XOR msgIn(1) XOR msgIn(3)
				XOR msgIn(4) XOR msgIn(6) XOR msgIn(8)
				XOR msgIn(10) XOR msgIn(11) XOR msgIn(13)
				XOR msgIn(15) XOR msgIn(17);
				
			parOut(1) <= msgIn(0) XOR msgIn(2) XOR msgIn(3)
				XOR msgIn(5) XOR msgIn(6) XOR msgIn(9)
				XOR msgIn(10) XOR msgIn(12) XOR msgIn(13)
				XOR msgIn(16) XOR msgIn(17);
				
			parOut(2) <= msgIn(1) XOR msgIn(2) XOR msgIn(3)
				XOR msgIn(7) XOR msgIn(8) XOR msgIn(9)
				XOR msgIn(10) XOR msgIn(14) XOR msgIn(15)
				XOR msgIn(16) XOR msgIn(17);
				
			parOut(3) <= msgIn(3) XOR msgIn(4) XOR msgIn(5)
				XOR msgIn(6) XOR msgIn(7) XOR msgIn(8)
				XOR msgIn(9) XOR msgIn(10);
				
			parOut(4) <= msgIn(11) XOR msgIn(12) XOR msgIn(13)
				XOR msgIn(14) XOR msgIn(15) XOR msgIn(16)
				XOR msgIn(16) XOR msgIn(17);
		else
			-- not loading, clear output
			parOut <= "00000";
		end if;
	end process;
end impl;