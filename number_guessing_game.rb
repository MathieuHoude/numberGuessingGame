require 'json'
require 'uri'
require 'net/http'
require 'openssl'
require 'httparty'

def play_game(difficulty)
	case difficulty
		when "veryeasy", "1"
			limit = 10
			max_nb_tries = 1000000
		when "easy", "2"
			limit = 10
			max_nb_tries = 5
		when "medium", "3"
			limit = 100
			max_nb_tries = 5
		when "hard", "4"
			limit = 500
			max_nb_tries = 8
		when "veryhard", "5"
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
	difficulties = %w(1 veryeasy 2 easy 3 medium 4 hard 5 veryhard)
	ascii_art("Number+Guessing+Game")
	puts "Welcome to this fabulous number guessing game."
	puts "Please enter your name:"
	name = gets.chomp
	if is_bad(name)
		puts "That's rude. You don't deserve to play this game. Goodbye."
	else
		ascii_art("Hi #{name}!")
		continue_playing = true

		while continue_playing
			puts "Please choose a difficulty level (1 = VeryEasy / 2 = Easy / 3 = Medium / 4 = Hard / 5 = VeryHard)"
			difficulty = gets.chomp.gsub(/\s+/, "").downcase
			if  !(difficulties.include?(difficulty))
				puts "Invalid input"
			else
				results = play_game(difficulty)
				results["answer_found"] ? (puts "Good job!") : (puts "You're out of tries! The number we were looking for was #{results["good_number"]}")
				puts "Wanna play again? (Yes/No)"
				answer = gets.chomp.downcase
				continue_playing = false if answer == "no"
			end			
		end
		response = HTTParty.get('http://artii.herokuapp.com/make?text=Thank+you+for+playing!')
		puts response.body
	end
end

def is_bad(text)
	url = URI("https://neutrinoapi-bad-word-filter.p.rapidapi.com/bad-word-filter")

	http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Post.new(url)
	request["x-rapidapi-host"] = 'neutrinoapi-bad-word-filter.p.rapidapi.com'
	request["x-rapidapi-key"] = '3122280cf7msh59381a1f1cb7152p1216fcjsn71b26972e51c'
	request["content-type"] = 'application/x-www-form-urlencoded'
	request.body = "censor-character=*&content=#{text}"

	response = http.request(request)
	is_bad =  JSON.parse(response.body)["is-bad"]
end

def ascii_art(text)
	response = HTTParty.get("http://artii.herokuapp.com/make?text=#{text}")
	puts response.body
end

main_game