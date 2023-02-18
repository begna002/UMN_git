import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import sqlite3
import matplotlib.pyplot as plt

path = "/mnt/c/Users/mbegn/OneDrive/Desktop/MS Materials/5707/project4/"
database = path + "database.sqlite"
conn = sqlite3.connect(database)
cursor = conn.cursor()


pathToCSV = "/mnt/c/Users/mbegn/OneDrive/Desktop/MS Materials/5707/project4/KRC_goals.csv"
pathToCSV2 = "/mnt/c/Users/mbegn/OneDrive/Desktop/MS Materials/5707/project4/all_team_goals.csv"
pathToCSV3 = "/mnt/c/Users/mbegn/OneDrive/Desktop/MS Materials/5707/project4/all_team_average_goals.csv"
pathToCSV4 = "/mnt/c/Users/mbegn/OneDrive/Desktop/MS Materials/5707/project4/team_with_highest_average_goals.csv"
pathToCSV5 = "/mnt/c/Users/mbegn/OneDrive/Desktop/MS Materials/5707/project4/all_matches.csv"
pathToCSV6 = "/mnt/c/Users/mbegn/OneDrive/Desktop/MS Materials/5707/project4/all_teams.csv"
pathToCSV9 = "/mnt/c/Users/mbegn/OneDrive/Desktop/MS Materials/5707/project4/team.csv"
pathToCSV10 = "/mnt/c/Users/mbegn/OneDrive/Desktop/MS Materials/5707/project4/league.csv"
pathToCSV11 = "/mnt/c/Users/mbegn/OneDrive/Desktop/MS Materials/5707/project4/match.csv"

####ALL TEAM GOALS
##all_team_goals = pd.read_sql("""
##SELECT Team.team_long_name AS team_name,
##Team.team_api_id AS team_id,
##CASE
##    WHEN Match.home_team_api_id = Team.team_api_id
##        THEN MATCH.home_team_goal
##        ELSE MATCH.away_team_goal
##END as goals
##FROM Team
##LEFT JOIN Match on Match.home_team_api_id = Team.team_api_id OR Match.away_team_api_id = Team.team_api_id;""", conn)
##all_team_goals.to_csv(pathToCSV)

####KRC ONLY MATCHES
##KRC_goals = pd.read_sql("""
##SELECT Match.home_team_api_id as h_team_id,
##Match.away_team_api_id as a_team_id,
##Match.home_team_goal as h_team_goal,
##Match.away_team_goal as a_team_goal
##FROM Match
##WHERE Match.home_team_api_id = '9987' OR Match.away_team_api_id  = '9987'
##;""", conn)
##KRC_goals.to_csv(pathToCSV2)


####ALL TEAM AVERAGE GOALS 
##all_team_average_goals = pd.read_sql("""
##SELECT team_id,
##team_name,
##AVG(goals) as avg_goals
##FROM
##    (SELECT Team.team_long_name AS team_name,
##    Team.team_api_id AS team_id,
##    CASE
##        WHEN Match.home_team_api_id = Team.team_api_id
##            THEN MATCH.home_team_goal
##            ELSE MATCH.away_team_goal
##    END as goals
##    FROM Team
##    LEFT JOIN Match on Match.home_team_api_id = Team.team_api_id OR Match.away_team_api_id = Team.team_api_id)
##GROUP BY team_id, team_name;""", conn)
##all_team_average_goals.to_csv(pathToCSV3)

####TEAM WITH HIGHEST AVERAGE GOALS
cursor.executescript("""
DROP TABLE IF EXISTS 'all_matches';
DROP TABLE IF EXISTS 'all_teams';
DROP TABLE IF EXISTS 'all_team_goals';
DROP TABLE IF EXISTS 'all_team_average_goals';
DROP TABLE IF EXISTS 'team_with_highest_average_goals';

CREATE TABLE IF NOT EXISTS all_matches AS
SELECT id,
home_team_api_id,
away_team_api_id,
home_team_goal,
away_team_goal
FROM MATCH;

CREATE TABLE IF NOT EXISTS all_teams AS
SELECT team_long_name,
team_api_id
FROM TEAM;

CREATE TABLE IF NOT EXISTS all_team_goals AS
SELECT all_teams.team_long_name AS team_name,
all_teams.team_api_id AS team_id,
all_matches.id as match_id,
CASE
    WHEN all_matches.home_team_api_id = all_teams.team_api_id
        THEN all_matches.home_team_goal
        ELSE all_matches.away_team_goal
END as goals
FROM all_teams
LEFT JOIN all_matches on all_matches.home_team_api_id = all_teams.team_api_id OR all_matches.away_team_api_id = all_teams.team_api_id;

CREATE TABLE IF NOT EXISTS all_team_average_goals AS
SELECT team_id,
team_name,
AVG(goals) as avg_goals
FROM all_team_goals
GROUP BY team_id, team_name;

CREATE TABLE IF NOT EXISTS team_with_highest_average_goals AS
Select team_id,
team_name,
avg_goals as highest_average_goal
FROM all_team_average_goals
WHERE avg_goals = (SELECT MAX(avg_goals) FROM all_team_average_goals)
;""")

cursor.execute("SELECT * FROM all_matches") 
columns = [desc[0] for desc in cursor.description]
all_matches = pd.DataFrame(cursor.fetchall(), columns=columns)
all_matches.to_csv(pathToCSV5)


cursor.execute("SELECT * FROM all_teams") 
columns = [desc[0] for desc in cursor.description]
all_teams = pd.DataFrame(cursor.fetchall(), columns=columns)
all_teams.to_csv(pathToCSV6)


cursor.execute("SELECT * FROM all_team_goals") 
columns = [desc[0] for desc in cursor.description]
all_team_goals = pd.DataFrame(cursor.fetchall(), columns=columns)
all_team_goals.to_csv(pathToCSV2)

cursor.execute("SELECT * FROM all_team_average_goals") 
columns = [desc[0] for desc in cursor.description]
all_team_average_goals = pd.DataFrame(cursor.fetchall(), columns=columns)
all_team_average_goals.to_csv(pathToCSV3)

cursor.execute("SELECT * FROM team_with_highest_average_goals") 
columns = [desc[0] for desc in cursor.description]
team_with_highest_average_goals = pd.DataFrame(cursor.fetchall(), columns=columns)
team_with_highest_average_goals.to_csv(pathToCSV4)


cursor.execute("SELECT * FROM TEAM LIMIT 30") 
columns = [desc[0] for desc in cursor.description]
all_matches = pd.DataFrame(cursor.fetchall(), columns=columns)
all_matches.to_csv(pathToCSV9)



cursor.execute("SELECT * FROM LEAGUE LIMIT 30") 
columns = [desc[0] for desc in cursor.description]
all_matches = pd.DataFrame(cursor.fetchall(), columns=columns)
all_matches.to_csv(pathToCSV10)



cursor.execute("SELECT * FROM MATCH LIMIT 30") 
columns = [desc[0] for desc in cursor.description]
all_matches = pd.DataFrame(cursor.fetchall(), columns=columns)
all_matches.to_csv(pathToCSV11)
