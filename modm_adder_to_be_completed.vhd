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

entity modm_adder_to_be_completed is
port (
  x, y: in std_logic_vector(K-1 downto 0);
  z: out std_logic_vector(K-1 downto 0)
);
end modm_adder_to_be_completed;

architecture rtl of modm_adder_to_be_completed is
  signal long_x, sum1, long_z1, sum2: std_logic_vector(K downto 0);
  signal c1, c2, sel: std_logic;
  signal z1, z2: std_logic_vector(K-1 downto 0);

begin
  long_x <= '0' & x;
  sum1 <= long_x + y;
  c1 <= sum1(K);
  z1 <= sum1(K-1 downto 0);
  
  long_z1 <= '0' & z1;
  sum2 <= long_z1 + minus_M;
  c2 <= sum2(K);
  z2 <= sum2(K-1 downto 0);
  sel <= c1 or c2;
  with sel select z <= z1 when '0', z2 when others;
end rtl;