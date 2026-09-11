library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MAIN is
    Port (
        clk : in std_logic;
        instr : in std_logic_vector(15 downto 0);  -- Komut giriþi
        wr_data_ar : in std_logic_vector(10 downto 0); -- Örnek yazma verisi
        wr_data_pc : in std_logic_vector(10 downto 0);
        wr_data_ac : in std_logic_vector(15 downto 0);
        wr_data_inpr : in std_logic_vector(7 downto 0);
        ld_ir : in std_logic;
        clr : in std_logic;
        LD : in std_logic;
        inr : in std_logic
    );
end MAIN;

architecture Behavioral of MAIN is

-- COMPONENT TANIMLARI

component TR is
port(clk : in std_logic;
     CLR : in std_logic;
     LD  : in std_logic;
     wr_data  : in std_logic_vector(3 downto 0);
     rd_data  : out std_logic_vector(3 downto 0)
);
end component;

component AR is
    port (
        clk     : in std_logic;
        CLR     : in std_logic;
        LD      : in std_logic;
        INR     : in std_logic;
        wr_data : in std_logic_vector(10 downto 0);
        rd_data : out std_logic_vector(10 downto 0)
    );
end component;

component PC is
    port (
        clk     : in std_logic;
        CLR     : in std_logic;
        LD      : in std_logic;
        INR     : in std_logic;
        wr_data : in std_logic_vector(10 downto 0);
        rd_data : out std_logic_vector(10 downto 0)
    );
end component;

component IR is
    Port (
        instr     : in  std_logic_vector(15 downto 0);
        clk       : in  std_logic;
        LD        : in  std_logic;
        opc_out   : out std_logic_vector(2 downto 0);
        addr_out  : out std_logic_vector(10 downto 0);
        reg_cmd   : out std_logic_vector(10 downto 0);
        is_d7     : out std_logic
    );
end component;

component AC is
    port (
        clk     : in std_logic;
        CLR     : in std_logic;
        LD      : in std_logic;
        INR     : in std_logic;
        wr_data : in std_logic_vector(3 downto 0);
        rd_data : out std_logic_vector(3 downto 0)
    );
end component;

component INPR is
    Port (
        clk      : in  std_logic;
        wr_data  : in  std_logic_vector(3 downto 0);
        rd_data  : out std_logic_vector(3 downto 0) 
    );
end component;

component OUTR is
    Port (
        clk      : in  std_logic;
        LD       : in  std_logic;
        wr_data  : in  std_logic_vector(7 downto 0);
        rd_data  : out std_logic_vector(7 downto 0)
    );
end component;

-- SÝNYALLER
signal opc_out  : std_logic_vector(2 downto 0);
signal addr_out : std_logic_vector(10 downto 0);
signal reg_cmd  : std_logic_vector(10 downto 0);
signal is_d7    : std_logic;
signal ac_data  : std_logic_vector(3 downto 0);
signal inpr_data : std_logic_vector(3 downto 0);
signal outr_data : std_logic_vector(7 downto 0);
signal temp : std_logic;
signal ien : std_logic := '0';
signal s   : std_logic := '1';
signal SC  : std_logic := '0';
signal ar_data : std_logic_vector(10 downto 0);
signal pc_read : std_logic_vector(10 downto 0);
signal pc_data : std_logic_vector(10 downto 0) := (others => '0');
signal ld_pc_internal      : std_logic := '0';
signal wr_data_outr        : std_logic_vector(7 downto 0);
signal ld_outr             : std_logic := '0';
signal ld_TR_internal      : std_logic := '0';
signal wr_data_TR_internal : std_logic_vector(3 downto 0) := (others => '0');
signal TR_data : std_logic_vector(3 downto 0);




-- RAM örneði (M bellek)
type mem_type is array (0 to 2047) of std_logic_vector(15 downto 0);
signal M : mem_type := (others => (others => '0'));

begin

-- IR bileþeni
IR_U : IR
    port map (
        instr    => instr,
        clk      => clk,
        LD       => ld_ir,
        opc_out  => opc_out,
        addr_out => addr_out,
        reg_cmd  => reg_cmd,
        is_d7    => is_d7
    );

-- INPR bileþeni
INPR_U : INPR
    port map (
        clk      => clk,
        wr_data  => wr_data_inpr,
        rd_data  => inpr_data
    );

-- OUTR bileþeni
OUTR_U : OUTR
    port map (
        clk      => clk,
        LD       => ld_outr,
        wr_data  => ac_data(7 downto 0),
        rd_data  => outr_data
    );

-- AC bileþeni
AC_U : AC
    port map (
        clk      => clk,
        CLR      => clr,
        LD       => ld,
        INR      => inr,
        wr_data  => wr_data_ac,
        rd_data  => ac_data
    );
	
