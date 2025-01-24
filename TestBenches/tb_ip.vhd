----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.09.2024 08:35:08
-- Design Name: 
-- Module Name: tb_sbox - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

use work.MYPACKAGE.all;

entity tb_ip is
end;

architecture bench of tb_ip is

    signal ip_in: std_logic_vector(127 downto 0) := "11101100100010100011100100011101010101011000100000110011101010110110000100001001111011000010101111010001111000010000111011100000";
    signal ip_out: std_logic_vector(127 downto 0);
    
    signal correct_out: std_logic_vector(127 downto 0) := "10011111101001011000110000000111110100010001000011100000100000110010001011101100101100110101110001010001011110001110100001101110";
    
begin
    
    process
    begin
    
        ip_out <= apply_IP(ip_in);
        wait for 10ns;
        assert ip_out = correct_out report "IP Error";
    end process;
    
end;
