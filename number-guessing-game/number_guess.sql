#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RANDOM_NUMBER=$($PSQL "SELECT FLOOR(1 + random() * 1000)::INTEGER;")
echo $RANDOM_NUMBER
echo "Enter your username:"
read USERNAME
#USERNAME=$(echo "$USERNAME" | sed 's/^ *//; s/ *$//; s/ /_/g')
USERNAME_FROM_DATABASE=$($PSQL "SELECT username FROM user_information WHERE username='$USERNAME'")
if [[ -z $USERNAME_FROM_DATABASE ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  GAMES_PLAYED=0
  BEST_GAME=0
  INSERT_DETAILS=$($PSQL "INSERT INTO user_information(username, games_played, best_game) values('$USERNAME', 0, 0)")
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM user_information WHERE username = '$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM user_information WHERE username = '$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
echo "Guess the secret number between 1 and 1000:"
read USER_CHOICE
NUMBER_OF_GUESSES=1

while [[ $USER_CHOICE -ne $RANDOM_NUMBER ]]
do
  while ! [[ $USER_CHOICE =~ ^-?[0-9]+$ ]]; do
    echo "That is not an integer, guess again:"
    read USER_CHOICE
  done
  if [[ $USER_CHOICE -lt $RANDOM_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
    read USER_CHOICE
  else
    echo "It's lower than that, guess again:"
    read USER_CHOICE
  fi
  ((NUMBER_OF_GUESSES++))
done
echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"
if [[ $BEST_GAME -eq 0 || $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
then
  INSERT_BEST_GAME=$($PSQL "UPDATE user_information SET best_game = $NUMBER_OF_GUESSES WHERE username = '$USERNAME'")
fi

UPDATE_GAMES_PLAYED=$($PSQL "UPDATE user_information SET games_played = $GAMES_PLAYED + 1 WHERE username = '$USERNAME'")

