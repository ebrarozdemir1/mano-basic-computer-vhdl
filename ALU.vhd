library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        A       : in  STD_LOGIC_VECTOR(7 downto 0);
        B       : in  STD_LOGIC_VECTOR(7 downto 0);
        Sel     : in  STD_LOGIC_VECTOR(1 downto 0);  -- 00: AND, 01: OR, 10: XOR, 11: BOOTH MUL
        Result  : out STD_LOGIC_VECTOR(7 downto 0)   -- 8-bit result for Booth
    );
end ALU;

architecture Behavioral of ALU is

    signal A_signed, B_signed : signed(7 downto 0);
    signal Mul_Result         : signed(7 downto 0);
    signal logic_result       : STD_LOGIC_VECTOR(7 downto 0);

begin

    A_signed <= signed(A);
    B_signed <= signed(B);

    process (A, B, Sel)
    begin
        case Sel is
            when "00" =>  -- AND
				
                logic_result(7 downto 0) <= A and B;
                Result <= logic_result;
					 
            when "01" =>  -- OR
				
                logic_result(3 downto 0) <= A or B;
                Result <= logic_result;
					 
            when "10" =>  -- XOR
				
                logic_result(3 downto 0) <= A xor B;
                Result <= logic_result;
					 
            when "11" => --NOT 
					  Result <= NOT A;
					  
            when others =>
                Result <= (others => '0');
        end case;
    end process;

end Behavioral;
