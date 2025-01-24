library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.mypackage.ALL;

entity tb_sbox128 is
end tb_sbox128;

architecture Behavioral of tb_sbox128 is

    signal sbox_in: std_logic_vector(127 downto 0) := "11000011000011001100001111111111110000011000010110000000000000001111111111111111111111111111111100000000000000000000000000000000";
    signal sbox_sel: integer range 0 to 7 := 1;
    signal sbox_out: std_logic_vector(127 downto 0);
    
    signal correct_out: std_logic_vector(127 downto 0) := "11100110111111101110011000100010111010000011011100111111111111110010001000100010001000100010001011111111111111111111111111111111";
        
begin

    process
    begin
    
        sbox_out <= apply_sbox128(sbox_sel, sbox_in);
        wait for 10ns;
        assert sbox_out = correct_out report "apply_sbox128(1, x) Error";
    end process;

end Behavioral;
