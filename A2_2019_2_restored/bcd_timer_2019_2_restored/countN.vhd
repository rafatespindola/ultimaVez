library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity countN is
    -- valores genericos para sem alterados 
    generic(
        n : natural := 9; -- o quanto conta  
        n_bits : natural := 4 -- numero de bits
    );
    port (
        clk, rst, ena : in std_logic; 
        carry : out std_logic;
        num_out : out std_logic_vector(n_bits-1 downto 0)
    );
end entity countN;

architecture rtl of countN is
    -- declaracao do sinal 
    signal r_reg, r_next : integer range 0 to n:=0; 
begin
    -- converte a saida 
    num_out <= std_logic_vector(
        to_unsigned(r_reg, num_out'length)
    );
    
    -- atualiza o registrador 
    -- reseta quando necessario 
    process(clk, rst) begin 
        if rst='1' then 
				r_reg <= 0;
        elsif(clk'event and clk='1') then
            if ena = '1' then
                r_reg <= r_next; 
            end if ;
		end if;
    end process;
    
    -- vai incrementando o registrador enquanto ele for menor que o limite 
    r_next <= (r_reg + 1) when (r_reg /= n) else 0; 

    -- o carry recebe 1 quando o registrador for 9
    carry <= '1' when (r_reg = n) else '0';         
    
end architecture rtl;