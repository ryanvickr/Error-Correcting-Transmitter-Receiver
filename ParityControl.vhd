-- Parity Controller (20-bit)
-- By Ryan Vickramasinghe

library IEEE;
use IEEE.std_logic_1164.all;

entity ParityControl is
	port (
		msg: in STD_LOGIC_VECTOR(19 downto 0);
		load: in STD_LOGIC;
		loadOut: out STD_LOGIC;
		pmsg: out STD_LOGIC_VECTOR(24 downto 0)
	);
end ParityControl;

architecture impl of ParityControl is
begin
	process(load)
	begin
		if(load = '1') then
			-- if we are loading, create and push parity bits
			
			pmsg(20) <= msg(0) XOR msg(1) XOR msg(3)
				XOR msg(4) XOR msg(6) XOR msg(8)
				XOR msg(10) XOR msg(11) XOR msg(13)
				XOR msg(15) XOR msg(17);
				
			pmsg(21) <= msg(0) XOR msg(2) XOR msg(3)
				XOR msg(5) XOR msg(6) XOR msg(9)
				XOR msg(10) XOR msg(12) XOR msg(13)
				XOR msg(16) XOR msg(17);
				
			pmsg(22) <= msg(1) XOR msg(2) XOR msg(3)
				XOR msg(7) XOR msg(8) XOR msg(9)
				XOR msg(10) XOR msg(14) XOR msg(15)
				XOR msg(16) XOR msg(17);
				
			pmsg(23) <= msg(3) XOR msg(4) XOR msg(5)
				XOR msg(6) XOR msg(7) XOR msg(8)
				XOR msg(9) XOR msg(10);
				
			pmsg(24) <= msg(11) XOR msg(12) XOR msg(13)
				XOR msg(14) XOR msg(15) XOR msg(16)
				XOR msg(16) XOR msg(17);
			
			-- original message
			pmsg(19 downto 0) <= msg(19 downto 0);
			
			loadOut <= '1';
		else
			loadOut <= '0';
		end if;
	end process;
end impl;