library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MYPACKAGE.all;

entity tb_lt is
end tb_lt;

architecture Behavioral of tb_lt is

    signal lt_in : std_logic_vector(127 downto 0) := "01011101110011111001111101001110101100000010001111101111000110011001010011110001111000010011101000111100100100111110011000011111";
    signal lt_out : std_logic_vector(127 downto 0);
    signal correct_out : std_logic_vector(127 downto 0) := "11011000000000110111011011110110101111011101111001111011101100101011100010100011101000001001100011111010111010010101001110000110";

begin

    process 
    begin 
        
        lt_out <= apply_LT(lt_in);
        wait for 10 ns;
        assert lt_out = correct_out report "LT Error";                    
    end process;    

end Behavioral;
