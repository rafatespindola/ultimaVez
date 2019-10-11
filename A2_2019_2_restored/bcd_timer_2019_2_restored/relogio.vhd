library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity relogio is
    port (
        minU, hourU : in std_logic_vector(3 downto 0);
        minT : in std_logic_vector(2 downto 0);
        hourT : in std_logic_vector(1 downto 0);
        set_alarm, soneca, clk, rst : in std_logic;
        beep : out std_logic
    );
end entity relogio;

architecture rtl of relogio is
    ----------------- ESTADOS --------------------------
    type state is(idle, wait_st, desperta); 
    signal pr_state, nx_state : state;

    --------------- SINAIS ------------------------------
    signal hourU_sign, minU_sign : integer range 0 to 9;
    signal minT_sign : integer range 0 to 5; 
    signal hourT_sign : integer range 0 to 2; 

begin
    hourT_sign <= to_integer(unsigned(hourT));
    hourU_sign <= to_integer(unsigned(hourU));

    minU_sign <= to_integer(unsigned(minU));
    minT_sign <= to_integer(unsigned(minT));

    ----------------- Reset -------------------------
    process(clk, rst) begin 
        if rst='1' then
            pr_state <= idle; 
        elsif (clk'event and clk='1') then 
            pr_state <= nx_state; 
        end if ;
    end process;

    ----------------- FSM ----------------------------

    process(pr_state, set_alarm, soneca,
        hourT_sign, hourU_sign, minT_sign, minU_sign) begin 
        -- Valores padroes 
        beep <= '0'; 
		  nx_state <= idle; 
        -- Logica sequencial 
        case pr_state is 
            -- fica esperando o usuario setar o alarme 
            when idle => 
                if set_alarm='1' then
                    nx_state <= wait_st; 
                end if ;
            
            -- fica esperando dar 06:30:00
            -- o soneca so eh chamado depois do estado desperta 
            -- o desperta so acontece quando for 6:30
            -- a soneca eh 10minutos
            -- entao quando minT for 3, significa que ta no alarme, sem soneca
            -- quando minT for 4, significa que ta na soneca 
            when wait_st => 
                if (hourT_sign=0 and hourU_sign=6 and
                    (minT_sign =3 or minT_sign =4)and minU_sign =0)then
                        nx_state <= desperta; 
                end if ;

            when desperta =>
                beep <= '1'; 
                if set_alarm='0' and soneca='0' then 
                    nx_state <= idle; 
                elsif soneca='1' then
                    nx_state <= wait_st; 
					else 
							nx_state <= idle; 
                end if;
				when others => 
							nx_state <= idle; 
			end case;
    end process;
    
    
end architecture rtl;