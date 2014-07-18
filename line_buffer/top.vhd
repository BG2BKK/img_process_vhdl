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
		dout : out std_logic_vector(data_width-1 downto 0);
	
--		u0,u1,u2,u3,u4,u5,u6,u7,u8 : out std_logic_vector(data_width + data_width+ data_width -1 downto 0);
--		v0,v1,v2,v3,v4,v5,v6,v7,v8 : out std_logic_vector(data_width + data_width+ data_width -1 downto 0);
--		
--		u0_valid,u1_valid,u2_valid,u3_valid,u4_valid,u5_valid,u6_valid,u7_valid,u8_valid : out std_logic;
--		v0_valid,v1_valid,v2_valid,v3_valid,v4_valid,v5_valid,v6_valid,v7_valid,v8_valid : out std_logic;
		
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
end image_process;

architecture behavior of image_process is

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

	component shift_tab_3_3
	generic (
			data_width	:	integer ;
            addr_cnt	:	integer ;
			alt_tap		:	integer;
			img_width	:	integer;
			img_height	:	integer	;		
			window_size :	integer;
			rom_depth	: integer
	);	
	port (
			clk : in std_logic;
			en : in std_logic;
			rst : in std_logic;
			din : in std_logic_vector(data_width-1 downto 0);
			stream_on : in std_logic;
			r33, r32, r31, r23,r22,r21,r13,r12,r11 : out std_logic_vector(data_width-1 downto 0);
			pix_data_valid: out std_logic;
			pix_col : out std_logic_vector(addr_cnt -1 downto 0);
			pix_row : out std_logic_vector(addr_cnt -1 downto 0);
			pix_addr: out std_logic_vector(addr_cnt - 1 downto 0)			
	  );
	end component;

	signal s_ctl_en: std_logic;	
	signal s_rom_addr : std_logic_vector(addr_cnt -1  downto 0) := (others => '0');
	signal s_rom_out: std_logic_vector(data_width -1 downto 0);
	
	signal s_col : std_logic_vector(addr_cnt -1 downto 0);
	signal s_row : std_logic_vector(addr_cnt -1 downto 0);	
	signal s_pix_addr: std_logic_vector(addr_cnt -1 downto 0);	
	signal s_img_on : std_logic;

	signal edge_gaussian_out_addr: std_logic_vector(addr_cnt -1 downto 0);
	signal edge_gaussian_out_data: std_logic_vector(data_width -1 downto 0);	
	signal edge_gaussian_out_valid: std_logic;		
	
	signal gaussian_out_addr: std_logic_vector(addr_cnt -1 downto 0);
	signal gaussian_out_data: std_logic_vector(data_width -1 downto 0);	
	signal gaussian_out_valid: std_logic;

	signal edge_dete_out_addr: std_logic_vector(addr_cnt -1 downto 0);
	signal edge_dete_out_data: std_logic_vector(data_width -1 downto 0);	
	signal edge_dete_out_valid: std_logic;	
	
	signal s_data_addr : std_logic_vector(addr_cnt - 1 downto 0);
	signal s_data_valid : std_logic;
	
	--img_0 and img_1
	signal s0_r22,s0_r21,s0_r12,s0_r11 : std_logic_vector(data_width -1 downto 0) ;
	signal s_img_0_addr : std_logic_vector(addr_cnt -1  downto 0) ;
	signal s_img_0_on : std_logic;
	signal s_img_0_out: std_logic_vector(data_width -1 downto 0);
	signal s_img_0_data_addr : std_logic_vector(addr_cnt - 1 downto 0);
	signal s_img_0_data_valid : std_logic;
	

begin
	
	dout <= s_Ix(dout'range);
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
          addr => s_img_0_addr,
		  data => s_img_0_out
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
		stream_on => s_img_0_on,
--		col	=> s_col,
--		row => s_row,
--		pix_addr => s_pix_addr,
		addr => s_img_0_addr
	);

	

end behavior;

