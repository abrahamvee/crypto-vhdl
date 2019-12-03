library IEEE;
use IEEE.std_logic_1164.all;
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


LIBRARY IEEE; USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--USE work.mod_mm.ALL;
use work.dar_modm_multiplier_parameters.all;

ENTITY mod_mm_exponentiation IS 
  PORT(
    x, y: IN STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    clk, reset, start: STD_LOGIC;
    z: OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    done: OUT STD_LOGIC
  );
END mod_mm_exponentiation;

ARCHITECTURE circuit OF mod_mm_exponentiation IS

  SIGNAL a, b, mux_out, mult_out, reg_in_a, reg_in_b, reg_x: STD_LOGIC_VECTOR(k-1 DOWNTO 0);
  SIGNAL sel, start_mult, mult_done, load, en_a, en_b, shift, x_i: STD_LOGIC;
  SIGNAL count: NATURAL;

  TYPE state IS RANGE 0 TO 11;
  SIGNAL current_state: state;

  COMPONENT dar_modm_multiplier IS
  PORT(
    x, y: IN STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    clk, reset, start: STD_LOGIC;
    z: OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    done: OUT STD_LOGIC);
  END COMPONENT;   
  
BEGIN

  WITH sel SELECT mux_out <= a WHEN '0', b WHEN OTHERS;

  main_component: dar_modm_multiplier
  PORT MAP(x => mux_out, y => b, z => mult_out, clk => clk, start => start_mult, 
  reset => reset, done => mult_done);

  WITH load SELECT reg_in_a <= one WHEN '1', mult_out WHEN OTHERS;
  WITH load SELECT reg_in_b <= y WHEN '1', mult_out WHEN OTHERS;

  register_a: PROCESS(clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN 
       IF en_a = '1' THEN a <= reg_in_a; END IF;
    END IF;
  END PROCESS;
  z <= a;

  register_b: PROCESS(clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN 
       IF en_b = '1' THEN b <= reg_in_b; END IF;
    END IF;
  END PROCESS;

  shift_register: PROCESS(clk, load, shift)
  BEGIN
     IF load = '1' THEN reg_x <= x;
     ELSIF clk'event AND clk = '1' THEN 
       IF shift = '1' THEN reg_x <= '0'&reg_x(k-1 DOWNTO 1); END IF;
     END IF;
  END PROCESS;
  x_i <= reg_x(0);

  counter: PROCESS(clk, load, shift)
  BEGIN
     IF load = '1' THEN count <= k - 1;
     ELSIF clk'event AND clk = '1' THEN 
       IF shift = '1' THEN count <= count - 1; END IF;
     END IF;
  END PROCESS;


--control unit
next_state: PROCESS(clk, reset)
BEGIN
   IF reset = '1' THEN current_state <= 0;
   ELSIF clk'event AND clk = '1' THEN
      CASE current_state IS
         WHEN 0 => IF start = '0' THEN current_state <= 1; END IF;
         WHEN 1 => IF start = '1' THEN current_state <= 2; END IF;
         WHEN 2 => current_state <= 3;
         WHEN 3 => IF x_i = '1' THEN current_state <= 4; ELSE current_state <= 7; END IF;
         WHEN 4 => current_state <= 5;
         WHEN 5 => IF mult_done = '1' THEN current_state <= 6; END IF;
         WHEN 6 => current_state <= 7;
         WHEN 7 => current_state <= 8;
         WHEN 8 => IF mult_done = '1' THEN current_state <= 9; END IF;
         WHEN 9 => current_state <= 10;
         WHEN 10 => IF count = 0 THEN current_state <= 0; ELSE current_state <= 11; END IF;
         WHEN 11 => current_state <= 3;
      END CASE;
   END IF;
END PROCESS;

output_function: PROCESS(current_state)
BEGIN
      CASE current_state IS
         WHEN 0 TO 1 => sel <= '0'; start_mult <= '0'; load <= '0'; en_a <= '0'; en_b <= '0'; shift <= '0'; done <= '1';
         WHEN 2 => 		sel <= '0'; start_mult <= '0'; load <= '1'; en_a <= '1'; en_b <= '1'; shift <= '0'; done <= '0';
         WHEN 3 => 		sel <= '0'; start_mult <= '0'; load <= '0'; en_a <= '0'; en_b <= '0'; shift <= '0'; done <= '0';
         WHEN 4 => 		sel <= '0'; start_mult <= '1'; load <= '0'; en_a <= '0'; en_b <= '0'; shift <= '0'; done <= '0';
         WHEN 5 => 		sel <= '0'; start_mult <= '0'; load <= '0'; en_a <= '0'; en_b <= '0'; shift <= '0'; done <= '0';
         WHEN 6 => 		sel <= '0'; start_mult <= '0'; load <= '0'; en_a <= '1'; en_b <= '0'; shift <= '0'; done <= '0';
         WHEN 7 => 		sel <= '1'; start_mult <= '1'; load <= '0'; en_a <= '0'; en_b <= '0'; shift <= '0'; done <= '0';
         WHEN 8 => 		sel <= '1'; start_mult <= '0'; load <= '0'; en_a <= '0'; en_b <= '0'; shift <= '0'; done <= '0';
         WHEN 9 => 		sel <= '1'; start_mult <= '0'; load <= '0'; en_a <= '0'; en_b <= '1'; shift <= '0'; done <= '0';
         WHEN 10 => 		sel <= '0'; start_mult <= '0'; load <= '0'; en_a <= '0'; en_b <= '0'; shift <= '0'; done <= '0'; 
         WHEN 11 => 		sel <= '0'; start_mult <= '0'; load <= '0'; en_a <= '0'; en_b <= '0'; shift <= '1'; done <= '0';
      END CASE;
END PROCESS;

END circuit;


LIBRARY IEEE; USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.mod_m.ALL;
ENTITY test_mod_mm_exponentiation IS END test_mod_mm_exponentiation;

ARCHITECTURE test OF test_mod_mm_exponentiation IS
COMPONENT mod_mm_exponentiation IS 
  PORT(
    x, y: IN STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    clk, reset, start: STD_LOGIC;
    z: OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    done: OUT STD_LOGIC
  );
END COMPONENT;

SIGNAL x, y, z: STD_LOGIC_VECTOR(k-1 DOWNTO 0);
SIGNAL reset, start, done: STD_LOGIC;
SIGNAL clk: STD_LOGIC := '0';

BEGIN

dut: mod_mm_exponentiation
PORT MAP(x => x, y => y, z => z, clk => clk, reset => reset, start => start, done => done);

clk <= NOT(clk) AFTER 50 NS;

test_vectors: PROCESS
BEGIN
x <= m;
y <= (k-1 => '0', others => '1');
reset <= '1';
start <= '1';
WAIT FOR 100 NS;
reset <= '0';
WAIT FOR 100 NS;
start <= '0';
WAIT FOR 100 NS;
start <= '1';
--WAIT FOR 8000000 NS;
--x <= (k-1 => '1', others => '0');
--start <= '0';
--WAIT FOR 100 NS;
--start <= '1';
WAIT;
END PROCESS;
END test;
