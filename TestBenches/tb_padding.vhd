library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.mypackage.all;

entity tb_padding is
end tb_padding;

architecture Behavioral of tb_padding is

    signal key_in : std_logic_vector(127 downto 0) := x"432da46b89ac716907cb7dcfcbcc9566";
    signal key_out : std_logic_vector(255 downto 0);
    signal correct_out : std_logic_vector(255 downto 0) := x"00000000000000000000000000000001432da46b89ac716907cb7dcfcbcc9566";
     
begin

    process begin 
    
        key_out <= apply_padding(key_in);
        wait for 10 ns;
        assert key_out = correct_out report "128-bit key Padding Error";
        
    end process;    

end Behavioral;