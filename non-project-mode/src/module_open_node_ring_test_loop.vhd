-------------------------------------------------------------------------------
-- File Downloaded from http://www.nandland.com
-------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
 
entity module_open_node_ring_test_loop is
  generic (
    g_WIDTH    : natural := 8;
    g_DEPTH    : integer := 32;
    g_AF_LEVEL : integer := 28;
    g_AE_LEVEL : integer := 4
    );
  port (
    i_rst_sync : in std_logic;
    i_clk      : in std_logic;
 
    -- Forward FIFO Write Interface
    i_fw_wr_en   : in  std_logic;
    i_fw_wr_data : in  std_logic_vector(g_WIDTH-1 downto 0);
    --o_fw_af      : out std_logic;
    o_fw_full    : out std_logic;
 
    -- Forward FIFO Read Interface
    --i_fw_rd_en   : in  std_logic;
    o_fw_rd_data : out std_logic_vector(g_WIDTH-1 downto 0);
    --o_fw_ae      : out std_logic;
    --o_fw_empty   : out std_logic;
	i_fw_next_full : in std_logic;
	o_fw_do_xfer   : out std_logic;
	
    -- Backward FIFO Write Interface
    i_bw_wr_en   : in  std_logic;
    i_bw_wr_data : in  std_logic_vector(g_WIDTH-1 downto 0);
    --o_bw_af      : out std_logic;
    o_bw_full    : out std_logic;
 
    -- Backward FIFO Read Interface
    --i_bw_rd_en   : in  std_logic;
    o_bw_rd_data : out std_logic_vector(g_WIDTH-1 downto 0);
    --o_bw_ae      : out std_logic;
    --o_bw_empty   : out std_logic
	i_bw_next_full : in std_logic;
	o_bw_do_xfer   : out std_logic
    );
end module_open_node_ring_test_loop;
 
architecture behave of module_open_node_ring_test_loop is
 
  -- forward
  signal r_S0D1_DO_XFER : std_logic;
  signal r_S0D1_DATA    : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_S0D1_FULL    : std_logic;
  signal r_S1D2_DO_XFER : std_logic;
  signal r_S1D2_DATA    : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_S1D2_FULL    : std_logic;
  signal r_S2D3_DO_XFER : std_logic;
  signal r_S2D3_DATA    : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_S2D3_FULL    : std_logic;
  signal r_S3D4_DO_XFER : std_logic;
  signal r_S3D4_DATA    : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_S3D4_FULL    : std_logic;

  -- backward
  signal r_S1D0_DO_XFER : std_logic;
  signal r_S1D0_DATA    : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_S1D0_FULL    : std_logic;
  signal r_S2D1_DO_XFER : std_logic;
  signal r_S2D1_DATA    : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_S2D1_FULL    : std_logic;
  signal r_S3D2_DO_XFER : std_logic;
  signal r_S3D2_DATA    : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_S3D2_FULL    : std_logic;
  signal r_S4D3_DO_XFER : std_logic;
  signal r_S4D3_DATA    : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_S4D3_FULL    : std_logic;

   
  component module_dual_ring_node is
    generic (
      g_WIDTH    : natural := g_WIDTH; --8;
      g_DEPTH    : integer := g_DEPTH; --32;
      g_AF_LEVEL : integer := g_AF_LEVEL; --28;
      g_AE_LEVEL : integer := g_AE_LEVEL --4
      );
    port (
		i_rst_sync : in std_logic;
		i_clk      : in std_logic;
	 
		-- Forward FIFO Write Interface
		i_fw_wr_en   : in  std_logic;
		i_fw_wr_data : in  std_logic_vector(g_WIDTH-1 downto 0);
		--o_fw_af      : out std_logic;
		o_fw_full    : out std_logic;
	 
		-- Forward FIFO Read Interface
		--i_fw_rd_en   : in  std_logic;
		o_fw_rd_data : out std_logic_vector(g_WIDTH-1 downto 0);
		--o_fw_ae      : out std_logic;
		--o_fw_empty   : out std_logic;
		i_fw_next_full : in std_logic;
		o_fw_do_xfer   : out std_logic;
		
		-- Backward FIFO Write Interface
		i_bw_wr_en   : in  std_logic;
		i_bw_wr_data : in  std_logic_vector(g_WIDTH-1 downto 0);
		--o_bw_af      : out std_logic;
		o_bw_full    : out std_logic;
	 
		-- Backward FIFO Read Interface
		--i_bw_rd_en   : in  std_logic;
		o_bw_rd_data : out std_logic_vector(g_WIDTH-1 downto 0);
		--o_bw_ae      : out std_logic;
		--o_bw_empty   : out std_logic
		i_bw_next_full : in std_logic;
		o_bw_do_xfer   : out std_logic
      );
  end component module_dual_ring_node;

 
   
