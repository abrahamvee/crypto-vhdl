LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

ENTITY tb_modm_addition IS
END tb_modm_addition;
 
ARCHITECTURE behavior OF tb_modm_addition IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT modm_addition
    PORT(
         x : IN  std_logic_vector(7 downto 0);
         y : IN  std_logic_vector(7 downto 0);
         m : IN  std_logic_vector(7 downto 0);
         z : OUT  std_logic_vector(7 downto 0)
        );
        
    END COMPONENT;
    
    COMPONENT modm_adder
    PORT(
         x : IN  std_logic_vector(7 downto 0);
         y : IN  std_logic_vector(7 downto 0);
         z: OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   --Inputs
   signal x : std_logic_vector(7 downto 0) := (others => '0');
   signal y : std_logic_vector(7 downto 0) := (others => '0');
   signal m : std_logic_vector(7 downto 0) := (others => '0');
   signal z : std_logic_vector(7 downto 0) := (others => '0');
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: modm_addition PORT MAP (
          x => x,
          y => y,
          m => m,
          z => z
        );

    uut2: modm_adder PORT MAP(
          x => x,
          y => y,
          z => z
    );

   -- Stimulus process
   
   stim_proc: process
   begin		
		x <= std_logic_vector(to_unsigned(129, 8));
		y <= std_logic_vector(to_unsigned(105, 8));		
		m <= std_logic_vector(to_unsigned(239, 8));
	
      wait for 100 ns;	
		x <= std_logic_vector(to_unsigned(234, 8));
		y <= std_logic_vector(to_unsigned(238, 8));
		
      wait for 100 ns;	
		x <= std_logic_vector(to_unsigned(215, 8));
		y <= std_logic_vector(to_unsigned(35, 8));
      wait;
      
   end process;

END;
