library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is
port(clk : in std_logic;
     CLR : in std_logic;
     LD  : in std_logic;
     INR : in std_logic;
     wr_data  : in std_logic_vector(10 downto 0);
     rd_data  : out std_logic_vector(10 downto 0)
);
end PC;

architecture Behavioral of PC is
signal reg : std_logic_vector(10 downto 0) := (others => '0');
begin
	process(clk,CLR)
		begin
			if (CLR='1') then
				reg <= (others => '0');
			elsif (clk'event and clk='1') then
				if (LD='1') then
					reg <= wr_data;
					if (INR='1') then
						reg <= std_logic_vector(unsigned(reg) + 1);
					end if;
				end if;
			end if;
		end process;
rd_data <= reg;

end Behavioral;