-- AR bileþeni
AR_U : AR
    port map (
        clk     => clk,
        CLR     => clr,
        LD      => ld,
        INR     => inr,
        wr_data => wr_data_ar,
        rd_data => ar_data
    );

-- PC bileþeni
PC_U : PC
    port map (
        clk     => clk,
        CLR     => clr,
        LD      => ld_pc_internal,
        INR     => inr,
        wr_data => pc_data,
        rd_data => pc_read
    );

-- TR bileþeni
TR_U : TR
    port map (
        clk     => clk,
        CLR     => clr,
        LD      => ld_TR_internal,
        INR     => inr,
        wr_data => wr_data_TR_internal,
        rd_data => TR_data
    );
process(clk)
begin
    if rising_edge(clk) then
        -- Her saat darbesinde kontrol sinyalleri sýfýrlanýr
        ld_pc_internal <= '0';
        ld_outr <= '0';
        ld_TR_internal <= '0';

        if is_d7 = '0' then
            case opc_out is

                when "000" =>  -- D0: AND
                    wr_data_TR_internal <= M(to_integer(unsigned(addr_out)))(3 downto 0);
                    ld_TR_internal <= '1';
                    ac_data <= std_logic_vector(unsigned(ac_data) and unsigned(TR_data));
                    SC <= '0';

                when "001" =>  -- D1: OR
                    wr_data_TR_internal <= M(to_integer(unsigned(addr_out)))(3 downto 0);
                    ld_TR_internal <= '1';
                    ac_data <= std_logic_vector(unsigned(ac_data) or unsigned(TR_data));
                    SC <= '0';

                when "010" =>  -- D2: STA
                    M(to_integer(unsigned(addr_out))) <= (others => '0');
                    M(to_integer(unsigned(addr_out)))(3 downto 0) <= ac_data;
                    SC <= '0';

                when "011" =>  -- D3: BUN
                    wr_data_pc_internal <= ar_data;
                    ld_pc_internal <= '1';
                    SC <= '0';

                when "100" =>  -- D4: PCP
                    wr_data_pc_internal <= (others => '0');
                    ld_pc_internal <= '1';
                    SC <= '0';

                when "101" =>  -- D5: ADD
                    wr_data_TR_internal <= M(to_integer(unsigned(addr_out)))(3 downto 0);
                    ld_TR_internal <= '1';
                    ac_data <= std_logic_vector(unsigned(ac_data) + unsigned(TR_data));
                    SC <= '0';

                when "110" =>  -- D6: LDA
                    wr_data_TR_internal <= M(to_integer(unsigned(addr_out)))(3 downto 0);
                    ld_TR_internal <= '1';
                    ac_data <= TR_data;
                    SC <= '0';

                when others =>
                    null;
            end case;

        else
            -- D7: Register-reference iþlemleri
            if reg_cmd(3) = '1' then -- RND
						
						
					 -- TR(0-2) ile TR(1-3) bits sola kaydýrýlýyor
					 wr_data_TR_internal(1 to 3) <= TR_data(0 to 2);
					 ld_TR_internal <= '1'; -- TR register'ý güncellenecek

					 -- XOR iþlemi: TR(3) xor TR(1)
					 temp <= TR_data(3) xor TR_data(1);
					 
					 -- AC'nin 0. biti temp'e atanýyor
					 ac_data(0) <= temp;

					 -- AC'nin 3. biti sýfýrlanýyor
					 ac_data(3) <= '0';

					

            elsif reg_cmd(4) = '1' then -- IOF
                ien <= '0';

            elsif reg_cmd(5) = '1' then -- ION
                ien <= '1';

            elsif reg_cmd(6) = '1' then -- OUT
                wr_data_outr <= ac_data(3 downto 0);
                ld_outr <= '1';

            elsif reg_cmd(7) = '1' then -- INP
                ac_data(3 downto 0) <= inpr_data;

            elsif reg_cmd(8) = '1' then -- HLT
                s <= '0';

            elsif reg_cmd(9) = '1' then -- STP
                if M(to_integer(unsigned(addr_out))) = "0000" then
                    wr_data_outr <= "01000100"; -- 'D'
                    ld_outr <= '1';
                elsif unsigned(M(to_integer(unsigned(addr_out)))) > "0000" then
                    wr_data_outr <= "01100010"; -- 'b'
                    ld_outr <= '1';
                else
                    wr_data_outr <= "01101011"; -- 'k'
                    ld_outr <= '1';
                end if;

            elsif reg_cmd(10) = '1' then -- CMA
                ac_data <= not ac_data;
            end if;
        end if;
    end if;
end process;



end Behavioral;
