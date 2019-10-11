library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- gasta 2 elementos logicos ao todo
entity bcd2ssd_max2 is
    port (
        BCD	: in std_logic_vector (1 downto 0);
		SSD	: out std_logic_vector (6 downto 0)
    );
end entity bcd2ssd_max2;

architecture rtl of bcd2ssd_max2 is
    
begin
    with BCD select
	SSD <= "1000000" when "00", -- 0
	       "1111001" when "01", -- 1 
	       "0100100" when "10", -- 2
           "0111111" when others;  
    
end architecture rtl;