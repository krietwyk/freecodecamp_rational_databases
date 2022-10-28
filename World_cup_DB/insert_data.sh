#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# CREATE TABLE teams(
#     team_id SERIAL PRIMARY KEY UNIQUE NOT NULL,
#     name TEXT UNIQUE NOT NULL);

# CREATE TABLE games(
#     game_id SERIAL PRIMARY KEY NOT NULL,
#     year INT NOT NULL,
#     round VARCHAR(50) NOT NULL,
#     winner_id INT NOT NULL,
#     opponent_id INT NOT NULL,
#     winner_goals INT NOT NULL,
#     opponent_goals INT NOT NULL,    
#     FOREIGN KEY (winner_id) REFERENCES teams(team_id),
#     FOREIGN KEY (opponent_id) REFERENCES teams(team_id)
#     );

echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]] # ignore first row
  then 
    # Get team id for winner team and insert into table
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    
    if [[ -z $TEAM_ID ]]  # if the winner team team_id is empty
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Winner inserted into teams, $winner
      fi
    fi

    # Get team id for opponent team and insert into table
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    if [[ -z $TEAM_ID ]]  # if the winner team team_id is empty
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Opponent inserted into teams, $opponent
      fi
    fi

    # Identify the ids for the winner and opponent teams from above
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    # Insert information into games table
    temp=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) \
     VALUES($year, '$round', '$WINNER_ID', '$OPPONENT_ID', $winner_goals, $opponent_goals)")
    echo $temp
  fi
done



# cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
# do
#   if [[ $year != "year" ]]
#   then 
#     echo $year
#   fi
# done
