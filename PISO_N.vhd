library IEEE;
use IEEE.std_logic_1164.all;

entity PISO_N is
	generic(bits : integer := 20);
   port(
		 clk : in STD_LOGIC;
		 reset : in STD_LOGIC;
		 load : in STD_LOGIC;
		 din : in STD_LOGIC_VECTOR(bits-1 downto 0);
		 dout : out STD_LOGIC;
		 tx : out STD_LOGIC
		 );
end PISO_N;


architecture PISO_ARC of PISO_N is
begin

    piso : process (clk,reset,load,din) is
    variable temp : std_logic_vector (din'range);
	 variable i : integer := 1;
    begin
        if (reset='1') then
            temp := (others=>'0');
				tx <= '0';
				i := 1;
        elsif (load='1') then
            temp := din ;
				tx <= '0';
				i := 1;
        elsif (rising_edge (clk)) then
				if(i > bits) then
					tx <= '0';
				else
					dout <= temp(bits-1);
					temp := temp(bits-2 downto 0) & '0';
					
					tx <= '1';
					i := i + 1;
				end if;
        end if;
    end process piso;

end PISO_ARC;