----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2021 05:41:08 PM
-- Design Name: 
-- Module Name: test_blink_one - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.finish;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_blink_one is
--  Port ( );
end test_blink_one;

architecture Behavioral of test_blink_one is

  component blink
  port (
    clk             : in  std_logic; 
    reset_n         : in  std_logic;
    blink_out       : out std_logic
  );  
  end component;

-- Inputs
signal clk : std_logic:= '0';
signal reset_n : std_logic:= '0';

-- Outputs
signal blink_out : std_logic;

-- Clock period definitions
constant clk_period : time := 10ns;
  
begin

-- Instantiate the Unit Under Test (UUT)
  uut: blink port map (
    clk => clk,
    reset_n => reset_n,
	blink_out => blink_out
    );

-- Clock process definitions
  clk_process: process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;
  
-- Stimulus process
  stim_proc: process
  begin
    -- hold reset state for 100 ns.
    wait for 100 ns;
	-- or
	--wait on ...;
	-- or
	--wait until ...;
    
    wait for clk_period*10;
    reset_n <= '0';
    wait for 10 ns;
    reset_n <= '1'; 

    assert blink_out = '0' report "Assertion Failure: assertion: blink_out==0" severity error;
    
    -- insert stimulus here
    --party1<='1';
    -- wait for 3 ns;
    --assert clk = '1' report "assert clk1" severity error;
    --assert clk = '0' report "assert clk0" severity error;
    --assert blink_out = '1' report "blink_out1" severity error;
    --assert blink_out = '0' report "blink_out0" severity error;

    wait for 50 ms;
    assert blink_out = '0' report "Assertion Failure: assertion: blink_out==0" severity error;
    wait for 50 ms;
    assert blink_out = '0' report "Assertion Failure: assertion: blink_out==0" severity error;
    wait for 50 ms;
    assert blink_out = '0' report "Assertion Failure: assertion: blink_out==0" severity error;
    wait for 50 ms;
    assert blink_out = '0' report "Assertion Failure: assertion: blink_out==0" severity error;
    wait for 50 ms;
    assert blink_out = '0' report "Assertion Failure: assertion: blink_out==0" severity error;
    wait for 50 ms;
    assert blink_out = '1' report "Assertion Failure: assertion: blink_out==1" severity error;
    wait for 50 ms;
    assert blink_out = '1' report "Assertion Failure: assertion: blink_out==1" severity error;
    wait for 50 ms;
    assert blink_out = '1' report "Assertion Failure: assertion: blink_out==1" severity error;
    wait for 50 ms;
    assert blink_out = '1' report "Assertion Failure: assertion: blink_out==1" severity error;
    wait for 50 ms;
    assert blink_out = '1' report "Assertion Failure: assertion: blink_out==1" severity error;
    wait for 50 ms;
    assert blink_out = '0' report "Assertion Failure: assertion: blink_out==0" severity error;
    wait for 50 ms;
    assert blink_out = '0' report "Assertion Failure: assertion: blink_out==0" severity error;
	
	-- wait;
	--or 
    -- assert false report "end of test bench" severity failure;
	--or
	finish;
	
  end process;    
    
end Behavioral;
