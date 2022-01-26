use rand::Rng;

fn start_guessing(number_to_find: i32, max_nb_tries: i32, limit: f32) -> bool {
    let mut guess: i32 = 0;
    let mut nb_tries: i32 = 0;
    let mut answer_was_found: bool = false;
    println!("You can start guessing! The number is between 1 and {}:", limit);
    while !answer_was_found {
        if guess != number_to_find {
            let mut input = String::new();
            std::io::stdin().read_line(&mut input).unwrap();
            if input.trim().parse::<i32>().is_ok() {
                guess = input.trim().parse().unwrap();
                nb_tries += 1;
                if nb_tries != max_nb_tries {
                    if guess < number_to_find {
                        println!("Higher!");
                    }
                    if guess > number_to_find {
                        println!("Lower!");
                    }
                } else {
                    break;
                }
            } else {
                println!("Invalid input")
            }
        } else {
            answer_was_found = true;
        }
    }
    answer_was_found
}

fn new_game(limit: f32, max_nb_tries: i32) -> (bool, i32) {
    let mut rng = rand::thread_rng();
    let mut random_number: f32 = rng.gen();
    random_number = random_number * limit;
    let number_to_find: i32 = random_number.ceil() as i32;
    let answer_was_found = start_guessing(number_to_find, max_nb_tries, limit);
    (answer_was_found, number_to_find)
}

fn play_game(difficulty: i8) -> (bool, i32) {
    let mut limit: f32 = 0.0;
    let mut max_nb_tries: i32 = 0;
    match difficulty {
        1 => {
            limit = 10.0;
            max_nb_tries = 1000000;
        },
        2 => {
            limit = 10.0;
            max_nb_tries = 5;
        },
        3 => {
            limit = 100.0;
            max_nb_tries = 5;
        },
        4 => {
            limit = 500.0;
            max_nb_tries = 8;
        },
        5 => {
            limit = 1000.0;
            max_nb_tries = 9;
        },
        _ => println!("Invalid difficulty!")
    }
    let (answer_was_found, number_to_find) = new_game(limit, max_nb_tries);
    (answer_was_found, number_to_find)
}


fn main() {
    let difficulties: [i8; 5] = [1, 2, 3, 4, 5];
    let mut continue_playing: bool = true;
    println!("Welcome to this fabulous number guessing game.");
    while continue_playing {
        let mut input = String::new();
        println!("Please choose a difficulty level (1 = VeryEasy / 2 = Easy / 3 = Medium / 4 = Hard / 5 = VeryHard");
        std::io::stdin().read_line(&mut input).unwrap();
        if input.trim().parse::<i8>().is_ok() {
            let difficulty: i8 = input.trim().parse().unwrap();
            if !difficulties.contains(&difficulty) {
                println!("Invalid input")
            } else {
                let (answer_was_found, number_to_find) = play_game(difficulty);
                if answer_was_found {
                    println!("Good job!")
                } else {
                    println!("You are out of tries! The number we were looking for was {}", number_to_find);
                }
                let mut input = String::new();
                println!("Wanna play again? (Yes/No)");
                std::io::stdin().read_line(&mut input).unwrap();
                let play_again: String = input.trim().to_lowercase();
                if play_again == "no" {
                    continue_playing = false;
                }
            }
        } else {
            println!("Invalid input")
        }
        
    }
    println!("Thank you for playing")
}
