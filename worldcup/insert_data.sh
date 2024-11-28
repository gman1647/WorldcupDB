#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#year,round,winner,opponent,winner_goals,opponent_goals

$($PSQL "TRUNCATE TABLE games, teams;")

cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals


do
  team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")

  if [[ $winner == 'winner' ]]; then
    echo "cool"
  elif
   [[ -z $team_id ]]
  then
    INSERT_winner=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
    if [[ $INSERT_winner == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $winner
    fi
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name ='$winner'")
  fi
done

cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals

do
 team_id=$($PSQL "SELECT team_id FROM teams WHERE name=$opponent")

  if [[ $opponent == 'opponent' ]]; then
    echo "cool"
  elif [[ -z $team_id ]]
  then
    INSERT_opponent=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
    if [[ $INSERT_opponent == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $opponent
    fi
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name ='$opponent'")
  fi

  # year=$($PSQL "SELECT year FROM games WHERE year=$year")
done

cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals

do
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
  INSERT_GAME=$($PSQL "INSERT INTO games(year, round, opponent_id, winner_id, winner_goals, opponent_goals) VALUES($year, '$round', $opponent_id, $winner_id, $winner_goals, $opponent_goals)")
  if [[ $INSERT_GAME == 'INSERT 0 1' ]] 
    then echo Inserted into games: $winner vs. $opponent
  fi
done