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
 
    -- Forward FIFO Write Interface
    i_fw_wr_en   : in  std_logic;
    i_fw_wr_data : in  std_logic_vector(g_WIDTH-1 downto 0);
    o_fw_af      : out std_logic;
    o_fw_full    : out std_logic;
 
    -- Forward FIFO Read Interface
    i_fw_rd_en   : in  std_logic;
    o_fw_rd_data : out std_logic_vector(g_WIDTH-1 downto 0);
    o_fw_ae      : out std_logic;
    o_fw_empty   : out std_logic
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

  signal r_FWARD_DATA : std_logic_vector(g_WIDTH-1 downto 0);
  signal r_FWARD_DOXFER : std_logic;
  signal r_FFIFO1ST_EMPTY : std_logic;
  signal r_FFIFO2ND_FULL : std_logic;
   
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
    --generic map (
      --g_WIDTH    => c_WIDTH,
      --g_DEPTH    => c_DEPTH,
      --g_AF_LEVEL => c_AF_LEVEL,
      --g_AE_LEVEL => c_AE_LEVEL
      --)
    port map (
      i_rst_sync => i_rst_sync, --r_RESET,
      i_clk      => i_clk, --r_CLOCK,
      i_wr_en    => r_FWARD_DOXFER,
      i_wr_data  => r_FWARD_DATA,
      --o_af       => w_AF,
      o_full     => r_FFIFO2ND_FULL,
      i_rd_en    => i_fw_rd_en, --r_RD_EN,
      o_rd_data  => o_fw_rd_data, --w_RD_DATA,
      o_ae       => o_fw_ae,
      o_empty    => o_fw_empty --w_EMPTY
      );
 
  FIFO_FWARD_2ND : module_fifo_regs_with_flags
    --generic map (
      --g_WIDTH    : natural := g_WIDTH; --8;
      --g_DEPTH    : integer := g_DEPTH; --32;
      --g_AF_LEVEL : integer := g_AF_LEVEL; --28;
      --g_AE_LEVEL : integer := g_AE_LEVEL; --4
    port map (
      i_rst_sync => i_rst_sync, --r_RESET,
      i_clk      => i_clk, --CLOCK,
      i_wr_en    => i_fw_wr_en, --r_WR_EN,
      i_wr_data  => i_fw_wr_data, --r_WR_DATA,
      o_af       => o_fw_af,
      o_full     => o_fw_full, --w_FULL,
      i_rd_en    => r_FWARD_DOXFER,
      o_rd_data  => r_FWARD_DATA,
      --o_ae       => w_AE,
      o_empty    => r_FFIFO1ST_EMPTY
      );

  --r_CLOCK <= not r_CLOCK after 5 ns;
  r_FWARD_DOXFER <= (not r_FFIFO1ST_EMPTY) and (not r_FFIFO2ND_FULL);
     
end behave;
