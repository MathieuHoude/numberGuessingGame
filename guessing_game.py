import random
import math

def start_guessing(number_to_find, limit, max_nb_tries):
    guess = nb_tries = 0
    answer_was_found = False
    print("You can start guessing! The number is between 1 and {}. You have {} tries.".format(limit,max_nb_tries))
    while not answer_was_found:
        if guess != number_to_find:
            guess = int(input('Guess: '))
            if (math.isnan(guess)):
                print("Invalid input!")
            else:
                nb_tries += 1
                if nb_tries != max_nb_tries:
                    if guess < number_to_find: print("Higher!")
                    if guess > number_to_find: print("Lower!")
                else:
                    break
        else:
            answer_was_found = True
    if guess == number_to_find: answer_was_found = True
    return answer_was_found

def new_game(limit, max_nb_tries):
    number_to_find = random.randrange(1, limit)
    answer_was_found = start_guessing(number_to_find, limit, max_nb_tries)
    return answer_was_found, number_to_find

def play_game(difficulty_level):
    limit = max_nb_tries = None
    match difficulty_level:
        case 1:
            limit = 10
            max_nb_tries = 100000000
        case 2:
            limit = 10
            max_nb_tries = 5
        case 3:
            limit = 100
            max_nb_tries = 6
        case 4:
            limit = 500
            max_nb_tries = 8
        case 5:
            limit = 1000
            max_nb_tries = 9
    answer_was_found, number_to_find = new_game(limit, max_nb_tries)
    return answer_was_found, number_to_find

def main():
    difficulties = [1, 2, 3, 4, 5]
    continue_playing = True
    print("Welcome to this fabulous number guessing game.")
    while (continue_playing):
        difficulty = input('Please choose a difficulty level (1 = VeryEasy / 2 = Easy / 3 = Medium / 4 = Hard / 5 = VeryHard): ')
        try: 
            difficulty = int(difficulty)
            print(difficulty)
            if difficulty not in difficulties:
                print("Invalid input!")
            else:
                answer_was_found, number_to_find = play_game(difficulty)
                if answer_was_found:
                    print("Good job!")
                else:
                    print("You're out of tries! The number we were looking for was {}".format(number_to_find))
                answer = input('Wanna play again? (Yes/No)').lower()
                if answer == 'no': continue_playing = False
        except:
            print("Invalid input!")
        
    print("Thank you for playing!")

main()