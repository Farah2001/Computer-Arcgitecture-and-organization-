LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ALUTest IS
END ALUTest;
 
ARCHITECTURE behavior OF ALUTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Alu32    PORT(
			 A : in  STD_LOGIC_VECTOR(31 downto 0);
           B : in  STD_LOGIC_VECTOR(31 downto 0);
           Cin : in  std_logic;
			  aluop: in std_logic_vector (3 downto 0);
           res : out  STD_LOGIC_VECTOR (31 downto 0);
           cflag : out  STD_LOGIC;
           oflag : out  STD_LOGIC;
           zflag : out  STD_LOGIC
			);
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal aluop : std_logic_vector(3 downto 0) := (others => '0');
   signal Cin : std_logic := '0';

 	--Outputs
   signal res : std_logic_vector(31 downto 0);
   signal cflag : std_logic;
   signal zflag : std_logic;
   signal oflag : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Alu32 PORT MAP (
          A => A,
          B => B,
          aluop => aluop,
          Cin => Cin,
          res => res,
          cflag => cflag,
          zflag => zflag,
          oflag => oflag
        );

  
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
     		--wait for 10 ns;
		--AND testcase
			A <= "11000000000000000000000000000000" ;
			B <= "10100000000000000000000000000000" ;
			aluop <= "0000" ;
			wait for 10ns;
			report "Test1";
			assert(res = "10000000000000000000000000000000" and zflag = '0') report "1:Fail" severity error;

			wait for 1ns;
		
		--OR testcase
			A <= "11000000000000000000000000000000" ;
			B <= "10100000000000000000000000000000" ;
			aluop <= "0001" ;
			wait for 10ns;
			report "Test2";
			assert(res = "11100000000000000000000000000000" and zflag = '0') report "2:Fail" severity error;

			wait for 1ns;
		
		--ADD testcase1 (overflow = 1, cout = 0)
			A <= "01110000000000000000000000000000" ;
			B <= "01100000000000000000000000000000" ;
			aluop <= "0010" ;
			wait for 10ns;
			report "Test3";
			assert(res = "11010000000000000000000000000000" and oflag = '1' and cflag = '0' and zflag = '0') report "3:Fail" severity error;

			wait for 1ns;
		
		--ADD testcase2 (zero = 1, cout = 1)
			A <= "11110000000000000000000000000000" ;
			B <= "00010000000000000000000000000000" ;
			aluop <= "0010" ;
			wait for 10ns;
			report "Test4";
			assert(res = "00000000000000000000000000000000" and oflag = '0' and cflag = '1' and zflag = '1') report "4:Fail" severity error;

			wait for 1ns;

		--SUB testcase1 (cout = 1)
			A <= "00000000000000000000000000000111" ; --a = 7
			B <= "00000000000000000000000000000110" ; --b = 6
			Cin <= '1' ;
			aluop <= "0110" ;
			wait for 10ns;
			report "Test5";
			assert(res = "00000000000000000000000000000001" and oflag = '0' and cflag = '1' and zflag = '0') report "5:Fail" severity error;

			wait for 1ns;

		--SUB testcase2 (cout = 0)
			A <= "00000000000000000000000000000110" ; --a = 6
			B <= "00000000000000000000000000000111" ; --b = 7
			Cin <= '1' ;
			aluop <= "0110" ;
			wait for 10ns;
			report "Test6";
			assert(res = "11111111111111111111111111111111" and oflag = '0' and cflag = '0' and zflag = '0') report "6:Fail" severity error;

			wait for 1ns;
			
		report "Test Complete";
      wait;
   end process;

END;
