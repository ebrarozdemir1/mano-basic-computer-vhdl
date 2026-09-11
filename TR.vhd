
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity TR is
port(clk : in std_logic;
     CLR : in std_logic;
     LD  : in std_logic;
     wr_data  : in std_logic_vector(3 downto 0);
     rd_data  : out std_logic_vector(3 downto 0)
);
end TR;

architecture Behavioral of TR is
signal reg : std_logic_vector(3 downto 0) := (others => '0');
begin
	process(clk,CLR)
		begin
			if (CLR='1') then
				reg <= (others => '0');
			elsif (clk'event and clk='1') then
				if (LD='1') then
					reg <= wr_data;
					
				end if;
			end if;
		end process;
rd_data <= reg;

end Behavioral;
