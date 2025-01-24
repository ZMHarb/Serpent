library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

package MYPACKAGE is
     -- constants
     -- data types
     -- components
     -- sub routines
     
    -- Function to convert a `std_logic_vector` to a string representation
    -- Used for Debugging
    function vector_to_string ( a: std_logic_vector) return string;
    
    -- Function to reverse the bits in a given `std_logic_vector`
    function reverse_bits(in_vec: std_logic_vector) return std_logic_vector;
    
    -- Function to apply a 4-bit S-box transformation based on the S-box selection (`sbox_sel`) and 4-bit input (x)
    function apply_sbox4(sbox_sel : integer; x : std_logic_vector(3 downto 0)) return std_logic_vector;
    
    -- Function to apply a 32-bit S-box transformation based on the S-box selection (`sbox_sel`) and 32-bit input (x)
    function apply_sbox32(sbox_sel : integer; x : std_logic_vector(31 downto 0)) return std_logic_vector;

    -- Function to apply a 128-bit S-box transformation based on the S-box selection (`sbox_sel`) and 128-bit input (x)
    function apply_sbox128(sbox_sel : integer; x : std_logic_vector(127 downto 0)) return std_logic_vector;
   
    -- Subtype for a 4-bit vector, used for S-boxes
    subtype sbox_vector is std_logic_vector(3 downto 0);

    -- Array type representing an S-box with 16 entries, each a 4-bit vector
    type sbox_array is array(0 to 15) of sbox_vector;
    
    -- Array type representing 8 S-boxes, each with 16 4-bit entries
    type sboxes_array is array(0 to 7) of sbox_array;
    
    -- Array type representing a 33x128-bit structure (used for round key storage or transformations)
    type array_33x128 is array(0 to 32) of std_logic_vector(127 downto 0);
    
    -- Constant array containing 8 S-boxes with predefined values
    constant sboxes: sboxes_array := (
        
("1100", "0111", "0101", "1110", "1111", "0010", "1010", "1001", "0001", "1011", "0110", "0000", "1000", "0100", "1101", "0011"),
("1111", "1000", "1001", "0110", "0100", "0111", "1010", "1100", "0011", "1101", "0000", "1011", "1110", "0001", "0101", "0010"),
("0001", "1011", "1100", "0000", "1110", "0111", "0101", "1010", "0110", "1000", "0011", "1101", "1001", "0010", "1111", "0100"),
("0000", "1011", "0011", "0101", "1101", "0100", "0110", "1010", "1111", "1000", "1001", "1110", "0001", "0010", "1100", "0111"),
("1000", "0100", "0011", "1001", "0001", "0010", "1101", "1110", "1111", "1010", "0000", "0111", "1100", "0101", "0110", "1011"),
("1111", "0000", "0010", "1011", "0100", "0111", "1001", "1110", "1010", "1100", "0101", "0110", "1101", "0001", "0011", "1000"),
("1110", "0111", "0001", "1011", "0011", "1000", "0110", "0101", "0100", "1001", "0010", "1100", "1010", "1111", "1101", "0000"),
("1000", "1110", "0111", "1001", "1111", "0011", "0100", "1010", "1011", "0010", "0001", "1100", "0000", "0101", "1101", "0110")
);
 
    -- Function to apply an initial permutation (IP) to a 128-bit vector    
    function apply_IP(ip_in: std_logic_vector(127 downto 0)) return std_logic_vector;
        
    -- Array type for storing the positions used in the initial permutation (IP)  
    type ip_array is array(0 to 127) of integer;
    
    -- Constant IP box array defining the permutation positions for the IP transformation
    constant IP_box: ip_array := (
         0, 32, 64, 96,  1,  33, 65, 97,  2,  34, 66, 98,  3,  35, 67, 99, 
         4, 36, 68, 100, 5,  37, 69, 101, 6,  38, 70, 102, 7,  39, 71, 103, 
         8, 40, 72, 104, 9,  41, 73, 105, 10, 42, 74, 106, 11, 43, 75, 107,
        12, 44, 76, 108, 13, 45, 77, 109, 14, 46, 78, 110, 15, 47, 79, 111,
        16, 48, 80, 112, 17, 49, 81, 113, 18, 50, 82, 114, 19, 51, 83, 115, 
        20, 52, 84, 116, 21, 53, 85, 117, 22, 54, 86, 118, 23, 55, 87, 119, 
        24, 56, 88, 120, 25, 57, 89, 121, 26, 58, 90, 122, 27, 59, 91, 123,
        28, 60, 92, 124, 29, 61, 93, 125, 30, 62, 94, 126, 31, 63, 95, 127  
        );

    -- Function to apply a final permutation (FP) to a 128-bit vector
    function apply_FP(fp_in: std_logic_vector(127 downto 0)) return std_logic_vector;

    -- Array type for storing the positions used in the final permutation (FP)
    type fp_array is array(0 to 127) of integer;
    
    -- Constant FP box array defining the permutation positions for the FP transformation
    constant FP_box: fp_array := (
         0,  4,  8, 12, 16, 20, 24, 28, 32,  36,  40,  44,  48,  52,  56,  60, 
        64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124, 
         1,  5,  9, 13, 17, 21, 25, 29, 33,  37,  41,  45,  49,  53,  57,  61,
        65, 69, 73, 77, 81, 85, 89, 93, 97, 101, 105, 109, 113, 117, 121, 125,
         2,  6, 10, 14, 18, 22, 26, 30, 34,  38,  42,  46,  50,  54,  58,  62, 
        66, 70, 74, 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118, 122, 126, 
         3, 7,  11, 15, 19, 23, 27, 31, 35,  39,  43,  47,  51,  55,  59,  63,
        67, 71, 75, 79, 83, 87, 91, 95, 99, 103, 107, 111, 115, 119, 123, 127 
        );
    
    -- Define the integer array with a fixed size for each sub-array
    type integer_array is array (0 to 6) of integer;
    type LTTable_type is array (0 to 127) of integer_array;

    -- Define the LTTable constant with fixed size sub-arrays
    constant LTTable : LTTable_type := (
        (16, 52, 56, 70, 83, 94, 105),
        (72, 114, 125, -1, -1, -1, -1),
        (2, 9, 15, 30, 76, 84, 126),
        (36, 90, 103, -1, -1, -1, -1),
        (20, 56, 60, 74, 87, 98, 109),
        (1, 76, 118, -1, -1, -1, -1),
        (2, 6, 13, 19, 34, 80, 88),
        (40, 94, 107, -1, -1, -1, -1),
        (24, 60, 64, 78, 91, 102, 113),
        (5, 80, 122, -1, -1, -1, -1),
        (6, 10, 17, 23, 38, 84, 92),
        (44, 98, 111, -1, -1, -1, -1),
        (28, 64, 68, 82, 95, 106, 117),
        (9, 84, 126, -1, -1, -1, -1),
        (10, 14, 21, 27, 42, 88, 96),
        (48, 102, 115, -1, -1, -1, -1),
        (32, 68, 72, 86, 99, 110, 121),
        (2, 13, 88, -1, -1, -1, -1),
        (14, 18, 25, 31, 46, 92, 100),
        (52, 106, 119, -1, -1, -1, -1),
        (36, 72, 76, 90, 103, 114, 125),
        (6, 17, 92, -1, -1, -1, -1),
        (18, 22, 29, 35, 50, 96, 104),
        (56, 110, 123, -1, -1, -1, -1),
        (1, 40, 76, 80, 94, 107, 118),
        (10, 21, 96, -1, -1, -1, -1),
        (22, 26, 33, 39, 54, 100, 108),
        (60, 114, 127, -1, -1, -1, -1),
        (5, 44, 80, 84, 98, 111, 122),
        (14, 25, 100, -1, -1, -1, -1),
        (26, 30, 37, 43, 58, 104, 112),
        (3, 118, -1, -1, -1, -1, -1),
        (9, 48, 84, 88, 102, 115, 126),
        (18, 29, 104, -1, -1, -1, -1),
        (30, 34, 41, 47, 62, 108, 116),
        (7, 122, -1, -1, -1, -1, -1),
        (2, 13, 52, 88, 92, 106, 119),
        (22, 33, 108, -1, -1, -1, -1),
        (34, 38, 45, 51, 66, 112, 120),
        (11, 126, -1, -1, -1, -1, -1),
        (6, 17, 56, 92, 96, 110, 123),
        (26, 37, 112, -1, -1, -1, -1),
        (38, 42, 49, 55, 70, 116, 124),
        (2, 15, 76, -1, -1, -1, -1),
        (10, 21, 60, 96, 100, 114, 127),
        (30, 41, 116, -1, -1, -1, -1),
        (0, 42, 46, 53, 59, 74, 120),
        (6, 19, 80, -1, -1, -1, -1),
        (3, 14, 25, 100, 104, 118, -1),
        (34, 45, 120, -1, -1, -1, -1),
        (4, 46, 50, 57, 63, 78, 124),
        (10, 23, 84, -1, -1, -1, -1),
        (7, 18, 29, 104, 108, 122, -1),
        (38, 49, 124, -1, -1, -1, -1),
        (0, 8, 50, 54, 61, 67, 82),
        (14, 27, 88, -1, -1, -1, -1),
        (11, 22, 33, 108, 112, 126, -1),
        (0, 42, 53, -1, -1, -1, -1),
        (4, 12, 54, 58, 65, 71, 86),
        (18, 31, 92, -1, -1, -1, -1),
        (2, 15, 26, 37, 76, 112, 116),
        (4, 46, 57, -1, -1, -1, -1),
        (8, 16, 58, 62, 69, 75, 90),
        (22, 35, 96, -1, -1, -1, -1),
        (6, 19, 30, 41, 80, 116, 120),
        (8, 50, 61, -1, -1, -1, -1),
        (12, 20, 62, 66, 73, 79, 94),
        (26, 39, 100, -1, -1, -1, -1),
        (10, 23, 34, 45, 84, 120, 124),
        (12, 54, 65, -1, -1, -1, -1),
        (16, 24, 66, 70, 77, 83, 98),
        (30, 43, 104, -1, -1, -1, -1),
        (0, 14, 27, 38, 49, 88, 124),
        (16, 58, 69, -1, -1, -1, -1),
        (20, 28, 70, 74, 81, 87, 102),
        (34, 47, 108, -1, -1, -1, -1),
        (0, 4, 18, 31, 42, 53, 92),
        (20, 62, 73, -1, -1, -1, -1),
        (24, 32, 74, 78, 85, 91, 106),
        (38, 51, 112, -1, -1, -1, -1),
        (4, 8, 22, 35, 46, 57, 96),
        (24, 66, 77, -1, -1, -1, -1),
        (28, 36, 78, 82, 89, 95, 110),
        (42, 55, 116, -1, -1, -1, -1),
        (8, 12, 26, 39, 50, 61, 100),
        (28, 70, 81, -1, -1, -1, -1),
        (32, 40, 82, 86, 93, 99, 114),
        (46, 59, 120, -1, -1, -1, -1),
        (12, 16, 30, 43, 54, 65, 104),
        (32, 74, 85, -1, -1, -1, -1),
        (36, 90, 103, 118, -1, -1, -1),
        (50, 63, 124, -1, -1, -1, -1),
        (16, 20, 34, 47, 58, 69, 108),
        (36, 78, 89, -1, -1, -1, -1),
        (40, 94, 107, 122, -1, -1, -1),
        (0, 54, 67, -1, -1, -1, -1),
        (20, 24, 38, 51, 62, 73, 112),
        (40, 82, 93, -1, -1, -1, -1),
        (44, 98, 111, 126, -1, -1, -1),
        (4, 58, 71, -1, -1, -1, -1),
        (24, 28, 42, 55, 66, 77, 116),
        (44, 86, 97, -1, -1, -1, -1),
        (2, 48, 102, 115, -1, -1, -1),
        (8, 62, 75, -1, -1, -1, -1),
        (28, 32, 46, 59, 70, 81, 120),
        (48, 90, 101, -1, -1, -1, -1),
        (6, 52, 106, 119, -1, -1, -1),
        (12, 66, 79, -1, -1, -1, -1),
        (32, 36, 50, 63, 74, 85, 124),
        (52, 94, 105, -1, -1, -1, -1),
        (10, 56, 110, 123, -1, -1, -1),
        (16, 70, 83, -1, -1, -1, -1),
        (0, 36, 40, 54, 67, 78, 89),
        (56, 98, 109, -1, -1, -1, -1),
        (14, 60, 114, 127, -1, -1, -1),
        (20, 74, 87, -1, -1, -1, -1),
        (4, 40, 44, 58, 71, 82, 93),
        (60, 102, 113, -1, -1, -1, -1),
        (3, 18, 72, 114, 118, 125, -1),
        (24, 78, 91, -1, -1, -1, -1),
        (8, 44, 48, 62, 75, 86, 97),
        (64, 106, 117, -1, -1, -1, -1),
        (1, 7, 22, 76, 118, 122, -1),
        (28, 82, 95, -1, -1, -1, -1),
        (12, 48, 52, 66, 79, 90, 101),
        (68, 110, 121, -1, -1, -1, -1),
        (5, 11, 26, 80, 122, 126, -1),
        (32, 86, 99, -1, -1, -1, -1)
    );
    
    -- Function to apply a linear transformation (LT) on a 128-bit vector
    function apply_LT(lt_in: std_logic_vector(127 downto 0)) return std_logic_vector;
       
    -- Function to apply a specific round in the encryption process using round number, round key, and input data
    function apply_round(round_num:integer range 0 to 31; round_key: std_logic_vector(127 downto 0); data_in: std_logic_vector(127 downto 0)) return std_logic_vector;
        
    -- Function to apply padding to a 128-bit input vector
    function apply_padding(data_in: std_logic_vector(127 downto 0)) return std_logic_vector;
        
