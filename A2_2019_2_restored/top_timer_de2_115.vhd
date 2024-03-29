library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_timer_de2_115 is
	port 
	(
    	CLOCK_50: in std_logic;
		KEY		: in std_logic_vector (0 downto 0);
		HEX0	: out std_logic_vector (6 downto 0);
		HEX1	: out std_logic_vector (6 downto 0);
		HEX2	: out std_logic_vector (6 downto 0);
		HEX3	: out std_logic_vector (6 downto 0);
		HEX4	: out std_logic_vector (6 downto 0);
		HEX5	: out std_logic_vector (6 downto 0)
	);

end entity;

architecture top_a3_2019_2 of top_timer_de2_115 is
	
    component timer
    	port 
    	(
        	clk, reset : in std_logic;
    		secU, secT : out std_logic_vector(3 downto 0);
    		minU, minT : out std_logic_vector(3 downto 0);
    		hourU, hourT : out std_logic_vector(3 downto 0)
    	);
    end component;
	
	component bcd2ssd
		port 
		(
			BCD	: in std_logic_vector (3 downto 0);
			SSD	: out std_logic_vector (6 downto 0)
		);

	end component;
	
	component pll_50mhz_10khz
		port
		(
			inclk0: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC 
		);
	end component pll_50mhz_10khz;
	
	
    signal secU, secT: std_logic_vector(3 downto 0);
    signal minU, minT: std_logic_vector(3 downto 0);
    signal hourU, hourT: std_logic_vector(3 downto 0);
	signal r_reg, r_next: unsigned(13 downto 0);
	signal reset,CLOCK_1Hz, CLOCK_10Hz: std_logic;
		
begin

	reset <= not KEY(0);
	
	pll0: pll_50mhz_10khz port map (inclk0 => CLOCK_50,
	                        c0 => CLOCK_10Hz);
	
	process(CLOCK_10Hz,reset)
	begin
	 if (reset='1') then
	    r_reg <= (others=>'0');
	 elsif (CLOCK_10Hz'event and CLOCK_10Hz='1') then
	    r_reg <= r_next;
	 end if;
	end process;

	-- next-state logic
	r_next  <=  (others=>'0') when r_reg=9999 else 
				r_reg + 1;
	-- output logic
	CLOCK_1Hz <= '1' when r_reg < 5000 else
				 '0';
	

    t0:   timer port map( clk   => CLOCK_1Hz,
                          reset => reset,
                          secU  => secU,
                          secT  => secT,
                          minU  => minU,
                          minT  => minT,
                          hourU => hourU,
                          hourT => hourT );

    bcd0: bcd2ssd port map (BCD => secU,
	                        SSD => HEX0 );
	bcd1: bcd2ssd port map (BCD => secT,
	                        SSD => HEX1 );
    bcd2: bcd2ssd port map (BCD => minU,
	                        SSD => HEX2 );							
	bcd3: bcd2ssd port map (BCD => minT,
	                        SSD => HEX3 );						  
	bcd4: bcd2ssd port map (BCD => hourU,
	                        SSD => HEX4 );	
    bcd5: bcd2ssd port map (BCD => hourT,
	                        SSD => HEX5 );
							




					  	  
end top_a3_2019_2;

