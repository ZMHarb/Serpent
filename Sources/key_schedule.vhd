library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.mypackage.all;

entity key_schedule is
    port (
        key_in     : in  std_logic_vector(255 downto 0);
        round_keys : out array_33x128
    );
end entity key_schedule;

architecture Behavioral of key_schedule is
    
    -- Inversing the bits of PHI to respect Serpent spec
    constant PHI : std_logic_vector(31 downto 0) := reverse_bits(X"9E3779B9");
    
    -- Define the type of Generated Keys array
    type pre_key_array is array(-8 to 131) of std_logic_vector(31 downto 0);
    
    -- Sbox 4-bits will be applied 32 times on the calculated pre_key and stored in this type of array
    type interm_key is array(0 to 3) of std_logic_vector(31 downto 0);
    
begin

    process (key_in)
        -- To store the prekey
        variable pre_key : pre_key_array;
        -- variable for holding the generated round or subkey
        variable round_k : std_logic_vector(127 downto 0);
--        variable inv_key_in : std_logic_vector(255 downto 0);
        -- To hold the index(i) but in little endian, used when calculating the pre_keys
        variable i_little_endian : std_logic_vector(31 downto 0);
        -- Will hold the input for the SBox 4-bits
        variable bit_input : std_logic_vector(3 downto 0);
        -- Will store the output of the SBox 4-bits
        variable sbox_output : std_logic_vector(3 downto 0);
        variable k_temp : interm_key;
        -- Variable to choose which SBox to use
        variable whichS : integer;
        
    begin
        
--        inv_key_in := key_in;
        -- Dividing the 256-bits key to 8 32-bits vector
        pre_key(-8) := reverse_bits(key_in(31 downto 0));
        pre_key(-7) := reverse_bits(key_in(63 downto 32));
        pre_key(-6) := reverse_bits(key_in(95 downto 64));
        pre_key(-5) := reverse_bits(key_in(127 downto 96));
        pre_key(-4) := reverse_bits(key_in(159 downto 128));
        pre_key(-3) := reverse_bits(key_in(191 downto 160));
        pre_key(-2) := reverse_bits(key_in(223 downto 192));
        pre_key(-1) := reverse_bits(key_in(255 downto 224));
        
        -- Calculating the pre_key following the defined formula in Serpent spec
        for i in 0 to 131 loop
            i_little_endian := reverse_bits(std_logic_vector(to_unsigned(i, 32)));        
            pre_key(i) := std_logic_vector(rotate_right(unsigned(pre_key(i-8)) xor unsigned(pre_key(i-5)) xor unsigned(pre_key(i-3)) xor unsigned(pre_key(i-1)) xor unsigned(i_little_endian) xor unsigned(PHI), 11));
        end loop;

        -- Apply the S-boxes in bitslice mode
        for i in 0 to 32 loop

            -- Determine which S-box to use based on the round number
             whichS := (32 + 3 - i) mod 8;

            -- Clear k_temp for the next round
            k_temp(0) := (others => '0');
            k_temp(1) := (others => '0');
            k_temp(2) := (others => '0');
            k_temp(3) := (others => '0');
            
            -- Iterate over the 32 bits in each 4-word group
            for j in 0 to 31 loop
                -- Prepare the 4-bit input for the S-box
                bit_input(0) := reverse_bits(pre_key(4*i + 3))(j);
                bit_input(1) := reverse_bits(pre_key(4*i + 2))(j);
                bit_input(2) := reverse_bits(pre_key(4*i + 1))(j);
                bit_input(3) := reverse_bits(pre_key(4*i + 0))(j);
                
                -- Apply the S-box
                sbox_output := apply_sbox4(whichS, bit_input);
                
                -- Place the S-box output bits into the corresponding positions in k_temp
                k_temp(0)(j) := sbox_output(3);
                k_temp(1)(j) := sbox_output(2);
                k_temp(2)(j) := sbox_output(1);
                k_temp(3)(j)  := sbox_output(0);
                
            end loop;
            
            -- Round key will be the concatenating of 4 32-bits vector calculated after the SBox
            round_k := k_temp(3) & k_temp(2) & k_temp(1) & k_temp(0);
             -- Applying the IP as last step for each round key
            round_k := apply_IP(reverse_bits(round_k));
            
            round_keys(i) <= round_k;
            
        end loop;

    end process;

end Behavioral;
