#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=namnum -t --no-align -c"

# echo $RANNUM
echo "Enter your username:"
read NAME

NAME_SEL=$($PSQL "SELECT name, games_played, best_game FROM users WHERE name='$NAME'")
if [[ -z $NAME_SEL ]]
then 
  # echo "no user"
  USERNAME=$($PSQL "INSERT INTO users(name) VALUES ('$NAME')")
  echo "Welcome, $NAME! It looks like this is your first time here."
else
  # echo "user exist"
  echo "$NAME_SEL" | while IFS="$|" read USERNAME GAMES_PLAYED BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

cntr=0
COND=1
RANNUM=$(($RANDOM % 1000 +1))
echo $RANNUM
echo "Guess the secret number between 1 and 1000:"
while [ $COND -eq 1 ]
do
  read GUESS
  if ! [[ "$GUESS" =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  else
    cntr=$(( cntr + 1 ))
    x=$(( $GUESS - $RANNUM ))
    if [ $x -eq 0 ]; then
      echo "You guessed it in $cntr tries. The secret number was $RANNUM. Nice job!"
      COND=0
    elif [ $x -lt 0 ]; then # secret number is higher than guess 
      echo "It's higher than that, guess again:"
    elif [ $x -gt 0 ]; then
      echo "It's lower than that, guess again:"
    fi
  fi
done

# update the fable
NAME_SEL=$($PSQL "SELECT name, games_played, best_game FROM users WHERE name='$NAME'")
echo "$NAME_SEL" | while IFS="$|" read USERNAME GAMES_PLAYED BEST_GAME
do
  # UPDATE_NAME_RESULT=$($PSQL "UPDATE users SET name=?? WHERE name='$NAME'")
  UPDATE_PLAYED_RESULT=$($PSQL "UPDATE users SET games_played=$(( GAMES_PLAYED + 1)) WHERE name='$NAME'")
  if [ $cntr -lt $BEST_GAME ]; then
    # echo "yep"
    UPDATE_BEST_RESULT=$($PSQL "UPDATE users SET best_game=$cntr WHERE name='$NAME'")
  fi
  
done

  # RETURN_BIKE_RESULT=$($PSQL "UPDATE rentals SET date_returned=NOW() WHERE rental_id='$RENTAL_ID'")


# CREATE DATABASE NAMNUM;
# CREATE TABLE USERS(user_id SERIAL, name VARCHAR(50) UNIQUE NOT NULL, games_played INT DEFAULT 0, best_game INT DEFAULT 1000);




