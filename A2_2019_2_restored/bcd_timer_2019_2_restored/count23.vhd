library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity count23 is
    port (
        clk, rst, ena : in std_logic;
        dec : out std_logic_vector(1 downto 0);
        uni : out std_logic_vector(3 downto 0); 
        c : out std_logic
    );
end entity count23;

architecture rtl of count23 is
    -------------- SINAIS --------------------------------- 
    signal uni_reg, uni_nx : integer range 0 to 9 := 0; 
    signal dec_reg, dec_nx : integer range 0 to 2 := 0; 
begin
    -------------- SEQUENCIAl ------------------------------
    process(clk, ena, rst) begin
        if rst='1' then
            uni_reg <= 0;
            dec_reg <= 0; 
        elsif (clk'event and clk='1' and ena='1') then
            if uni_reg=9 then
                dec_reg <= dec_nx; 
            end if ;
            uni_reg <= uni_nx; 
        end if ;

    end process; 
            --------------------- CONCORRENTE -------------------------------------
    -- reseta ao chegar no 9
    uni_nx <= (1 + uni_reg) when (uni_reg /= 9) else 0; 
    dec_nx <= 0 when (dec_reg = 2 and uni_reg = 3) else (dec_reg + 1); 
    c <= '1' when (dec_reg = 2 and uni_reg = 3) else '0'; 
    
    uni <= std_logic_vector(
        to_unsigned(uni_reg, uni'length)
    );

    dec <= std_logic_vector(
        to_unsigned(dec_reg, dec'length)
    );
    
end architecture rtl;