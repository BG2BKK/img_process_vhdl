library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

entity image_process is
generic (
			constant data_width : integer := 8;
            constant addr_cnt	: integer := 20	;
			constant img_width	: integer := 320;
			constant img_height	: integer := 240;
			constant rom_depth	: integer := 76800;
			constant alt_tap_2_2	: integer := 319;
			constant alt_tap_3_3	: integer := 318;
			constant alt_tap_5_5	: integer := 316;
			constant window_size_2_2 : integer := 2;
			constant window_size_3_3 : integer := 3;
			constant window_size_5_5 : integer := 5
			
			--constant data_width : integer := 8;
            --constant addr_cnt	: integer := 10	;			
			--constant img_width	: integer := 16;
			--constant img_height	: integer := 16;
			--constant rom_depth	: integer := 256;
			--constant alt_tap_2_2	: integer := 15;
			--constant alt_tap_3_3	: integer := 14;
			--constant alt_tap_5_5	: integer := 12;
			--constant window_size_2_2 : integer := 2;
			--constant window_size_3_3 : integer := 3; 
			--constant window_size_5_5 : integer := 5
);
port (
		clk : in std_logic;
		en : in std_logic;
		rst : in std_logic;
			
--		r33, r32, r31, r23,r22,r21,r13,r12,r11 : out std_logic_vector(data_width-1 downto 0)		
		gaussian_valid : out std_logic;
		gaussian_data: out std_logic_vector(data_width - 1 downto  0)
	  );
end image_process;

architecture behavior of image_process is

	component sys_ctl is
	port (
			clk : in std_logic;
			en : in std_logic;
			rst : in std_logic;
			sys_ctl_en : out std_logic
		);
	end component;
	component rom	
	generic (
			data_width : integer ;
            addr_cnt	:integer ;
			rom_depth  : integer 
	);	
    port(
			clk : in std_logic;
			en : in std_logic;
			addr : in std_logic_vector(addr_cnt -1  downto 0);
			data : out std_logic_vector(data_width -1  downto 0)
        );
    end component;		

	component rom_ctl is
	generic (
				data_width  : integer ;
				addr_cnt	: integer ;
				img_width	: integer ;
				rom_depth	: integer ;
				img_height	: integer 
	);
	port (
			clk : in std_logic;
			en  : in std_logic;
			rst : in std_logic;
			addr : out std_logic_vector(addr_cnt-1 downto 0);
			pix_addr : out std_logic_vector(addr_cnt-1 downto 0);
			stream_on : out std_logic;
			col : out std_logic_vector(addr_cnt -1 downto 0);
			row : out std_logic_vector(addr_cnt -1 downto 0)
		);
	end component;
	
	component gaussian_filter is
	generic (
				constant data_width : integer := 8;
				constant addr_cnt	: integer := 20	;
				constant img_width	: integer := 320;
				constant img_height	: integer := 240;
				constant rom_depth	: integer := 76800;
				constant alt_tap_2_2	: integer := 319;
				constant alt_tap_3_3	: integer := 318;
				constant alt_tap_5_5	: integer := 316;
				constant window_size_2_2 : integer := 2;
				constant window_size_3_3 : integer := 3;
				constant window_size_5_5 : integer := 5
	);
	port (
			clk : in std_logic;
			rst : in std_logic;		
			en	: in std_logic;
			stream_on : in std_logic;
			din: in std_logic_vector(data_width - 1 downto 0);			
			stream_out : out std_logic;
			dout : out std_logic_vector(data_width-1 downto 0)
		);
	end component;

	signal s_ctl_en: std_logic;	
	signal s_rom_addr : std_logic_vector(addr_cnt -1  downto 0);

	signal s_rom_out: std_logic_vector(data_width -1 downto 0);
	signal s_stream_on : std_logic;
	
	signal s_gaussian_valid : std_logic;
	signal s_gaussian_data : std_logic_vector(data_width - 1 downto 0);

begin
	
	sysctl : sys_ctl
	port map (
          clk => clk,
          en =>  en,
		  rst => rst,
		  sys_ctl_en => s_ctl_en
    );
	
	img: rom 
	generic map(
		data_width	=> data_width,
		addr_cnt	=> addr_cnt,
		rom_depth	=> rom_depth
	)
	port map (
          clk => clk,
          en => s_ctl_en,
          addr => s_rom_addr,
		  data => s_rom_out
    );
	img_read : rom_ctl
	generic map(
		data_width	=> data_width,
		addr_cnt	=> addr_cnt,
		img_width	=> img_width,
		img_height 	=> img_height,
		rom_depth	=> rom_depth
	)
	port map(
		clk => clk,
		rst => rst,
		en 	=> s_ctl_en,
		stream_on => s_stream_on,
		addr => s_rom_addr
	);
	
	gaussian : gaussian_filter
	generic map(
			data_width	=> data_width,
			addr_cnt	=> addr_cnt,
			img_width	=> img_width,
			img_height 	=> img_height,
			rom_depth	=> rom_depth,
			alt_tap_3_3	=> alt_tap_3_3,
			window_size_3_3	=> window_size_3_3
	)
	port map(
		clk	=> clk,
		rst => rst,
		en	=> s_ctl_en,

		stream_on => s_stream_on,
		din => s_rom_out,
		stream_out => s_gaussian_valid,
		dout	=> s_gaussian_data
	);
	
	gaussian_valid <= s_gaussian_valid;
	gaussian_data <= s_gaussian_data;
end behavior;

