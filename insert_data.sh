#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE TABLE games,teams"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #get winner ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #if not found
    if [[ -z $WINNER_ID ]]
    then
        #insert winner
      $PSQL "INSERT INTO teams(name) VALUES('$WINNER')"
      #get new winner ID
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    #get opponent ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert opponent
      $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')"
      #get new oponnent ID
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    #insert game with team IDs
    $PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) VALUES($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID)"
  fi  
done
