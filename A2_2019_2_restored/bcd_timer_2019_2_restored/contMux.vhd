library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contMux is
    port (
        clk : in std_logic; -- 10KHz
        uni : out std_logic_vector(1 downto 0) -- 0, 1, 2      
    );
end entity contMux;

architecture rtl of contMux is
    -------------------- SINAIS ----------------------------------------
    signal uni_reg, uni_nx  : integer range 0 to 9 := 0;
    signal dec_reg, dec_nx  : integer range 0 to 5 := 0;
signal uni3_reg,uni3_nx : integer range 0 to 2 := 0;
signal ena : std_logic;
begin
    --------------------- SEQUENCIAL 59------------------------------------
    process(clk, ena) begin
        if(ena = '1') then
dec_reg <= 0;
uni_reg <= 0;
 elsif (clk'event and clk='1') then
            if uni_reg=9 then
                dec_reg <= dec_nx;
            end if;
            uni_reg <= uni_nx;
        end if ;
    end process;
   
--------------------- SEQUENCIAL 3------------------------------------
    process(clk, ena) begin
        if (clk'event and clk='1' and ena='1') then
            uni3_reg <= uni3_nx;
        end if ;
    end process;

    --------------------- CONCORRENTE -------------------------------------
    -- reseta ao chegar no 9
    uni_nx <= (1 + uni_reg) when (uni_reg /= 9)else 0;
    dec_nx <= (1 + dec_reg) when (dec_reg /= 5) else 0;
    uni3_nx <= (1 + uni3_reg) when (uni3_reg /= 2) else 0;
ena <= '1' when (dec_reg = 5 and uni_reg = 6) else '0';
   
    uni <= std_logic_vector(
        to_unsigned(uni3_reg, uni'length)
    );

end architecture rtl;
