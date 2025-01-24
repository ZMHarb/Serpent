library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MYPACKAGE.all;

entity tb_round is
end tb_round;

architecture Behavioral of tb_round is

    signal round_key: std_logic_vector(127 downto 0) := "11111011010101010111111111000010101101100001000111010110100011000010101101111111110100000111100111100010101101111111110000111001";
    signal data_in: std_logic_vector(127 downto 0) := "11110010010010110011001110110000000100000100100000110000101100010111011100100111100100101010101011010001000111000101110110100101";
    signal round_num: integer range 0 to 31 := 0;
    signal data_out: std_logic_vector(127 downto 0);
    
    signal correct_out : std_logic_vector(127 downto 0) := "01011011101001001111011000110111100011110001001100010101000111010111001010100100001111101001100000001000100101100011101110010110";
    
begin

    stim_proc: process
    begin
  
        data_out <= apply_round(round_num, round_key, data_in);

        wait for 10ns;

        assert data_out = correct_out report "Round Error";
                        
    end process;

end Behavioral;
