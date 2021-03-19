-- ErrorCorrectionControl
-- By: Ryan Vickramasinghe

library IEEE; 
use IEEE.std_logic_1164.all;

use IEEE.numeric_std.to_integer;
use IEEE.numeric_std.unsigned;

entity ErrorCorrectionControl is

port (
	msgIn: in std_logic_vector(24 downto 0);
	ready: in std_logic;
	
	msgOut: out std_logic_vector(19 downto 0); -- output msg
	tbe: out std_logic -- 2-bit error
);

end ErrorCorrectionControl;

architecture impl of ErrorCorrectionControl is
begin
	process(ready) is
		VARIABLE errorLoc: integer := 0;
		
		VARIABLE tbError: STD_LOGIC := '0';
		
		VARIABLE checkBits: STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
		VARIABLE correctedMsg: STD_LOGIC_VECTOR(19 downto 0) := (others => '0');
		
		-- convert format of parity message
		VARIABLE parityMsg : STD_LOGIC_VECTOR(24 downto 0) := ( 
			0 => msgIn(20), 1 => msgIn(21), 2 => msgIn(0), 3 => msgIn(22),
			4 => msgIn(1), 5 => msgIn(2), 6 => msgIn(3), 7 => msgIn(23),
			8 => msgIn(4), 9 => msgIn(5), 10 => msgIn(6), 11 => msgIn(7),
			12 => msgIn(8), 13 => msgIn(9), 14 => msgIn(10), 15 => msgIn(24),
			16 => msgIn(11), 17 => msgIn(12), 18 => msgIn(13), 19 => msgIn(14),
			20 => msgIn(15), 21 => msgIn(16), 22 => msgIn(17), 23 => msgIn(18),
			24 => msgIn(19), others => '0'
		);
	begin
		if(ready = '1') then
		
			parityMsg := ( 
				0 => msgIn(20), 1 => msgIn(21), 2 => msgIn(0), 3 => msgIn(22),
				4 => msgIn(1), 5 => msgIn(2), 6 => msgIn(3), 7 => msgIn(23),
				8 => msgIn(4), 9 => msgIn(5), 10 => msgIn(6), 11 => msgIn(7),
				12 => msgIn(8), 13 => msgIn(9), 14 => msgIn(10), 15 => msgIn(24),
				16 => msgIn(11), 17 => msgIn(12), 18 => msgIn(13), 19 => msgIn(14),
				20 => msgIn(15), 21 => msgIn(16), 22 => msgIn(17), 23 => msgIn(18),
				24 => msgIn(19), others => '0'
			);
			
			-- create our check bits
			checkBits(0) := msgIn(20) XOR msgIn(0) XOR msgIn(1) XOR msgIn(3)
				XOR msgIn(4) XOR msgIn(6) XOR msgIn(8)
				XOR msgIn(10) XOR msgIn(11) XOR msgIn(13)
				XOR msgIn(15) XOR msgIn(17);
				
			checkBits(1) := msgIn(21) XOR msgIn(0) XOR msgIn(2) XOR msgIn(3)
				XOR msgIn(5) XOR msgIn(6) XOR msgIn(9)
				XOR msgIn(10) XOR msgIn(12) XOR msgIn(13)
				XOR msgIn(16) XOR msgIn(17);
				
			checkBits(2) := msgIn(22) XOR msgIn(1) XOR msgIn(2) XOR msgIn(3)
				XOR msgIn(7) XOR msgIn(8) XOR msgIn(9)
				XOR msgIn(10) XOR msgIn(14) XOR msgIn(15)
				XOR msgIn(16) XOR msgIn(17);
				
			checkBits(3) := msgIn(23) XOR msgIn(3) XOR msgIn(4) XOR msgIn(5)
				XOR msgIn(6) XOR msgIn(7) XOR msgIn(8)
				XOR msgIn(9) XOR msgIn(10);
				
			checkBits(4) := msgIn(24) XOR msgIn(11) XOR msgIn(12) XOR msgIn(13)
				XOR msgIn(14) XOR msgIn(15) XOR msgIn(16)
				XOR msgIn(16) XOR msgIn(17);
				
			-- calculate error position
			errorLoc := to_integer(unsigned(checkBits));
			
			tbError := checkBits(0) XOR checkBits(1) XOR checkBits(2)
				XOR checkBits(3) XOR checkBits(4);
				
			if tbError = '1' then -- 2-bit error
				tbe <= '1';
				msgOut <= msgIn(19 downto 0);
			elsif errorLoc = 0 then -- no error
				tbe <= '0';
				msgOut <= msgIn(19 downto 0);
			elsif errorLoc > 0 then -- 1-bit error, correctable
				parityMsg(errorLoc) := not parityMsg(errorLoc);
				msgOut <= (
					0 => parityMsg(2), 1 => parityMsg(4), 2 => parityMsg(5), 
					3 => parityMsg(6), 4 => parityMsg(8), 5 => parityMsg(9), 
					6 => parityMsg(10), 7 => parityMsg(11), 8 => parityMsg(12),
					
					9 => parityMsg(13), 10 => parityMsg(14), 11 => parityMsg(16), 
					12 => parityMsg(17), 13 => parityMsg(18), 14 => parityMsg(19), 
					15 => parityMsg(20), 16 => parityMsg(21), 17 => parityMsg(22), 
					18 => parityMsg(23), 19 => parityMsg(24)
				);
			end if;
		else
			-- not receiving, clear output and reset
			errorLoc := 0;
			correctedMsg := (others => '0');
			checkBits := (others => '0');
			tbe <= '0';
			msgOut <= (others => '0');
		end if;
	end process;
end impl;