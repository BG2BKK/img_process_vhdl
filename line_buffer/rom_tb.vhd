library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

use ieee.numeric_std.all;
use std.textio.all;
use work.txt_util.all;
-- uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
--use ieee.numeric_std.all;
 
entity rom_tb is
generic (
			--constant data_width : integer := 8;
            --constant addr_cnt	:integer := 20;
			--constant rom_depth  : integer := 76800
			--			
			constant data_width : integer := 8;
            constant addr_cnt	:integer := 10;
			constant rom_depth  : integer := 256
);
end rom_tb;
 
architecture behavior of rom_tb is 
 
	file gaussian_file: text open write_mode is "gaussian.dat";
	file edge_dete_file: text open write_mode is "edge_dete.dat";
	file edge_gaussian_file: text open write_mode is "edge_gaussian.dat";
	file u8_file: text open write_mode is "u8_result.dat";
	file v8_file: text open write_mode is "v8_result.dat";

	
    component image_process
		 
    port(
			clk : in std_logic;
			en : in std_logic;
			rst : in std_logic;
			dout : out std_logic_vector(data_width-1 downto 0);
			
--			u0,u1,u2,u3,u4,u5,u6,u7,u8 : out std_logic_vector(data_width + data_width+ data_width -1 downto 0);
--			v0,v1,v2,v3,v4,v5,v6,v7,v8 : out std_logic_vector(data_width + data_width+ data_width -1 downto 0);
--			
--			u0_valid,u1_valid,u2_valid,u3_valid,u4_valid,u5_valid,u6_valid,u7_valid,u8_valid : out std_logic;
--			v0_valid,v1_valid,v2_valid,v3_valid,v4_valid,v5_valid,v6_valid,v7_valid,v8_valid : out std_logic;
			
			u8 : out std_logic_vector(data_width + data_width+ data_width -1 downto 0);
			v8 : out std_logic_vector(data_width + data_width+ data_width -1 downto 0);
			u8_valid : out std_logic;
			v8_valid : out std_logic;
			
			simu_edge_gaussian_valid: out std_logic;
			simu_edge_gaussian_data : out std_logic_vector(data_width - 1 downto 0);
			simu_edge_gaussian_addr : out std_logic_vector(addr_cnt - 1 downto 0);
		
			simu_gaussian_valid: out std_logic;
			simu_gaussian_data : out std_logic_vector(data_width - 1 downto 0);
			simu_gaussian_addr : out std_logic_vector(addr_cnt - 1 downto 0);
			
			simu_edge_dete_valid: out std_logic;
			simu_edge_dete_data : out std_logic_vector(data_width - 1 downto 0);
			simu_edge_dete_addr : out std_logic_vector(addr_cnt - 1 downto 0)
        );
    end component;

   --inputs
   signal clk : std_logic := '0';
   signal en : std_logic := '1';
   signal addr : std_logic_vector(addr_cnt-1 downto 0) := (others => '0');
   signal rst : std_logic := '0';

 	--outputs
   signal dout : std_logic_vector(data_width-1 downto 0);

	signal  s_simu_gaussian_valid:std_logic;
	signal	s_simu_gaussian_data : std_logic_vector(data_width - 1 downto 0);
	signal	s_simu_gaussian_addr : std_logic_vector(addr_cnt - 1 downto 0);
	
	signal  s_simu_edge_gaussian_valid:std_logic;
	signal	s_simu_edge_gaussian_data : std_logic_vector(data_width - 1 downto 0);
	signal	s_simu_edge_gaussian_addr : std_logic_vector(addr_cnt - 1 downto 0);
	
	signal  s_simu_edge_dete_valid:std_logic;
	signal	s_simu_edge_dete_data : std_logic_vector(data_width - 1 downto 0);
	signal	s_simu_edge_dete_addr : std_logic_vector(addr_cnt - 1 downto 0);
	
	signal  s_u0, s_u1, s_u2, s_u3, s_u4, s_u5, s_u6, s_u7, s_u8 : std_logic_vector(data_width + data_width+ data_width -1 downto 0);
	signal  s_v0, s_v1, s_v2, s_v3, s_v4, s_v5, s_v6, s_v7, s_v8 : std_logic_vector(data_width + data_width+ data_width -1 downto 0);
	signal 	s_u0_valid, s_u1_valid, s_u2_valid, s_u3_valid, s_u4_valid, s_u5_valid, s_u6_valid, s_u7_valid, s_u8_valid : std_logic;
   -- clock period definitions
   constant clk_period : time := 10 ns;

