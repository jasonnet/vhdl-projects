-------------------------------------------------------------------------------
-- File Downloaded from http://www.nandland.com
-------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
 
entity module_cluster is
  generic (
    g_WIDTH    : natural := 8;
    g_DEPTH    : integer := 32;
    g_AF_LEVEL : integer := 28;
    g_AE_LEVEL : integer := 4
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
end module_cluster;
 
architecture behave of module_cluster is
 
  --constant c_DEPTH    : integer := 4;
  --constant c_WIDTH    : integer := 8;
  --constant c_AF_LEVEL : integer := 2;
  --constant c_AE_LEVEL : integer := 2;
 
  --signal r_RESET   : std_logic := '0';
  --signal r_CLOCK   : std_logic := '0';
  --signal r_WR_EN   : std_logic := '0';
  --signal r_WR_DATA : std_logic_vector(c_WIDTH-1 downto 0) := X"A5";
  --signal w_AF      : std_logic;
  --signal w_FULL    : std_logic;
  --signal r_RD_EN   : std_logic := '0';
  --signal w_RD_DATA : std_logic_vector(c_WIDTH-1 downto 0);
  --signal w_AE      : std_logic;
  --signal w_EMPTY   : std_logic;

  signal r_DATA_S00_D01 : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_DATA_S01_D00 : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_DO_XFER_S00_D01 : std_logic;
  signal r_FIFO_NODE00S00D01_EMPTY : std_logic;
  signal r_FIFO_NODE01S00D01_FULL : std_logic;
   
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
 
  FIFO_NODE00_OUT_TO_01 : module_fifo_regs_with_flags
    --generic map (
      --g_WIDTH    : natural := g_WIDTH; --8;
      --g_DEPTH    : integer := g_DEPTH; --32;
      --g_AF_LEVEL : integer := g_AF_LEVEL; --28;
      --g_AE_LEVEL : integer := g_AE_LEVEL; --4
    port map (
      i_rst_sync => i_rst_sync, --r_RESET,
      i_clk      => i_clk, --CLOCK,
      i_wr_en    => i_wr_en, --r_WR_EN,
      i_wr_data  => i_wr_data, --r_WR_DATA,
      --o_af       => w_AF,
      o_full     => o_full, --w_FULL,
      i_rd_en    => r_DO_XFER_S00_D01,
      o_rd_data  => r_DATA_S00_D01,
      --o_ae       => w_AE,
      o_empty    => r_FIFO_NODE00S00D01_EMPTY
      );

  FIFO_NODE01_IN_FROM_00 : module_fifo_regs_with_flags
    --generic map (
      --g_WIDTH    => c_WIDTH,
      --g_DEPTH    => c_DEPTH,
      --g_AF_LEVEL => c_AF_LEVEL,
      --g_AE_LEVEL => c_AE_LEVEL
      --)
    port map (
      i_rst_sync => i_rst_sync, --r_RESET,
      i_clk      => i_clk, --r_CLOCK,
      i_wr_en    => r_DO_XFER_S00_D01,
      i_wr_data  => r_DATA_S00_D01,
      --o_af       => w_AF,
      o_full     => r_FIFO_NODE01S00D01_FULL,
      i_rd_en    => i_rd_en, --r_RD_EN,
      o_rd_data  => o_rd_data, --w_RD_DATA,
      --o_ae       => w_AE,
      o_empty    => o_empty --w_EMPTY
      );
 
  --r_CLOCK <= not r_CLOCK after 5 ns;
  r_DO_XFER_S00_D01 <= (not r_FIFO_NODE00S00D01_EMPTY) and (not r_FIFO_NODE01S00D01_FULL);
     
end behave;
