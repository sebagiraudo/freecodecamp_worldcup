#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE games, teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $WINNER != winner ]]
  then
    # get winner_id
    W_ID_RES=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $W_ID_RES ]]
    then
      # create winner
      W_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi

  if [[ $OPPONENT != opponent ]]
  then
    # get opponent_id
    O_ID_RES=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $O_ID_RES ]]
    then
      # create opponent
      O_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    O_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

  if [[ $YEAR != year ]]
  then
  # insert game
    GAME_ID=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$W_ID','$O_ID','$W_GOALS','$O_GOALS')")
  fi




done