begin

  r_S0D1_DO_XFER <= i_fw_wr_en;
  r_S0D1_DATA    <= i_fw_wr_data;
  o_fw_full      <= r_S0D1_FULL;
  
  o_bw_rd_data <= r_S1D0_DATA;
  r_S1D0_FULL  <= i_bw_next_full;
  o_bw_do_xfer <= r_S1D0_DO_XFER;
 
  NODE04 : module_dual_ring_node
    port map (
      i_rst_sync => i_rst_sync,
      i_clk      => i_clk,
	  
      i_fw_wr_en     => r_SMD0_DO_XFER,
      i_fw_wr_data   => r_SMD0_DATA,
      --o_fw_af       => o_fw_af,
      o_fw_full      => r_SMD0_FULL,

      o_fw_rd_data    => r_S0D1_DATA,
      --o_fw_ae       => w_AE,
	  i_fw_next_full  => r_S0D1_FULL,
      o_fw_do_xfer    => r_S0D1_DO_XFER,
	  
      i_bw_wr_en    => r_S1D0_DO_XFER,
      i_bw_wr_data  => r_S1D0_DATA,
      --o_bw_af       => o_bw_af,
      o_bw_full     => r_S1D0_FULL,

      o_bw_rd_data   => r_S1D0_DATA,
      --o_bw_ae       => w_AE,
	  i_bw_next_full => r_S1D0_FULL,
      o_bw_do_xfer   => r_S1D0_DO_XFER
      );

  NODE1 : module_dual_ring_node
    port map (
      i_rst_sync => i_rst_sync,
      i_clk      => i_clk,
	  
      i_fw_wr_en     => r_S0D1_DO_XFER,
      i_fw_wr_data   => r_S0D1_DATA,
      --o_fw_af       => o_fw_af,
      o_fw_full      => r_S0D1_FULL,

      o_fw_rd_data  => r_S1D2_DATA,
      --o_fw_ae       => w_AE,
	  i_fw_next_full => r_S1D2_FULL,
      o_fw_do_xfer    => r_S1D2_DO_XFER,
	  
      i_bw_wr_en    => r_S2D1_DO_XFER,
      i_bw_wr_data  => r_S2D1_DATA,
      --o_bw_af       => o_bw_af,
      o_bw_full     => r_S2D1_FULL,

      o_bw_rd_data   => r_S1D0_DATA,
      --o_bw_ae       => w_AE,
	  i_bw_next_full => r_S1D0_FULL,
      o_bw_do_xfer   => r_S1D0_DO_XFER
      );

 NODE2 : module_dual_ring_node
    port map (
      i_rst_sync => i_rst_sync,
      i_clk      => i_clk,
	  
      i_fw_wr_en     => r_S1D2_DO_XFER,
      i_fw_wr_data   => r_S1D2_DATA,
      --o_fw_af       => o_fw_af,
      o_fw_full      => r_S1D2_FULL,

      o_fw_rd_data   => r_S2D3_DATA,
      --o_fw_ae       => w_AE,
	  i_fw_next_full => r_S2D3_FULL,
      o_fw_do_xfer   => r_S2D3_DO_XFER,
	  
      i_bw_wr_en     => r_S3D2_DO_XFER,
      i_bw_wr_data   => r_S3D2_DATA,
      --o_bw_af       => o_bw_af,
      o_bw_full      => r_S3D2_FULL,

      o_bw_rd_data   => r_S2D1_DATA,
      --o_bw_ae       => w_AE,
	  i_bw_next_full => r_S2D1_FULL,
      o_bw_do_xfer   => r_S2D1_DO_XFER
      );
 
 NODE3 : module_dual_ring_node
    port map (
      i_rst_sync => i_rst_sync,
      i_clk      => i_clk,
	  
      i_fw_wr_en     => r_S2D3_DO_XFER,
      i_fw_wr_data   => r_S2D3_DATA,
      --o_fw_af       => o_fw_af,
      o_fw_full      => r_S2D3_FULL,

      o_fw_rd_data   => r_S3D4_DATA,
      --o_fw_ae       => w_AE,
	  i_fw_next_full => r_S3D4_FULL,
      o_fw_do_xfer   => r_S3D4_DO_XFER,
	  
      i_bw_wr_en     => r_S4D3_DO_XFER,
      i_bw_wr_data   => r_S4D3_DATA,
      --o_bw_af       => o_bw_af,
      o_bw_full      => r_S4D3_FULL,

      o_bw_rd_data   => r_S3D2_DATA,
      --o_bw_ae       => w_AE,
	  i_bw_next_full => r_S3D2_FULL,
      o_bw_do_xfer   => r_S3D2_DO_XFER
      );

	o_fw_rd_data   <= r_S3D4_DATA;
	r_S3D4_FULL    <= i_fw_next_full;
	o_fw_do_xfer   <= r_S3D4_DO_XFER;
 
	r_S4D3_DO_XFER <= i_bw_wr_en;
	r_S4D3_DATA    <= i_bw_wr_data;
	o_bw_full      <= r_S4D3_FULL;
	     
end behave;
