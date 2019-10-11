library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer_comp is
    port (
        clk, reset : in std_logic;
        secU, minU, hourU: out std_logic_vector(3 downto 0); -- ate 9, 4 bits eh necessario 
        secT, minT : out std_logic_vector(2 downto 0); -- so vai ate 5, 3 bits 
        hourT : out std_logic_vector(1 downto 0) -- unidade so conta ate 3 e dezena ate 2, 2 bits e so
    );
end entity timer_comp;

architecture rtl of timer_comp is
    ---------------------------- COMPONENTES -----------------------------------
    component count23 
        port (
            clk, rst, ena : in std_logic;
            dec : out std_logic_vector(1 downto 0);
            uni : out std_logic_vector(3 downto 0); 
            c : out std_logic
        );
    end component;

    component count59 
        port (
            clk, rst, ena : in std_logic; 
            dec : out std_logic_vector(2 downto 0);
            uni : out std_logic_vector(3 downto 0);
            c : out std_logic
        );
    end component; 
    ---------------------------------- SINAIS ----------------------------------------
    signal carry_sec, carry_min, carry_hour, rst : std_logic; 
	 signal hour_ena : std_logic; -- sinal criado pois nao pode realizar operacoes nos ports map
begin
    -- esse reset resetara quando a) o botao reset for pressionado
    -- b) quando for 23:59:59
    rst <= reset or (hour_ena and carry_hour);
	 hour_ena <= carry_sec and carry_min;

    -- o contador dos segundos sempre esta habilitado 
    -- seu carry eh o enable do contador dos minutos 
    segundos: count59 port map(
        clk => clk,
        rst => rst, 
        c => carry_sec,
        uni => secU,
        dec => secT,
        ena => '1'
    );

    -- so eh habilitado quando o contador dos segundos chega em 59 
    minutos: count59 port map(
        clk => clk,
        rst => rst, 
        c => carry_min,
        uni => minU,
        dec => minT,
        ena => carry_sec
    );

    -- so eh habilitado quando o contador dos segundos e dos minutos chegrem em 59 
    horas: count23 port map(
        clk => clk,
        rst => rst, 
        c => carry_hour,
        uni => hourU,
        dec => hourT,
        ena => hour_ena
    );
end architecture rtl;