LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use work.dar_modm_multiplier_parameters.all;


ENTITY tb_modm_multiplication IS
END tb_modm_multiplication;
 
ARCHITECTURE behavior OF tb_modm_multiplication IS 
 
    -- Component Declaration for the Unit Under Test (UUT)

     COMPONENT dar_modm_multiplier
    PORT(
         x : IN  std_logic_vector(7 downto 0);
         y : IN  std_logic_vector(7 downto 0);
         z: OUT  std_logic_vector(7 downto 0);
         clk, reset, start: in std_logic;
         done: out std_logic
        );
    END COMPONENT;

   --Inputs
   signal x : std_logic_vector(7 downto 0) := (others => '0');
   signal y : std_logic_vector(7 downto 0) := (others => '0');
  -- signal m : std_logic_vector(15 downto 0) := (others => '0');
   signal z : std_logic_vector(7 downto 0) := (others => '0');
   signal clk: std_logic := '0';
   signal reset: std_logic;
   signal start: std_logic := '0';
   signal done: std_logic;
--   constant clk_period: time:= 1ns;
 
BEGIN
 
    uut1: dar_modm_multiplier PORT MAP(
    x => x,
    y => y,
    z => z,
    clk => clk,
    reset => reset,
    start => start,
    done => done
    );
     
    
 
   clk <= not clk after 10 ns;
   stim_proc: process
   begin
   		reset <= '1';
   		wait for 20 ns;
   		reset <= '0';
   		wait for 50 ns;
   		start <= '1';
   		x <= std_logic_vector(to_unsigned(4, 8));
		y <= std_logic_vector(to_unsigned(4, 8));		
		--m <= std_logic_vector(to_unsigned(239, 8));
--      wait for 100 ns;	
--		x <= std_logic_vector(to_unsigned(234, 16));
--		y <= std_logic_vector(to_unsigned(238, 16));
		
--      wait for 100 ns;	
--		x <= std_logic_vector(to_unsigned(215, 16));
--		y <= std_logic_vector(to_unsigned(35, 16));
        wait;
      
   end process;



END;
