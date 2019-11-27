LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

ENTITY tb_modm_addition IS
END tb_modm_addition;
ARCHITECTURE behavior OF tb_modm_addition IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dar_modm_multiplier
    PORT(
         x : IN  std_logic_vector(7 downto 0);
         y : IN  std_logic_vector(7 downto 0);
          clk, reset, start: in std_logic;
         --m : IN  std_logic_vector(7 downto 0);
         z : OUT  std_logic_vector(7 downto 0);
         done: out std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal x : std_logic_vector(7 downto 0) := (others => '0');
   signal y : std_logic_vector(7 downto 0) := (others => '0');
   signal clk: std_logic := '0';
   signal start: std_logic := '0';
   signal reset: std_logic := '0';
   
   --signal m : std_logic_vector(7 downto 0) := (others => '0');
   signal z : std_logic_vector(7 downto 0) := (others => '0');
   signal done: std_logic := '0';
 constant Clk_period : time := 20 ns; 

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: dar_modm_multiplier PORT MAP (
          x => x,
          y => y,
          clk => clk,
          reset => reset,
          start => start,
         
        --  m => m,
          z => z,
          done => done
        );

 Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
   -- Stimulus process
  stim_proc: process
   begin		
   start<= '0';
   wait for 50ns;
   start<='1';
   
		x <= std_logic_vector(to_unsigned(2, 8));
		y <= std_logic_vector(to_unsigned(3, 8));		
		
		--m <= std_logic_vector(to_unsigned(239, 8));
   --   wait for 100 ns;	
	--	x <= std_logic_vector(to_unsigned(234, 8));
	--	y <= std_logic_vector(to_unsigned(238, 8));
    --  wait for 100 ns;	
	--	x <= std_logic_vector(to_unsigned(215, 8));
	--	y <= std_logic_vector(to_unsigned(35, 8));

     wait;
   end process;
reset <='1' ,'0' after 20ns;

END;
