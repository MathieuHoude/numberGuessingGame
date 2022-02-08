const prompt = require("prompt-sync")({ sigint: true });

const start_guessing = (number_to_find, limit, max_nb_tries) => {
    let guess, nb_tries = 0;
    let answer_was_found = false;
    console.log(`You can start guessing! The number is between 1 and ${limit}. You have ${max_nb_tries} tries.`)
    while (!answer_was_found) {
        if (guess != number_to_find) {
            guess = parseInt(prompt('Guess: '));
            if (isNaN(guess)) {
                console.log("Invalid input!");
            } else {
                nb_tries += 1;
                if (nb_tries != max_nb_tries) {
                    if (guess < number_to_find) console.log("Higher!");
                    if (guess > number_to_find) console.log("Lower!");
                } else {
                    break
                }
            }
        } else {
            answer_was_found = true;
        }
    }
    if (guess == number_to_find) answer_was_found = true;
    return answer_was_found;
}

const new_game = (limit, max_nb_tries) => {
    let number_to_find = Math.ceil(Math.random() * limit);
    let answer_was_found = start_guessing(number_to_find, limit, max_nb_tries);
    return [answer_was_found, number_to_find];
}

const play_game = (difficulty_level) => {
    let limit, max_nb_tries;
    switch (difficulty_level) {
        case 1:
            limit = 10;
            max_nb_tries = 100000000;
            break;
        case 2:
            limit = 10;
            max_nb_tries = 5;
            break;
        case 3:
            limit = 100;
            max_nb_tries = 5;
            break;
        case 4:
            limit = 500;
            max_nb_tries = 8;
            break;
        case 5:
            limit = 1000;
            max_nb_tries = 9;
            break;
    }
    [answer_was_found, number_to_find] = new_game(limit, max_nb_tries);
    return [answer_was_found, number_to_find];

}

const main = () => {
    const difficulties = [1, 2, 3, 4, 5];
    let continue_playing = true;
    console.log("Welcome to this fabulous number guessing game.");
    while (continue_playing) {
        const difficulty = parseInt(prompt('Please choose a difficulty level (1 = VeryEasy / 2 = Easy / 3 = Medium / 4 = Hard / 5 = VeryHard): '));
        if (!difficulties.includes(difficulty)) {
            console.log("Invalid input!")
        } else {
            [answer_was_found, number_to_find] = play_game(difficulty);
            if (answer_was_found) {
                console.log("Good job!");
            } else {
                console.log(`You're out of tries! The number we were looking for was ${number_to_find}`);
            }
            let answer = prompt('Wanna play again? (Yes/No)').toLocaleLowerCase();
            if (answer === 'no') continue_playing = false;
        }
    }
    console.log("Thank you for playing!")
}

main()