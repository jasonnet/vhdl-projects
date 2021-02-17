-------------------------------------------------------------------------------
-- File Downloaded from http://www.nandland.com
-------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
 
entity module_dual_ring_node is
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
end module_dual_ring_node;
 
architecture behave of module_dual_ring_node is
 
  signal r_FWARD_DATA : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_FFIFO1ST_EMPTY : std_logic;
  signal r_FWARD_1_DOXFER : std_logic;
  signal r_FFIFO2ND_FULL : std_logic;
  signal s_FWARD_2_EMPTY : std_logic;
  signal r_FWARD_2_DOXFER : std_logic;
   
  signal r_BWARD_DATA : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_BFIFO1ST_EMPTY : std_logic;
  signal r_BWARD_1_DOXFER : std_logic;
  signal r_BFIFO2ND_FULL : std_logic;
  signal s_BWARD_2_EMPTY : std_logic;
  signal r_BWARD_2_DOXFER : std_logic;
   
  component module_fifo_regs_with_flags is
    generic (
      g_WIDTH    : natural := g_WIDTH; --8;
      g_DEPTH    : integer := g_DEPTH; --32;
      g_AF_LEVEL : integer := g_AF_LEVEL; --28;
      g_AE_LEVEL : integer := g_AE_LEVEL --4
      );
    port (
      i_rst_sync : in std_logic;
      i_clk      : in std_logic;
 
      -- FIFO Write Interface
      i_wr_en   : in  std_logic;
      i_wr_data : in  std_logic_vector(g_WIDTH-1 downto 0);
      o_af      : out std_logic;
      o_full    : out std_logic;
 
      -- FIFO Read Interface
      i_rd_en   : in  std_logic;
      o_rd_data : out std_logic_vector(g_WIDTH-1 downto 0);
      o_ae      : out std_logic;
      o_empty   : out std_logic
      );
  end component module_fifo_regs_with_flags;
 
   
begin
 
  FIFO_FWARD_1ST : module_fifo_regs_with_flags
    port map (
      i_rst_sync => i_rst_sync,
      i_clk      => i_clk,
      i_wr_en    => i_fw_wr_en,
      i_wr_data  => i_fw_wr_data,
      --o_af       => o_fw_af,
      o_full     => o_fw_full,
      i_rd_en    => r_FWARD_1_DOXFER,
      o_rd_data  => r_FWARD_DATA,
      --o_ae       => w_AE,
      o_empty    => r_FFIFO1ST_EMPTY
      );

  r_FWARD_1_DOXFER <= (not r_FFIFO1ST_EMPTY) and (not r_FFIFO2ND_FULL);
 
 FIFO_FWARD_2ND : module_fifo_regs_with_flags
    port map (
      i_rst_sync => i_rst_sync,
      i_clk      => i_clk,
      i_wr_en    => r_FWARD_1_DOXFER,
      i_wr_data  => r_FWARD_DATA,
      --o_af       => w_AF,
      o_full     => r_FFIFO2ND_FULL,
      i_rd_en    => r_FWARD_2_DOXFER,
      o_rd_data  => o_fw_rd_data,
      --o_ae       => o_fw_ae,
      o_empty    => s_FWARD_2_EMPTY
      );
 
  r_FWARD_2_DOXFER <= (not s_FWARD_2_EMPTY) and (not i_fw_next_full);
  o_fw_do_xfer    <= r_FWARD_2_DOXFER;

     
  FIFO_BWARD_1ST : module_fifo_regs_with_flags
    port map (
      i_rst_sync => i_rst_sync,
      i_clk      => i_clk,
      i_wr_en    => i_bw_wr_en,
      i_wr_data  => i_bw_wr_data,
      --o_af       => o_bw_af,
      o_full     => o_bw_full,
      i_rd_en    => r_BWARD_1_DOXFER,
      o_rd_data  => r_BWARD_DATA,
      --o_ae       => w_AE,
      o_empty    => r_BFIFO1ST_EMPTY
      );

  r_BWARD_1_DOXFER <= (not r_BFIFO1ST_EMPTY) and (not r_BFIFO2ND_FULL);
 
  FIFO_BWARD_2ND : module_fifo_regs_with_flags
    port map (
      i_rst_sync => i_rst_sync,
      i_clk      => i_clk,
      i_wr_en    => r_BWARD_1_DOXFER,
      i_wr_data  => r_BWARD_DATA,
      --o_af       => w_AF,
      o_full     => r_BFIFO2ND_FULL,
      i_rd_en    => r_BWARD_2_DOXFER,
      o_rd_data  => o_bw_rd_data,
      --o_ae       => o_bw_ae,
      o_empty    => s_BWARD_2_EMPTY
      );

  r_BWARD_2_DOXFER <= (not s_BWARD_2_EMPTY) and (not i_bw_next_full);
  o_bw_do_xfer    <= r_BWARD_2_DOXFER;
     
end behave;