begin
 
	-- instantiate the unit under test (uut)
   med: image_process port map (
        clk => clk,
        en => en,
        rst => rst,
		dout => dout,
		
--		u0 => s_u0,				u1 => s_u1,					u2 => s_u2,					u3 => s_u3,					u4 => s_u4,	
--		v0 => s_v0,             v1 => s_v1,                 v2 => s_v2,                 v3 => s_v3,                 v4 => s_v4, 
--		u0_valid => s_u0_valid, u1_valid => s_u1_valid,     u2_valid => s_u2_valid,     u3_valid => s_u3_valid,     u4_valid => s_u4_valid,
--		
--		u5 => s_u5,				u6 => s_u6,					u7 => s_u7,					
--		v5 => s_v5,             v6 => s_v6,                 v7 => s_v7,                 
--		u5_valid => s_u5_valid, u6_valid => s_u6_valid,     u7_valid => s_u7_valid,     
		
		u8 => s_u8,	
		v8 => s_v8, 
		u8_valid => s_u8_valid,		

		simu_edge_gaussian_valid  =>  s_simu_edge_gaussian_valid  ,
		simu_edge_gaussian_data   =>  s_simu_edge_gaussian_data   ,
		simu_edge_gaussian_addr   =>  s_simu_edge_gaussian_addr   ,
		
		simu_gaussian_valid => s_simu_gaussian_valid,
		simu_gaussian_data => s_simu_gaussian_data,
		simu_gaussian_addr => s_simu_gaussian_addr,
		
		simu_edge_dete_valid => s_simu_edge_dete_valid,
		simu_edge_dete_data =>  s_simu_edge_dete_data,
		simu_edge_dete_addr =>  s_simu_edge_dete_addr
        );

   -- clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	rst_process: process
	begin
		rst <= '0';
		wait for clk_period * 10;
		rst <= '1';
		en <= '1';
		wait;
	end process;
	
	--gaussian_write : process(s_simu_gaussian_valid,s_simu_gaussian_addr)
	--	variable outline : line;
	--begin
	--	if s_simu_gaussian_valid = '1' then
	--		write(outline, s_simu_gaussian_data);
	--		writeline(gaussian_file, outline);
	--	end if;
	--end process;
	--
	--edge_dete_write : process(s_simu_edge_dete_valid,s_simu_edge_dete_addr)
	--	variable outline : line;
	--begin
	--	if s_simu_edge_dete_valid = '1' then
	--		write(outline, s_simu_edge_dete_data);
	--		writeline(edge_dete_file, outline);
	--	end if;
	--end process;
	--
	--edge_gaussian_write : process(s_simu_edge_gaussian_valid,s_simu_edge_gaussian_addr)
	--	variable outline : line;
	--begin
	--	if s_simu_edge_gaussian_valid = '1' then
	--		write(outline, s_simu_edge_gaussian_data);
	--		writeline(edge_gaussian_file, outline);
	--	end if;
	--end process;
    --
	--
	--uv8_write : process(clk,s_u8_valid,s_simu_gaussian_addr)
	--	variable uline,vline : line;
	--	variable v_u ,v_v: std_logic_vector(s_u8'range);
	--begin
	--	if rising_edge(clk) then
	--		if s_u8_valid = '1' then
	--			v_u := std_logic_vector(abs(signed(s_u8)));
	--			v_v := std_logic_vector(abs(signed(s_v8)));
	--			
	--			write(uline, str(conv_integer(s_u8))&"    "&str(conv_integer(v_u)));
	--			writeline(u8_file, uline);			
    --
	--			write(vline, str(conv_integer(s_v8))&"    "&str(conv_integer(v_v)));				
	--			writeline(v8_file, vline);
	--		end if;
	--	end if;
	--end process;
	


end;
