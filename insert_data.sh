#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#clear tables
echo $($PSQL "TRUNCATE teams, games")

# Add each unique team to the teams table (24 rows)
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

# Add from Winner column in games.csv
do
  if [[ $WINNER != "winner" ]]
  then
    if [[ $WINNER != "name" ]] 
    then
      #get name
      WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")

      #if not found
      if [[ -z $WINNER_NAME ]]
      then
        #insert name
        INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_WINNER_NAME == "INSERT 0 1" ]]
        then
          echo "Insert into teams, $WINNER"
        fi
      fi

      #get new name
      NAME=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
    
    fi
  fi

  # Add from Opponent column in games.csv
  if [[ $OPPONENT != "opponent" ]]
  then
    if [[ $OPPONENT != "name" ]]
    then
      #get name
      OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")

      #if not found
      if [[ -z $OPPONENT_NAME ]]
      then
        #insert name
        INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]
        then
          echo "Insert into teams, $OPPONENT"
        fi
      fi

      #get new name
      NAME=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
    
    fi
  fi
done


# Add each game into games
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
# Get each team's ID
do
  if [[ $WINNER != "winner" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

  # Add all games information into games table
  if [[ $YEAR != "year" ]]
  then
    INSERT_DETAILS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_DETAILS == "INSERT 0 1" ]]
    then
      echo "Insert into games, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
    fi
  fi
done
