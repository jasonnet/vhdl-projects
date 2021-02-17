-------------------------------------------------------------------------------
-- File Downloaded from http://www.nandland.com
-------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;
use std.textio.all;             -- provides  file_open, line
use ieee.std_logic_textio.all;  -- provides write of std_logic_vector
 
entity module_open_node_ring_tb is
end module_open_node_ring_tb;
 
architecture behave of module_open_node_ring_tb is
 
  constant c_DEPTH    : integer := 4;
  constant c_WIDTH    : integer := 8;
  constant c_AF_LEVEL : integer := 2;
  constant c_AE_LEVEL : integer := 2;
 
  signal r_RESET   : std_logic := '0';
  signal r_CLOCK   : std_logic := '0';
  
  signal r_FW_WR_EN   : std_logic := '0';
  signal r_FW_WR_DATA : std_logic_vector(c_WIDTH-1 downto 0) := X"A5";
  --signal w_FW_AF      : std_logic;
  signal w_FW_FULL    : std_logic;
  signal r_FW_RD_EN   : std_logic := '0';
  signal w_FW_RD_DATA : std_logic_vector(c_WIDTH-1 downto 0);
  --signal w_FW_AE      : std_logic;
  --signal w_FW_EMPTY   : std_logic;
  signal r_FW_NEXT_FULL : std_logic := '1';
  signal w_FW_DO_XFER : std_logic;

  signal r_BW_WR_EN   : std_logic := '0';
  signal r_BW_WR_DATA : std_logic_vector(c_WIDTH-1 downto 0) := X"25";
  --signal w_BW_AF      : std_logic;
  signal w_BW_FULL    : std_logic;
  signal r_BW_RD_EN   : std_logic := '0';
  signal w_BW_RD_DATA : std_logic_vector(c_WIDTH-1 downto 0);
  --signal w_BW_AE      : std_logic;
  --signal w_BW_EMPTY   : std_logic;
  signal r_BW_NEXT_FULL : std_logic := '1';
  signal w_BW_DO_XFER : std_logic;
  
  
  signal clocktick_count : integer := 0;   -- count of clock ticks for logging
  file output_buf : text; -- text is keyword
   
  component module_open_node_ring is
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
  end component module_open_node_ring;
 
   
