library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

use work.MYPACKAGE.all;

entity tb_fp is
end;

architecture bench of tb_fp is

    signal fp_in: std_logic_vector(127 downto 0) := "11101100100010100011100100011101010101011000100000110011101010110110000100001001111011000010101111010001111000010000111011100000";
    signal fp_out: std_logic_vector(127 downto 0);
    
    signal correct_out: std_logic_vector(127 downto 0) := "11110101001100110001110110100110110000011100000010001100101001101001100000001111100010110010011000001111110011010101000111010000";    
begin
    
    process
    begin
    
        fp_out <= apply_FP(fp_in);
        wait for 10ns;
        assert fp_out = correct_out report "FP Error";

--    wait;
    end process;
    
end;
