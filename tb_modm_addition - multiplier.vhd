LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

package dar_modm_multiplier_parameters is
  constant K: integer := 8;
  constant logK: integer := 3;
  constant integer_M: integer := 239;
  constant M: std_logic_vector(k-1 downto 0) := conv_std_logic_vector(integer_M, K);
  constant minus_M: std_logic_vector(K-1 downto 0) := conv_std_logic_vector(2**k - integer_M, K);
  constant ZERO: std_logic_vector(logK-1 downto 0) := (others => '0');
end dar_modm_multiplier_parameters;

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use work.dar_modm_multiplier_parameters.all;

ENTITY tb_modm_addition IS
END tb_modm_addition;
 
ARCHITECTURE behavior OF tb_modm_addition IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dar_modm_multiplier 
    PORT(
         x : IN  std_logic_vector(7 downto 0);
         y : IN  std_logic_vector(7 downto 0);
         clk, reset, start: in std_logic;
         done: out std_logic;
         z : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal x : std_logic_vector(7 downto 0) := (others => '0');
   signal y : std_logic_vector(7 downto 0) := (others => '0');
   signal z : std_logic_vector(7 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';
   signal done : std_logic :='0';
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dar_modm_multiplier PORT MAP (
   
          x => x,
          y => y,
          clk => clk,
          reset =>  reset,
          start => start,
          done => done,
          z => z
        );
        
--Clk_process :process
--   begin
--        clk <= not(clk) after 5 ns;
--   end process;

clk <= not(clk) after 10 ns;
   -- Stimulus process
   stim_proc: process
   begin	
        reset <= '1';
        wait for 10 ns;	
        reset <= '0';
        wait for 50ns ;--30 ns;
        start <= '1';
		x <= std_logic_vector(to_unsigned(2, 8));
		y <= std_logic_vector(to_unsigned(3, 8));	
			
--      wait for 300 ns; 	-- wait 2k == 19
--		x <= std_logic_vector(to_unsigned(2, 8));
--		y <= std_logic_vector(to_unsigned(3, 8));
		
--      wait for 300 ns;	
--		x <= std_logic_vector(to_unsigned(2, 8));
--		y <= std_logic_vector(to_unsigned(3, 8));

      wait;
   end process;
--reset <= '1' , '0' after 20ns;
END;
