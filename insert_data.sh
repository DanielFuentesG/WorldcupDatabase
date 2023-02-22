#! /bin/bash

#defines PSQL var that connects with data base
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
echo $($PSQL "truncate teams, games")
# Do not change code above this line. Use the PSQL variable above to query your database.

#imports file and splits data using comma as delimiter (internal field separator)
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do 
#this cicle search in the database the team name selected in csv file. If its not found, it will be inserted
if [[ $WINNER != "winner" ]]
then
  #get team id
  TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")

  #if not found
  if [[ -z $TEAM_ID ]]
  then
    INSERT_TEAM_NAME=$($PSQL "insert into teams(name) values('$WINNER')")
    if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
    then
      echo Inserted team name into Teams, $WINNER
    fi
    TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  fi
  
  #get opponent
  TEAM_ID=$($PSQL "select name from teams where name='$OPPONENT'")

  #if not found
  if [[ -z $TEAM ]]
  then
    INSERT_TEAM_NAME=$($PSQL "insert into teams(name) values('$OPPONENT')")
    if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
    then
      echo Inserted team name into Teams, $OPPONENT
    fi
    TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  fi

  #last
  WINNERGOLES_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  OPPONENTGOLES_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

  INSERT_GAMEID=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNERGOLES_ID, $OPPONENTGOLES_ID, $WINNERGOALS, $OPPONENTGOALS)")
  if [[ $INSERT_GAMEID == "INSERT 0 1" ]]
  then
    echo inserted into games, $ROUND #$WINNERGOALS $OPPONENTGOALS
  else
    echo could not insert
  fi
  
fi
done