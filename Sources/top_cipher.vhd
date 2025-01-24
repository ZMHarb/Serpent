library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_cipher is
    Port(
        clk        : in  std_logic;
        reset      : in  std_logic;
        start      : in  std_logic;
        result     : out std_logic;
        done       : out std_logic
    );
end top_cipher;

architecture Behavioral of top_cipher is
    
    signal key: std_logic_vector(127 downto 0) := x"bcd9565e4835df1a1b2db2a75989d56a";
    signal plaintext: std_logic_vector(127 downto 0) := x"1cc72ff4c432bb69746ec03e111eda2f";
    
    signal ciphertext: std_logic_vector(127 downto 0);
    signal correct_cipher: std_logic_vector(127 downto 0) := x"03ede042126da08c6df7fc7e96f92024";
    signal s_done: std_logic := '0';        
begin
       
     uut: entity work.cipher_controller 
        port map (
            clk        => clk,
            reset      => reset,
            start      => start,
            key        => key,
            plaintext  => plaintext,
            ciphertext => ciphertext,
            done       => s_done     
       );
       
     process(s_done)
     begin
        if s_done = '1' then
            
            if ciphertext = correct_cipher then
                result <= '1';
            else
                result <= '0'; 
             end if;  
             
         else
            result <= '0';     
        end if;
     end process;

end Behavioral;
