library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IR is
    Port (
        clk       : in  std_logic;
        clr       : in  std_logic;
        ld        : in  std_logic;
        opc_out   : out std_logic_vector(2 downto 0);   -- Bit 13-11
        addr_out  : out std_logic_vector(10 downto 0);  -- Bit 10-0
        reg_cmd   : out std_logic_vector(10 downto 0);  -- D7 komutu için
        is_d7     : out std_logic                       -- D7 mý? (flag)
    );
end IR;

architecture Behavioral of IR is

    -- Komut belleði (ROM gibi kullanýlabilir)
    type memory_array is array (0 to 2047) of std_logic_vector(15 downto 0);
    signal memory : memory_array := (others => (others => '0')); -- baþlangýçta sýfýr

    -- Dahili sinyaller
    signal pc_data, ar_data : std_logic_vector(10 downto 0);
    signal instruction      : std_logic_vector(15 downto 0);
    signal opc              : std_logic_vector(2 downto 0);

    -- Control sinyalleri
    signal ld_pc_internal  : std_logic := '0';
    signal inr_pc_internal : std_logic := '0';
    signal ld_ar_internal  : std_logic := '0';

    -- Component tanýmlarý
    component PC is
        port(clk     : in std_logic;
             CLR     : in std_logic;
             LD      : in std_logic;
             INR     : in std_logic;
             wr_data : in std_logic_vector(10 downto 0);
             rd_data : out std_logic_vector(10 downto 0)
        );
    end component;

    component AR is
        port(clk     : in std_logic;
             CLR     : in std_logic;
             LD      : in std_logic;
             INR     : in std_logic;
             wr_data : in std_logic_vector(10 downto 0);
             rd_data : out std_logic_vector(10 downto 0)
        );
    end component;

begin

    -- PC instantiation
    pc_inst : PC
    port map (
        clk      => clk,
        CLR      => clr,
        LD       => ld_pc_internal,
        INR      => inr_pc_internal,
        wr_data  => (others => '1'),
        rd_data  => pc_data
    );

    -- AR instantiation
    ar_inst : AR
    port map (
        clk      => clk,
        CLR      => clr,
        LD       => ld_ar_internal,
        INR      => '0',
        wr_data  => pc_data,
        rd_data  => ar_data
    );

    -- FETCH süreci
    process(clk)
    begin
        if rising_edge(clk) then
            if ld = '1' then
                -- 1. AR <- PC
                ld_ar_internal <= '1';

                -- 2. IR <- M[AR]
                instruction <= memory(to_integer(unsigned(ar_data)));

                -- 3. PC <- PC + 1
                inr_pc_internal <= '1';

                -- 4. Decode
                opc <= instruction(13 downto 11);
                opc_out <= opc;

                if opc < "111" then
                    addr_out <= instruction(10 downto 0);
                    reg_cmd  <= (others => '0');
                    is_d7    <= '0';

                elsif opc = "111" then
                    addr_out <= (others => '0');
                    reg_cmd  <= instruction(10 downto 0);
                    is_d7    <= '1';

                else
                    addr_out <= (others => '0');
                    reg_cmd  <= (others => '0');
                    is_d7    <= '0';
                end if;

            else
                ld_ar_internal     <= '0';
                inr_pc_internal    <= '0';
            end if;
        end if;
    end process;

end Behavioral;
