library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- economiza 1 elemento logico em relacao ao bcd2ssd 

entity bcd2ssd_max5 is
    port (
        BCD : in std_logic_vector(2 downto 0);
        SSD : out std_Logic_vector(6 downto 0)
    );
end entity bcd2ssd_max5;

architecture rtl of bcd2ssd_max5 is
    
begin
    with BCD select
	SSD <= "1000000" when "000", -- 0
	       "1111001" when "001", -- 1 
	       "0100100" when "010", -- 2
	       "0110000" when "011", -- 3
	       "0011001" when "100", -- 4
           "0010010" when "101", -- 5
           "0111111" when others;  
end architecture rtl;