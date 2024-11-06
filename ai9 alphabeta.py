import random

def alpha_beta_guess(low, high, depth, alpha, beta, number, maximizing):
    if low > high or depth == 0:
        return random.randint(low, high)  # Random guess within the current range

    if maximizing:
        best_guess = low
        for guess in range(low, high + 1):
            if guess == number:
                return guess
            elif guess < number:
                result = alpha_beta_guess(guess + 1, high, depth - 1, alpha, beta, number, False)
            else:
                result = alpha_beta_guess(low, guess - 1, depth - 1, alpha, beta, number, False)

            best_guess = max(best_guess, result)
            alpha = max(alpha, best_guess)
            if beta <= alpha:
                break  # Beta cutoff
        return best_guess

    else:
        best_guess = high
        for guess in range(low, high + 1):
            if guess == number:
                return guess
            elif guess < number:
                result = alpha_beta_guess(guess + 1, high, depth - 1, alpha, beta, number, True)
            else:
                result = alpha_beta_guess(low, guess - 1, depth - 1, alpha, beta, number, True)

            best_guess = min(best_guess, result)
            beta = min(beta, best_guess)
            if beta <= alpha:
                break  # Alpha cutoff
        return best_guess

# Modified guess_the_number function using alpha-beta pruning for AI
def guess_the_number():
    number = random.randint(1, 100)  # The number AI and player are trying to guess
    user_attempts = 0
    ai_attempts = 0
    max_attempts = 10

    ai_low = 1  # Lower bound for AI guesses
    ai_high = 100  # Upper bound for AI guesses
    depth = 5  # Depth for the AI's alpha-beta search

    print("Welcome to Guess the Number!")
    print(f"You and the AI will take turns guessing the number between 1 and 100.")
    print(f"Each player has {max_attempts} attempts to guess the correct number.")

    while user_attempts < max_attempts and ai_attempts < max_attempts:
        # User's turn
        print("\nYour turn:")
        try:
            user_guess = int(input("Enter your guess (1-100): "))
            if user_guess < 1 or user_guess > 100:
                print("Invalid input! Please enter a number between 1 and 100.")
                continue  # Skip to the next iteration without counting this as an attempt
        except ValueError:
            print("Invalid input! Please enter a valid integer between 1 and 100.")
            continue

        user_attempts += 1

        if user_guess < number:
            print("Too low!")
        elif user_guess > number:
            print("Too high!")
        else:
            print(f"\nCongratulations! You guessed the number in {user_attempts} attempts. You win!")
            return

        # AI's turn using alpha-beta pruning strategy
        print("\nAI's turn:")
        ai_guess = alpha_beta_guess(ai_low, ai_high, depth, -float('inf'), float('inf'), number, True)
        ai_attempts += 1
        print(f"AI guessed: {ai_guess}")

        if ai_guess < number:
            print("AI's guess is too low!")
            ai_low = ai_guess + 1  # AI narrows its range from below
        elif ai_guess > number:
            print("AI's guess is too high!")
            ai_high = ai_guess - 1  # AI narrows its range from above
        else:
            print(f"\nAI guessed the number in {ai_attempts} attempts. AI wins!")
            return

    print("\nNeither you nor the AI guessed the number within 10 attempts. Game over!")

# Menu function for the game
def menu():
    while True:
        choice = input("\n1. Play Guess the Number\n2. Exit\nEnter your choice: ")
        if choice == '1':
            guess_the_number()
        elif choice == '2':
            break


if __name__ == "__main__":
    menu()
