#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WIN OPP WIN_GOS OPP_GOS
do
  if [[ $YEAR != "year" ]]
  then #inserting team names
    TEAM_ID_WIN=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    TEAM_ID_OPP=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    # Check if Winning Team Id exists
    if [[ -z $TEAM_ID_WIN ]]
    # Insert Winning Team into teams database
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$WIN')")
    fi
    # Check if Opposing Team Id exists
    if [[ -z $TEAM_ID_OPP ]]
    # Insert Opposing Team into teams database
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$OPP')")
    fi
    # Get Winning Team_ID
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    echo $WIN_ID
    # Get Opposing Team ID
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    echo $OPP_ID
    # Insert data into games database
    echo $($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WIN_ID,$OPP_ID,$WIN_GOS,$OPP_GOS)")
  fi
done