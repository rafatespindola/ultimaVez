library IEEE;
use IEEE.std_logic_1164.all;
-----------------------------------------------------------
entity mux is
port(
hourU, minU, secU : in  std_logic_vector(3 downto 0);
sel : in std_logic_vector (1 downto 0);
saida : out std_logic_vector(3 downto 0)
);
end entity mux;
-----------------------------------------------------------
architecture rtl of mux is
begin

process(sel)
begin
  case sel is
    when "00" => saida <= hourU ;
    when "01" => saida <= minU ;
    when "10" => saida <= secU ;
    when others => saida <= secU;
  end case;
end process;
end rtl;