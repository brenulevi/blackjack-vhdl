library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blackjack is
port (
	key: in std_logic_vector(3 downto 0);
	sw: in std_logic_vector(9 downto 0);
	hex0: out std_logic_vector(6 downto 0);
	hex1: out std_logic_vector(6 downto 0);
	hex2: out std_logic_vector(6 downto 0);
	hex3: out std_logic_vector(6 downto 0);
	ledr: out std_logic_vector(9 downto 0);
	ledg: out std_logic_vector(7 downto 0)
);
end entity;

architecture behav of blackjack is
	type state_type is (start, playerCard1, playerCard2, dealerCard1, dealerCard2, playerAction, dealerAction, compare, loss, win, tie);
	signal current_state: state_type := start;
	signal playerSum: integer := 0;
	signal dealerSum: integer := 0;
	signal playerUsedJoker: std_logic := '0';
	signal playerDoubleAce: std_logic := '0';
	signal dealerUsedJoker: std_logic := '0';
	signal dealerDoubleAce: std_logic := '0';
	signal lastCard: integer := 0;
begin
	process(key(0))
		variable card: std_logic_vector(3 downto 0);
		variable int_card: integer;
	begin
		if(key(0)'event and key(0) = '0') then
			if(sw(9) = '1') then
				if(current_state = start) then
					current_state <= playerCard1;
				else
					playerSum <= 0;
					dealerSum <= 0;
					playerUsedJoker <= '0';
					playerDoubleAce <= '0';
					dealerUsedJoker <= '0';
					dealerDoubleAce <= '0';
					current_state <= start;
				end if;
			else
				case current_state is
					when start => -- i'll do nothing because im baddass
					when playerCard1 =>
						int_card := 0;
						
						if(sw(8) = '1') then
							-- this shit im not gonna do, but here is for random card
						else
							card := sw(3 downto 0);
						end if;
						
						int_card := to_integer(unsigned(card));
						
						if(int_card >= 10 and int_card <= 13) then
							int_card := 10;
						end if;
						
						if(int_card = 1) then
							if(playerSum + 11 <= 21) then
								int_card := 11;
								playerUsedJoker <= '1';
							else
								int_card := 1;
							end if;
						end if;
						
						if(int_card > 13 or int_card = 0) then
							current_state <= playerCard1;
						else
							playerSum <= playerSum + int_card;
							lastCard <= int_card;
							current_state <= playerCard2;
						end if;
					when playerCard2 =>
						int_card := 0;
					
						if(sw(8) = '1') then
							-- this shit im not gonna do, but here is for random card
						else
							card := sw(3 downto 0);
						end if;
						
						int_card := to_integer(unsigned(card));
						
						if(int_card >= 10 and int_card <= 13) then
							int_card := 10;
						end if;
						
						if(int_card = 1) then
							if(lastCard = 1 or lastCard = 11) then
								playerDoubleAce <= '1';
							end if;
							if(playerSum + 11 <= 21 and playerUsedJoker = '0') then
								int_card := 11;
								playerUsedJoker <= '1';
							else
								int_card := 1;
							end if;
						end if;
						
						if(int_card > 13 or int_card = 0) then
							current_state <= playerCard2;
						else
							playerSum <= playerSum + int_card;
							current_state <= dealerCard1;
						end if;
					when dealerCard1 =>
						int_card := 0;
						
						if(sw(8) = '1') then
							-- this shit im not gonna do, but here is for random card
						else
							card := sw(3 downto 0);
						end if;
						
						int_card := to_integer(unsigned(card));
						
						if(int_card >= 10 and int_card <= 13) then
							int_card := 10;
						end if;
						
						if(int_card = 1) then
							if(dealerSum + 11 <= 21) then
								int_card := 11;
								dealerUsedJoker <= '1';
							else
								int_card := 1;
							end if;
						end if;
						
						if(int_card > 13 or int_card = 0) then
							current_state <= dealerCard1;
						else
							dealerSum <= dealerSum + int_card;
							lastCard <= int_card;
							current_state <= dealerCard2;
						end if;
					when dealerCard2 =>
						int_card := 0;
					
						if(sw(8) = '1') then
							-- this shit im not gonna do, but here is for random card
						else
							card := sw(3 downto 0);
						end if;
						
						int_card := to_integer(unsigned(card));
						
						if(int_card >= 10 and int_card <= 13) then
							int_card := 10;
						end if;
						
						if(int_card = 1) then
							if(lastCard = 1 or lastCard = 11) then
								dealerDoubleAce <= '1';
							end if;
							if(dealerSum + 11 <= 21 and dealerUsedJoker = '0') then
								int_card := 11;
								dealerUsedJoker <= '1';
							else
								int_card := 1;
							end if;
						end if;
						
						if(int_card > 13 or int_card = 0) then
							current_state <= dealerCard2;
						else
							dealerSum <= dealerSum + int_card;
							current_state <= playerAction;
						end if;
					when playerAction =>
							if(key(3) = '0') then -- hit
								int_card := 0;
							
								if(sw(8) = '1') then
									-- this shit im not gonna do, but here is for random card
								else
									card := sw(3 downto 0);
								end if;
								
								int_card := to_integer(unsigned(card));
								
								if(int_card >= 10 and int_card <= 13) then
									int_card := 10;
								end if;
								
								if(int_card <= 13 and int_card > 0) then
									if(int_card = 1) then
										if(playerSum + 11 <= 21 and playerUsedJoker = '0') then
											int_card := 11;
											playerUsedJoker <= '1';
										else
											int_card := 1;
										end if;
									else
										if(playerSum + int_card > 21 and playerUsedJoker = '1' and playerDoubleAce = '0') then
											int_card := int_card - 10;
										end if;
									end if;
									
									playerSum <= playerSum + int_card;
									
									if(playerSum + int_card > 21) then
										current_state <= loss;
									end if;
								end if;
							elsif(key(2) = '0') then --stay
								current_state <= dealerAction;
							end if;
					when dealerAction =>
						if(dealerSum >= 17) then -- stay
							current_state <= compare;
						else	-- hit
							int_card := 0;
							
							if(sw(8) = '1') then
								-- this shit im not gonna do, but here is for random card
							else
								card := sw(3 downto 0);
							end if;
							
							int_card := to_integer(unsigned(card));
							
							if(int_card >= 10 and int_card <= 13) then
								int_card := 10;
							end if;
							
							if(int_card <= 13 and int_card > 0) then
								if(int_card = 1) then
									if(dealerSum + 11 <= 21 and dealerUsedJoker = '0') then
										int_card := 11;
										dealerUsedJoker <= '1';
									else
										int_card := 1;
									end if;
								else
									if(playerSum + int_card > 21 and dealerUsedJoker = '1' and dealerUsedJoker = '0') then
										int_card := int_card - 10;
									end if;
								end if;
								
								dealerSum <= dealerSum + int_card;
								
								if(dealerSum + int_card > 21) then
									current_state <= loss;
								end if;
							end if;
						end if;
					when compare =>
						if(playerSum > dealerSum) then
							current_state <= win;
						elsif (playerSum < dealerSum) then
							current_state <= loss;
						else
							current_state <= tie;
						end if;
					when loss =>
						current_state <= start;
						playerSum <= 0;
						playerUsedJoker <= '0';
						playerDoubleAce <= '0';
						dealerSum <= 0;
						dealerUsedJoker <= '0';
						dealerDoubleAce <= '0';
					when win =>
						current_state <= start;
						playerSum <= 0;
						playerUsedJoker <= '0';
						playerDoubleAce <= '0';
						dealerSum <= 0;
						dealerUsedJoker <= '0';
						dealerDoubleAce <= '0';
					when tie =>
						current_state <= start;
						playerSum <= 0;
						playerUsedJoker <= '0';
						playerDoubleAce <= '0';
						dealerSum <= 0;
						dealerUsedJoker <= '0';
						dealerDoubleAce <= '0';
				end case;
			end if;
		end if;
	end process;
	
	process(current_state)
	begin
		case current_state is
			when start =>
				ledr <= "0000000001";
				ledg <= "00000000";
				hex1 <= "1111111";
			when playerCard1 =>
				ledr <= "0000000010";
				ledg(0) <= playerUsedJoker;
				ledg(1) <= playerDoubleAce;
				ledg(6) <= dealerUsedJoker;
				ledg(7) <= dealerDoubleAce;
				hex1 <= "0111111";
			when playerCard2 =>
				ledr <= "0000000100";
				ledg(0) <= playerUsedJoker;
				ledg(1) <= playerDoubleAce;
				ledg(6) <= dealerUsedJoker;
				ledg(7) <= dealerDoubleAce;
				hex1 <= "0111111";
			when dealerCard1 =>
				ledr <= "0000001000";
				ledg(0) <= playerUsedJoker;
				ledg(1) <= playerDoubleAce;
				ledg(6) <= dealerUsedJoker;
				ledg(7) <= dealerDoubleAce;
				hex1 <= "0111111";
			when dealerCard2 =>
				ledr <= "0000010000";
				ledg(0) <= playerUsedJoker;
				ledg(1) <= playerDoubleAce;
				ledg(6) <= dealerUsedJoker;
				ledg(7) <= dealerDoubleAce;
				hex1 <= "0111111";
			when playerAction =>
				ledr <= "0000100000";
				ledg(0) <= playerUsedJoker;
				ledg(1) <= playerDoubleAce;
				ledg(6) <= dealerUsedJoker;
				ledg(7) <= dealerDoubleAce;
				hex1 <= "0111111";
			when dealerAction =>
				ledr <= "0001000000";
				ledg(0) <= playerUsedJoker;
				ledg(1) <= playerDoubleAce;
				ledg(6) <= dealerUsedJoker;
				ledg(7) <= dealerDoubleAce;
				hex1 <= "0111111";
			when compare =>
				ledr <= "0010000000";
				ledg <= "00000000";
				hex1 <= "1111111";
			when loss =>
				ledr <= "1111111111";
				ledg <= "00000000";
				hex1 <= "1111111";
			when win =>
				ledr <= "0000000000";
				ledg <= "11111111";
				hex1 <= "1111111";
			when tie =>
				ledr <= "1111111111";
				ledg <= "11111111";
				hex1 <= "1111111";
		end case;
	end process;
	
	process(sw(3 downto 0))
		variable int_card: integer;
	begin
		if(current_state = start) then
			hex0 <= "1111111";
		else
		int_card := to_integer(unsigned(sw(3 downto 0)));
			case int_card is
				when 0 =>
					hex0 <= "1000000";
				when 1 =>
					hex0 <= "1111001";
				when 2 =>
					hex0 <= "0100100";
				when 3 =>
					hex0 <= "0110000";
				when 4 =>
					hex0 <= "0011001";
				when 5 =>
					hex0 <= "0010010";
				when 6 =>
					hex0 <= "0000010";
				when 7 =>
					hex0 <= "1111000";
				when 8 =>
					hex0 <= "0000000";
				when 9 =>
					hex0 <= "0011000";
				when 10 =>
					hex0 <= "0001000";
				when 11 =>
					hex0 <= "0000011";
				when 12 =>
					hex0 <= "0100111";
				when 13 =>
					hex0 <= "0100001";
				when 14 =>
					hex0 <= "0000110";
				when 15 =>
					hex0 <= "0001110";
				when others =>
					hex0 <= "1111111";
			end case;
		end if;
	end process;
	
	process (playerSum)
	begin
		if(current_state = start) then		
			hex2 <= "1111111";
			hex3 <= "1111111";
		else
			case playerSum is
				when 0 =>
					hex2 <= "1000000";
					hex3 <= "1000000";
				when 1 => 
					hex2 <= "1111001";
					hex3 <= "1000000";
				when 2 => 
					hex2 <= "0100100";
					hex3 <= "1000000";
				when 3 => 
					hex2 <= "0110000";
					hex3 <= "1000000";
				when 4 => 
					hex2 <= "0011001";
					hex3 <= "1000000";
				when 5 => 
					hex2 <= "0010010";
					hex3 <= "1000000";
				when 6 => 
					hex2 <= "0000010";
					hex3 <= "1000000";
				when 7 => 
					hex2 <= "1111000";
					hex3 <= "1000000";
				when 8 => 
					hex2 <= "0000000";
					hex3 <= "1000000";
				when 9 => 
					hex2 <= "0011000";
					hex3 <= "1000000";
				when 10 => 
					hex2 <= "1000000";
					hex3 <= "1111001";
				when 11 => 
					hex2 <= "1111001";
					hex3 <= "1111001";
				when 12 => 
					hex2 <= "0100100";
					hex3 <= "1111001";
				when 13 => 
					hex2 <= "0110000";
					hex3 <= "1111001";
				when 14 =>
					hex2 <= "0011001";
					hex3 <= "1111001";
				when 15 => 
					hex2 <= "0010010";
					hex3 <= "1111001";
				when 16 => 
					hex2 <= "0000010";
					hex3 <= "1111001";
				when 17 =>
					hex2 <= "1111000";
					hex3 <= "1111001";
				when 18 =>
					hex2 <= "0000000";
					hex3 <= "1111001";
				when 19 =>
					hex2 <= "0011000";
					hex3 <= "1111001";
				when 20 => 
					hex2 <= "1000000";
					hex3 <= "0100100";
				when 21 => 
					hex2 <= "1111001";
					hex3 <= "0100100";
				when 22 => 
					hex2 <= "0100100";
					hex3 <= "0100100";
				when 23 => 
					hex2 <= "0110000";						
					hex3 <= "0100100";
				when 24 => 
					hex2 <= "0011001";
					hex3 <= "0100100";
				when 25 => 
					hex2 <= "0010010";
					hex3 <= "0100100";
				when 26 => 
					hex2 <= "0000010";
					hex3 <= "0100100";
				when 27 => 
					hex2 <= "1111000";
					hex3 <= "0100100";
				when 28 =>
					hex2 <= "0000000";
					hex3 <= "0100100";
				when 29 => 
					hex2 <= "0011000";
					hex3 <= "0100100";
				when 30 => 
					hex2 <= "1000000";
					hex3 <= "0110000";
				when others =>
					hex2 <= "0111111";
					hex3 <= "0111111";
			end case;
		end if;
	end process;
end architecture;