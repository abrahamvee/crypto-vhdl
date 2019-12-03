----------------------------------------------------------------------------
-- Double, Add and Reduce Multiplier (dar_modm_multiplier.vhd)
--  dar_mod_multiplier
------------------------------------------------------------------------------
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

library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.dar_modm_multiplier_parameters.all;

entity dar_modm_multiplier is
port (
  x, y: in std_logic_vector(K-1 downto 0);
  clk, reset, start: in std_logic;
  z: out std_logic_vector(K-1 downto 0);
  done: out std_logic
);
end dar_modm_multiplier;

architecture rtl of dar_modm_multiplier is
  signal p, second_operand, sum, int_x: std_logic_vector(K-1 downto 0);
  signal step_type, ce_p, condition, load, x_i, update, equal_zero: std_logic;
  type states is range 0 to 4;
  signal current_state: states;
  signal count: std_logic_vector(logK-1 downto 0);

  component modm_adder_to_be_completed is
  port (
    x, y: in std_logic_vector(K-1 downto 0);
    z: out std_logic_vector(K-1 downto 0));
  end component;

begin

  with step_type select second_operand <= p when '0', y when others;

  main_component: modm_adder_to_be_completed port map(p, second_operand, sum);
  
  condition <= ce_p and (not(step_type) or x_i);

  parallel_register: process(clk)
    begin
    if clk'event and clk = '1' then
      if load = '1' then 
        p <= (others => '0');
      elsif condition = '1' then 
        p <= sum;
      end if;
    end if;
  end process parallel_register;

  equal_zero <= '1' when count = ZERO else '0';

  z <= p;

  shift_register: process(clk)
  begin
  if clk'event and clk='1' then
    if load = '1' then 
      int_x <= x;
    elsif update = '1' then
      for i in k-1 downto 1 loop int_x(i) <= int_x(i-1); end loop;
      int_x(0) <= '0';
    end if;
  end if;
  end process shift_register;

  x_i <= int_x(k-1);

  counter: process(clk)
  begin
  if clk'event and clk = '1' then
    if load = '1' then 
      count <= conv_std_logic_vector(k-1, logk);
    elsif update = '1' then 
      count <= count - 1;
    end if;
  end if;
  end process counter; 
   
  control_unit: process(clk, reset, current_state, equal_zero)
  begin
  case current_state is
    when 0 to 1 => 	step_type <= '0'; ce_p <= '0'; load <= '0'; update <= '0'; done <= '1';
    when 2 => 			step_type <= '0'; ce_p <= '0'; load <= '1'; update <= '0'; done <= '0';
    when 3 => 			step_type <= '0'; ce_p <= '1'; load <= '0'; update <= '0'; done <= '0';
    when 4 => 			step_type <= '1'; ce_p <= '1'; load <= '0'; update <= '1'; done <= '0';
  end case;

  if reset = '1' then 
    current_state <= 0;
  elsif clk'event and clk = '1' then
    case current_state is
      when 0 => if start = '0' then current_state <= 1; end if;
      when 1 => if start = '1' then current_state <= 2; end if;
      when 2 => current_state <= 3;
      when 3 => current_state <= 4;
      when 4 => if equal_zero = '1' then current_state <= 0; 
                else current_state <= 3; end if;
    end case;
  end if;
  end process control_unit;

end rtl;