end MYPACKAGE;

package body MYPACKAGE is 
    
    
    function vector_to_string(a: std_logic_vector) return string is
        -- Initialize an empty string with the same length as the input vector.
        variable b : string (1 to a'length) := (others => NUL); 
        
        -- Initialize an integer to keep track of the current position in the string.
        variable stri : integer := 1; 
    begin
        -- Iterate over each element in the input vector.
        for i in a'range loop 
            -- Convert each bit in the vector to its string representation ('0' or '1').
            b(stri) := std_logic'image(a((i)))(2); 
            
            -- Move to the next position in the string.
            stri := stri + 1; 
        end loop;
        
        -- Return the string representation of the input vector.
        return b; 
    end function;
        
    function reverse_bits(in_vec: std_logic_vector) return std_logic_vector is
        -- Output vector with the same range as the input vector.
        variable out_vec : std_logic_vector(in_vec'range); 
        
        -- Variable to store the calculated reverse index.
        variable reverse_index : integer; 
    begin
        -- Iterate over each bit in the input vector.
        for i in in_vec'range loop 
            -- Calculate the reverse index for each position.
            reverse_index := in_vec'length - 1 - (i - in_vec'low); 
            
            -- Assign the reversed bit to the output vector.
            out_vec(i) := in_vec(reverse_index + in_vec'low); 
        end loop;
        
        -- Return the vector with reversed bits.
        return out_vec; 
    end function;
            
    function apply_sbox4(sbox_sel : integer; x : std_logic_vector(3 downto 0)) return std_logic_vector is
        -- Output vector to store the result.
        variable y : std_logic_vector(3 downto 0); 
    begin
        -- Apply the selected S-Box to the input vector.
        y := sboxes(sbox_sel)(to_integer(unsigned(x))); 
        
        -- Return the result after S-Box transformation.
        return y; 
    end function;
    
    
    function apply_sbox32(sbox_sel : integer; x : std_logic_vector(31 downto 0)) return std_logic_vector is
        -- Output vector to store the result.
        variable y : std_logic_vector(31 downto 0); 
        
        -- Temporary variables for 4-bit chunks.
        variable vector_in, vector_out : std_logic_vector(3 downto 0); 
    begin
        -- Iterate over the 32-bit input vector in chunks of 4 bits.
        for i in 0 to 7 loop 
            -- Extract each 4-bit chunk.
            vector_in := x(4*i+3 downto 4*i); 
            
            -- Apply the S-Box to the chunk.
            vector_out := sboxes(sbox_sel)(to_integer(unsigned(vector_in))); 
            
            -- Store the transformed chunk in the output vector.
            y(4*i+3 downto 4*i) := vector_out; 
        end loop;
        
        -- Return the result after applying the S-Box to all chunks.
        return y; 
    end function;
       
    function apply_sbox128(sbox_sel : integer; x : std_logic_vector(127 downto 0)) return std_logic_vector is
        -- Output vector to store the result.
        variable y : std_logic_vector(127 downto 0); 
        
        -- Temporary variables for 4-bit chunks.
        variable vector_in, vector_out : std_logic_vector(0 to 3); 
    begin
        -- Iterate over the 128-bit input vector in chunks of 4 bits.
        for i in 0 to 31 loop 
            -- Extract each 4-bit chunk.
            vector_in := x(4*i+3 downto 4*i); 
            
            -- Apply the S-Box to the chunk.
            vector_out := sboxes(sbox_sel)(to_integer(unsigned(vector_in))); 
            
            -- Store the transformed chunk in the output vector.
            y(4*i+3 downto 4*i) := vector_out; 
        end loop;
        
        -- Return the result after applying the S-Box to all chunks.
        return y; 
    end function;
    
    function apply_IP(ip_in: std_logic_vector(127 downto 0)) return std_logic_vector is 
        -- Output vector to store the result.
        variable ip_out: std_logic_vector(127 downto 0); 
    begin
        -- Iterate through all bits of the input vector.
        for i in 0 to 127 loop 
            -- Map each bit according to the Initial Permutation (IP) table.
            ip_out(i) := ip_in(IP_box(i)); 
        end loop;
        
        -- Return the permuted vector.
        return ip_out; 
    end function;
    
    function apply_FP(fp_in: std_logic_vector(127 downto 0)) return std_logic_vector is 
        -- Output vector to store the result.
        variable fp_out: std_logic_vector(127 downto 0); 
    begin
        -- Iterate through all bits of the input vector.
        for i in 0 to 127 loop 
            -- Map each bit according to the Final Permutation (FP) table.
            fp_out(i) := fp_in(FP_box(i)); 
        end loop;
        
        -- Return the permuted vector.
        return fp_out; 
    end function;
        
    function apply_LT(lt_in: std_logic_vector(127 downto 0)) return std_logic_vector is
        -- Output vector after the linear transformation.
        variable lt_out: std_logic_vector(0 to 127); 
        
        -- Reversed input vector.
        variable lt_in_inv : std_logic_vector(127 downto 0); 
        
        -- Temporary storage for transformation result.
        variable temp_result : std_logic_vector(127 downto 0); 
    begin
        -- Reverse the input vector bits.
        lt_in_inv := reverse_bits(lt_in); 
        
        -- Iterate through each bit of the output vector.
        for i in 0 to 127 loop 
            -- Initialize the output bit to '0'.
            temp_result(i) := '0'; 
            
            -- Iterate through the specified input bits for this output bit.
            for j in LTTable(i)'range loop 
                if LTTable(i)(j) /= -1 then
                    -- XOR the corresponding input bits.
                    temp_result(i) := temp_result(i) xor lt_in_inv(LTTable(i)(j)); 
                end if;
            end loop;
        end loop;
        
        -- Reverse the transformed result to obtain the final output.
        lt_out := reverse_bits(temp_result); 
    
        -- Return the linearly transformed vector.
        return lt_out; 
    end function;
    
    function apply_round(round_num:integer range 0 to 31; round_key: std_logic_vector(127 downto 0); data_in: std_logic_vector(127 downto 0)) return std_logic_vector is
        -- Output vector after the round transformation.
        variable data_out: std_logic_vector(127 downto 0); 
        
        -- Temporary storage for the XOR operation result.
        variable xor_out: std_logic_vector(127 downto 0); 
        
        -- Temporary storage for the S-Box output.
        variable sbox_out: std_logic_vector(127 downto 0); 
    begin
        -- XOR the round key with the input data.
        xor_out := round_key xor data_in; 
        
        -- Apply the S-Box to the result.
        sbox_out := apply_sbox128(round_num mod 8, xor_out); 
    
        -- Apply the linear transformation (LT) to the S-Box output.
        data_out := apply_LT(sbox_out); 
        
        -- Return the result after the round transformation.
        return data_out; 
    end function;
        
    function apply_padding(data_in: std_logic_vector(127 downto 0)) return std_logic_vector is
        -- Output vector with padding applied.
        variable data_out: std_logic_vector(255 downto 0); 
    begin
        -- Prepend padding bits and a '1' before the original data.
        data_out := (126 downto 0 => '0') & "1" & data_in; 
        
        -- Return the padded vector.
        return data_out; 
    end function;
     
end package body;