begin
 
  module_open_node_ring_INST : module_open_node_ring
    generic map (
      g_WIDTH    => c_WIDTH,
      g_DEPTH    => c_DEPTH,
      g_AF_LEVEL => c_AF_LEVEL,
      g_AE_LEVEL => c_AE_LEVEL
      )
    port map (
      i_rst_sync => r_RESET,
      i_clk      => r_CLOCK,
	  
      i_fw_wr_en    => r_FW_WR_EN,
      i_fw_wr_data  => r_FW_WR_DATA,
      --o_fw_af       => w_FW_AF,
      o_fw_full     => w_FW_FULL,
      --i_fw_rd_en    => r_FW_RD_EN,
      o_fw_rd_data  => w_FW_RD_DATA,
      i_fw_next_full => r_FW_NEXT_FULL,
      o_fw_do_xfer   => w_FW_DO_XFER,
	  
      i_bw_wr_en    => r_BW_WR_EN,
      i_bw_wr_data  => r_BW_WR_DATA,
      --o_bw_af       => w_BW_AF,
      o_bw_full     => w_BW_FULL,
      --i_bw_rd_en    => r_BW_RD_EN,
      o_bw_rd_data  => w_BW_RD_DATA,
      i_bw_next_full => r_BW_NEXT_FULL,
      o_bw_do_xfer   => w_BW_DO_XFER
      );
 
  
    r_CLOCK <= not r_CLOCK after 5 ns;
  
    file_open(output_buf, "logs/sim.writeout", write_mode);
    process is
        variable write_col_to_output_buf : line; -- line is keyword
    begin
        loop
            wait until r_CLOCK = '1';
            wait for 100ps; -- above this line, the tick changes might not have kicked in.  Below it they should have.
            

            -- log tick outputs            
            write(write_col_to_output_buf, clocktick_count,right,5);
            write(write_col_to_output_buf, string'(", FW,  "));
            --write(write_col_to_output_buf, string'(", AF:"));
            --write(write_col_to_output_buf, w_FW_AF, right);
            write(write_col_to_output_buf, string'(", FULL:"));
            write(write_col_to_output_buf, w_FW_FULL, right);
            --write(write_col_to_output_buf, string'(", AE:"));  -- TODO: remove these two
            --write(write_col_to_output_buf, w_FW_AE, right);
            write(write_col_to_output_buf, string'(", DO_XFER:"));
            write(write_col_to_output_buf, w_FW_DO_XFER, right);
            write(write_col_to_output_buf, string'(", OUT:"));
            write(write_col_to_output_buf, w_FW_RD_DATA, right);
            writeline(output_buf, write_col_to_output_buf);

            write(write_col_to_output_buf, clocktick_count,right,5);
            write(write_col_to_output_buf, string'(", BW,  "));
            --write(write_col_to_output_buf, string'(", AF:"));
            --write(write_col_to_output_buf, w_BW_AF, right);
            write(write_col_to_output_buf, string'(", FULL:"));
            write(write_col_to_output_buf, w_BW_FULL, right);
            --write(write_col_to_output_buf, string'(", AE:"));  -- TODO: remove these two
            --write(write_col_to_output_buf, w_BW_AE, right);
            write(write_col_to_output_buf, string'(", DO_XFER:"));
            write(write_col_to_output_buf, w_BW_DO_XFER, right);
            write(write_col_to_output_buf, string'(", OUT:"));
            write(write_col_to_output_buf, w_BW_RD_DATA, right);
            writeline(output_buf, write_col_to_output_buf);

            wait for 100ps;
            
            -- log new inputs
            write(write_col_to_output_buf, clocktick_count,right,5);
            write(write_col_to_output_buf, string'(", FW,                                                "));
            write(write_col_to_output_buf, string'(", WR_EN:"));
            write(write_col_to_output_buf, r_FW_WR_EN, right);
            write(write_col_to_output_buf, string'(", NXTFULL:"));
            write(write_col_to_output_buf, r_FW_NEXT_FULL, right);
            write(write_col_to_output_buf, string'(", WR_DATA:"));
            write(write_col_to_output_buf, r_FW_WR_DATA, right);
            writeline(output_buf, write_col_to_output_buf);

            write(write_col_to_output_buf, clocktick_count,right,5);
            write(write_col_to_output_buf, string'(", BW,                                                "));
            write(write_col_to_output_buf, string'(", WR_EN:"));
            write(write_col_to_output_buf, r_BW_WR_EN, right);
            write(write_col_to_output_buf, string'(", NXTFULL:"));
            write(write_col_to_output_buf, r_BW_NEXT_FULL, right);
            write(write_col_to_output_buf, string'(", WR_DATA:"));
            write(write_col_to_output_buf, r_BW_WR_DATA, right);
            writeline(output_buf, write_col_to_output_buf);

            if (r_CLOCK = '1') then
              clocktick_count <= clocktick_count + 1;
            end if;
        end loop;
    end process;
  
 
  p_TEST : process is
  begin
    wait until r_CLOCK = '1';
    r_FW_WR_EN <= '1'; r_FW_WR_DATA <= X"A6";      r_BW_WR_EN <= '1'; r_BW_WR_DATA <= X"26";
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';  
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    r_FW_WR_EN <= '0'; r_FW_WR_DATA <= X"A7";      r_BW_WR_EN <= '0'; r_BW_WR_DATA <= X"27";
    r_FW_NEXT_FULL <= '0';                         r_BW_NEXT_FULL <= '0';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    r_FW_NEXT_FULL <= '1';                         r_BW_NEXT_FULL <= '1';
    r_FW_WR_EN <= '1'; r_FW_WR_DATA <= X"A8";      r_BW_WR_EN <= '1'; r_BW_WR_DATA <= X"28";
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    r_FW_NEXT_FULL <= '0'; r_FW_WR_DATA <= X"A9";  r_BW_NEXT_FULL <= '0'; r_BW_WR_DATA <= X"29";
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    r_FW_WR_EN <= '0';  r_FW_WR_DATA <= X"AA";     r_BW_WR_EN <= '0';  r_BW_WR_DATA <= X"2A";
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    -- commenting the following two out because testing for underflow or overflow triggers out Failure response and we're prefer not to error out.
    --wait until r_CLOCK = '1';
    --wait until r_CLOCK = '1';
 
     -- wait;
    --or 
    -- assert false report "end of test bench" severity failure;
    --or
    finish;

  end process;
   
end behave;
