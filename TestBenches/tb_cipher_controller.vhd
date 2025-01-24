library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity tb_cipher_controller is
end tb_cipher_controller;

architecture bench of tb_cipher_controller is

    signal plaintext: std_logic_vector(127 downto 0) := x"1774ada02b5eab5f298c4392b8a963e9";
    signal ciphertext: std_logic_vector(127 downto 0);
    signal clk: std_logic := '0';
    signal done: std_logic;
    signal reset: std_logic;
    signal start: std_logic;
    signal key: std_logic_vector(127 downto 0) := x"8e4f908cd3b7428a86b206953913e054";
    
    signal correct_out: std_logic_vector(127 downto 0) := x"e34d791c52703c8c37c624009bfdb129";
    
    constant clk_period: time := 20 ns;

begin
    
    UUT: entity work.cipher_controller
        port map (
            clk        => clk,
            reset      => reset,
            plaintext  => plaintext,
            ciphertext => ciphertext, 
            done       => done, 
            start      => start,
            key        => key
        );

    clk_process : process(clk)
    begin
        clk <= not clk after clk_period / 2;
    end process clk_process;

    check_process: process
    begin
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        start <= '1';
        wait for clk_period;
        wait until done = '1';
        assert ciphertext = correct_out
            report "CipherController Error"
            severity error;

        wait;
    end process check_process;

end architecture bench;
