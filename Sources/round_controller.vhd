library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.mypackage.all;

entity round_controller is
    Port (
        clk        : in  std_logic;
        data_in    : in  std_logic_vector(127 downto 0); 
        data_out   : out std_logic_vector(127 downto 0); 
        done       : out std_logic; 
        round_keys : in  array_33x128
    );
end round_controller;

architecture Behavioral of round_controller is

begin

    process(clk)
        variable current_round : integer range 0 to 31 := 0;
        variable round_data    : std_logic_vector(127 downto 0);
        variable temp_data     : std_logic_vector(127 downto 0);
        variable round_key     : std_logic_vector(127 downto 0);
        variable done_rounds   : std_logic := '0';
                
    begin
        -- Each clk cycle, a round will be applied
        if rising_edge(clk) then
            -- Until rounds are not finished
            if done_rounds = '0' then
                -- Round 0 will be applied on the plaintext using the first subkey
                if current_round = 0 then
                    round_data := data_in;
                    round_data := apply_round(0, round_keys(0), round_data);
                    current_round := 1;
                
                -- Applying all the rounds
                elsif current_round < 31 then
                    round_key := round_keys(current_round);
                    round_data := apply_round(current_round, round_key, round_data);
                    current_round := current_round + 1;
                
                -- last round will be a combination of XOR and SBOX
                elsif current_round = 31 then
                    
                    -- Getting the 32th round key
                    round_key := round_keys(31);
                    
                    -- XORing the final round_data with the round key
                    temp_data := round_data xor round_key; 
                    
                    -- Applying the 128-bits SBox
                    temp_data := apply_sbox128(7, temp_data);
                    
                    -- Getting the last round key
                    round_key := round_keys(32);
                    
                    -- XORing the last round key with SBox result
                    temp_data := temp_data xor round_key;
                    
                    data_out <= temp_data;
                    done_rounds := '1';
                end if;
            end if;
        end if;
    end process;
    -- Signaling for cipherController that all rounds had finished
    done <= '1';

end Behavioral;
