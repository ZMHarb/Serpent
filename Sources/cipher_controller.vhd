library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.mypackage.all;

entity cipher_controller is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        start      : in  std_logic;
        plaintext  : in  std_logic_vector(127 downto 0);
        key        : in  std_logic_vector(127 downto 0);
        ciphertext : out std_logic_vector(127 downto 0);
        done       : out std_logic
    );
end cipher_controller;

architecture Behavioral of cipher_controller is

    signal ip_out         : std_logic_vector(127 downto 0);
    signal fp_out         : std_logic_vector(127 downto 0);
    signal round_keys     : array_33x128;
    signal cipher_output  : std_logic_vector(127 downto 0);   
    signal rounds_done    : std_logic := '0';

begin
    -- The PORT MAP with key schedule component.
    -- We apply the padding on the key before sending it to key_schedule
    key_schedule : entity work.key_schedule
        port map(
            key_in     => apply_padding(key),
            round_keys => round_keys
        );
    
    -- The PORT MAP with the round controller component
    round_controller : entity work.round_controller
        port map(
            clk        => clk,
            -- We apply the IP on the plaintext before sending it
            data_in    => apply_IP(reverse_bits(plaintext)),
            round_keys => round_keys,
            data_out   => cipher_output,
            done       => rounds_done
        );

    process(clk, reset)
    begin
        if reset = '1' then
            
            ciphertext <= (others => '0');  
            done <= '0';
        elsif rising_edge(clk) then
            if start = '1' then
                -- Waiting until the finish of round controller them we apply the FP to get the final ciphertext
                if rounds_done = '1' then
                    ciphertext <= reverse_bits(apply_FP(cipher_output)); 
                    done <= '1';
                else
                    done <= '0';
                end if;
            else
                done <= '0';
            end if;
        end if;
    end process;

end Behavioral;
