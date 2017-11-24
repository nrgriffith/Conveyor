library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
---------------------------------
entity Conveyor is
    Port ( Extclk : in STD_LOGIC; -- [PB0] Active High
           Reset  : in STD_LOGIC; -- [PB1] Active Low
           SA     : in STD_LOGIC; -- [SW1] Optical Sensor Input; 0 = no subassembly; 1 = subassembly
           SB     : in STD_LOGIC; -- [SW0] Optical Sensor Input; 0 = no subassembly; 1 = subassembly
           CA     : out STD_LOGIC; -- [LED7] Convey Motor Control; 0 = off; 1 = on
           CB     : out STD_LOGIC; -- [LED6] Convey Motor Control; 0 = off; 1 = on
           S      : out STD_LOGIC_VECTOR (3 downto 0)); -- [LED3 - LED0]
end Conveyor;

architecture BEHAVIORAL of Conveyor is

    type stype is (A, B, C, D, E, F, G, H, I, J, K);
    signal pstate, nstate : stype;
    signal INP : STD_LOGIC_VECTOR(1 downto 0);

    begin
    -- For debugging purposes. LEDs 3 downto 0 will show which state we're currently in

        with pstate select S <= "0000" when A,
                                "0001" when B,
                                "0010" when C,
                                "0011" when D,
                                "0100" when E,
                                "0101" when F,
                                "0110" when G,
                                "0111" when H,
                                "1000" when I,
                                "1001" when J,
                                "1010" when K,
                                "1111" when others;

        -- Input number
        INP <= SA & SB;

        -- The following 3 processes are modified versions of the code example on Page 252 of the textbook

        -- Process 1
        state_register: process (Extclk, Reset)
        begin
            if (Reset = '0') then
                pstate <= A;
            elsif (Extclk'event and Extclk = '1') then
                pstate <= nstate;
            end if;
        end process;

        -- Process 2
        next_state_func: process(SA, SB, INP, pstate)
        begin
            case pstate is
                when A =>
                    if (INP = "00") then
                        nstate <= A;
                    elsif (INP = "01") then
                        nstate <= G;
                    elsif (INP = "10") then
                        nstate <= B;
                    else
                        nstate <= A;
                    end if;
                when B =>
                    if (INP = "00") then
                        nstate <= B;
                    elsif (INP = "01") then
                        nstate <= A;
                    elsif (INP = "10") then
                        nstate <= C;
                    else
                        nstate <= B;
                    end if;
                when C =>
                    if (INP = "00") then
                        nstate <= C;
                    elsif (INP = "01") then
                        nstate <= B;
                    elsif (INP = "10") then
                        nstate <= D;
                    else
                        nstate <= C;
                    end if;
                when D =>
                    if (SB = '1') then
                        nstate <= E;
                    else
                        nstate <= D;
                    end if;
                when E =>
                    if (SB = '1') then
                        nstate <= F;
                    else
                        nstate <= E;
                    end if;
                when F =>
                    if (SB = '1') then
                        nstate <= A;
                    else
                        nstate <= F;
                    end if;
                    --
                when G =>
                    if (INP = "00") then
                        nstate <= G;
                    elsif (INP = "01") then
                        nstate <= H;
                    elsif (INP = "10") then
                        nstate <= A;
                    else
                        nstate <= G;
                    end if;
                when H =>
                    if (INP = "00") then
                        nstate <= H;
                    elsif (INP = "01") then
                        nstate <= I;
                    elsif (INP = "10") then
                        nstate <= G;
                    else
                        nstate <= H;
                    end if;
                when I =>
                    if (SA = '1') then
                        nstate <= J;
                    else
                        nstate <= I;
                    end if;
                when J =>
                    if (SA = '1') then
                        nstate <= K;
                    else
                        nstate <= J;
                    end if;
                when K =>
                    if (SA = '1') then
                        nstate <= A;
                    else
                        nstate <= K;
                    end if;
                when others =>
                    nstate <= A;
            end case;
        end process;

        -- Process 3
        output_func: process(INP, pstate)
        begin
            case pstate is
                when A =>
                    CA <= '1';
                    CB <= '1';
                when B =>
                    CA <= '1';
                    CB <= '1';
                when C =>
                    CA <= '1';
                    CB <= '1';
                when D =>
                    CA <= '0';
                    CB <= '1';
                when E =>
                    CA <= '0';
                    CB <= '1';
                when F =>
                    CA <= '0';
                    CB <= '1';
                when G =>
                    CA <= '1';
                    CB <= '1';
                when H =>
                    CA <= '1';
                    CB <= '1';
                when I =>
                    CA <= '1';
                    CB <= '0';
                when J =>
                    CA <= '1';
                    CB <= '0';
                when K =>
                    CA <= '1';
                    CB <= '0';
                when others =>
                    CA <= '0';
                    CB <= '0';
            end case;
        end process;

end BEHAVIORAL;
