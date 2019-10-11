library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level_mux is
    port (
        CLOCK_50: in std_logic;
KEY : in std_logic_vector (0 downto 0);
HEX0 : out std_logic_vector (6 downto 0);
HEX1 : out std_logic_vector (6 downto 0);
HEX2 : out std_logic_vector (6 downto 0);
HEX3 : out std_logic_vector (6 downto 0);
HEX4 : out std_logic_vector (6 downto 0);
HEX5 : out std_logic_vector (6 downto 0)
    );
end entity top_level_mux;

architecture rtl of top_level_mux is
    -- Declaracao dos componentes
    component timer_comp
        port (
            clk, reset : in std_logic;
            secU, minU, hourU : out std_logic_vector(3 downto 0); -- ate 9, 4 bits eh necessario
            secT, minT : out std_logic_vector(2 downto 0); -- so vai ate 5, 3 bits
            hourT : out std_logic_vector(1 downto 0) -- unidade so conta ate 3 e dezena ate 2, 2 bits e so
        );
    end component;

component contMux
port (
 clk : in std_logic; -- 10KHz
 uni : out std_logic_vector(1 downto 0) -- 0, 1, 2      
);
end component;

component mux
port(
hourU, minU, secU : in  std_logic_vector(3 downto 0);
sel : in std_logic_vector (1 downto 0);
saida : out std_logic_vector(3 downto 0)
);
end component;

component demux
port(
hourU, minU, secU : out  std_logic_vector(6 downto 0);
sel : in std_logic_vector (1 downto 0);
entrada : in std_logic_vector(6 downto 0)
);
end component;

    component bcd2ssd
        port(
            BCD : in std_logic_vector (3 downto 0);
            SSD : out std_logic_vector (6 downto 0)
        );
    end component;
   
    component bcd2ssd_max2
        port (
            BCD : in std_logic_vector (1 downto 0);
            SSD : out std_logic_vector (6 downto 0)
        );
    end component;
   
    component bcd2ssd_max5
        port (
            BCD : in std_logic_vector(2 downto 0);
            SSD : out std_Logic_vector(6 downto 0)
        );
    end component;

component pll_50mhz_10khz
port
(
inclk0: IN STD_LOGIC  := '0';
c0 : OUT STD_LOGIC
);
end component pll_50mhz_10khz;

    -- Declaracao dos sinais
    signal secU, minU, hourU: std_logic_vector(3 downto 0);
	 signal sig1 : std_Logic_vector (3 downto 0);
	 signal sig2 : std_Logic_vector (6 downto 0);
    signal secT, minT: std_logic_vector(2 downto 0);
    signal hourT, seletor: std_logic_vector(1 downto 0);
signal r_reg, r_next: unsigned(13 downto 0);
signal reset,CLOCK_1Hz, CLOCK_10Hz: std_logic;

begin

    reset <= not KEY(0);

pll0: pll_50mhz_10khz port map (inclk0 => CLOCK_50, c0 => CLOCK_10Hz);
   
    process(CLOCK_10Hz,reset)
    begin
    if (reset='1') then
        r_reg <= (others=>'0');
    elsif (CLOCK_10Hz'event and CLOCK_10Hz='1') then
        r_reg <= r_next;
    end if;
    end process;
   
    -- next-state logic
r_next  <=  (others=>'0') when r_reg=9999 else r_reg + 1;
    -- output logic
    CLOCK_1Hz <= '1' when r_reg /= 5000 else '0';

    -- Instanciacao dos componentes

    timer: timer_comp port map( clk => CLOCK_1Hz,
    reset => reset,
    secU  => secU,
    secT  => secT,
    minU  => minU,
    minT  => minT,
    hourU => hourU,
    hourT => hourT
	 );

	cont3: contMux port map (
		clk => CLOCK_10Hz, 
		uni => seletor
	);
	
	muxFrente: mux port map (
		hourU => hourU,
		minU => minU,
		secU => secU,
		sel => seletor,
		saida => sig1
	); -- parei aqui
	
	bcd2ssdMeio: bcd2ssd port map(
		BCD => sig1, 
		SSD => sig2
	);
	
	demuxTras: demux port map (
		hourU => HEX4, 
		minU => HEX2,
		secU => HEX0,
		sel => seletor,
		entrada => sig2
	);
	
	
	--	hourU, minU, secU : out  std_logic_vector(3 downto 0);
	--	sel : in std_logic_vector (1 downto 0);
	--	entrada : in std_logic_vector(6 downto 0)
	
	-- clk : in std_logic; -- 10KHz
	-- uni : out std_logic_vector(1 downto 0) -- 0, 1, 2  

    --sec_u: bcd2ssd port map(BCD => secU, SSD => HEX0);
    sec_d: bcd2ssd_max5 port map(BCD =>secT, SSD =>HEX1);

    --min_u: bcd2ssd port map(BCD => minU, SSD => HEX2);
    min_d: bcd2ssd_max5 port map(BCD => minT, SSD =>HEX3);
   
    --hour_u: bcd2ssd port map(BCD => hourU, SSD => HEX4);
    hour_d: bcd2ssd_max2 port map(BCD => hourT, SSD => HEX5);
end architecture rtl;