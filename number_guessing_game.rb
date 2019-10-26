require 'httparty'

def play_game(difficulty)
	limit = 0
	case difficulty
		when "VeryEasy"
			limit = 10
			max_nb_tries = 1000000
		when "Easy"
			limit = 10
			max_nb_tries = 5
		when "Medium"
			limit = 100
			max_nb_tries = 5
		when "Hard"
			limit = 500
			max_nb_tries = 8
		when "VeryHard"
			limit = 1000
			max_nb_tries = 9
	end
	results = new_game(limit,max_nb_tries)
end

def new_game(limit, max_nb_tries)
	good_number = rand(1..limit)
	puts "I've now chosen a new number between 1 and #{limit}."
	return {
		"answer_found" => start_guessing(good_number, max_nb_tries),
		"good_number" => good_number
	}	
end

def start_guessing(good_number, max_nb_tries)
	guess = 0
	nb_tries = 0
	answer_found = false
	puts "You can start guessing."
	while nb_tries < max_nb_tries
		if guess.to_i != good_number
			guess = gets.chomp
			if  guess.empty? || !(guess.scan(/\D/).empty?)
				puts "Invalid input"
			else
				nb_tries += 1
				unless nb_tries == max_nb_tries
					puts "Higher!" if guess.to_i < good_number 
					puts "Lower!" if guess.to_i > good_number
				end
			end	
		else
			break
		end		
	end
	answer_found = true unless guess.to_i != good_number
end

def main_game
	difficulties = %w(VeryEasy Easy Medium Hard VeryHard)
	puts "Hello, please enter your name."
	name = gets.chomp
	response = HTTParty.get("http://artii.herokuapp.com/make?text=Hi+#{name}!")
	puts response.body
	puts "Welcome to this fabulous number guessing game."
	continue_playing = true

	while continue_playing
		puts "Please choose a difficulty level (VeryEasy / Easy / Medium / Hard / VeryHard)"
		difficulty = gets.chomp
		if  !(difficulties.include?(difficulty))
			puts "Invalid input"
		else
			results = play_game(difficulty)
			results["answer_found"] ? (puts "Good job!") : (puts "You're out of tries! The number we were looking for was #{results["good_number"]}")
			puts "Wanna play again? (Yes/No)"
			answer = gets.chomp
			continue_playing = false if answer == "No"
		end			
	end
	puts "Thank you for playing!"
end

response = HTTParty.get('http://artii.herokuapp.com/make?text=Number+Guessing+Game')
puts response.body
main_game