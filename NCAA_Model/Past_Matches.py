import pandas as pd
import sys
data = pd.read_csv("NCAATourneyDetailedREsultsEnriched2018.csv")
teams = pd.read_csv("Teams.csv")

d = {'this_team' :[], 'other_team' : [], 'won' :[], 'year' :[], 'score': []}
TEAMS = {}

for i in range(len(teams.TeamID)):
    TEAMS[teams.TeamID[i]] = teams.TeamName[i]

for i in range(len(data.WTeamID)):
    d['this_team'].append(TEAMS.get(data.WTeamID[i]))
    d['this_team'].append(TEAMS.get(data.LTeamID[i]))
    
    d['other_team'].append(TEAMS.get(data.LTeamID[i]))
    d['other_team'].append(TEAMS.get(data.WTeamID[i]))

    d['won'].append('Win')
    d['won'].append('Lose')

    d['year'].append(data.Season[i])
    d['year'].append(data.Season[i])

    d['score'].append((data.WScore[i], data.LScore[i]))
    d['score'].append((data.LScore[i], data.WScore[i]))


def all_matches():
    for i in range(len(d['this_team'])):
        print("This Team:", d['this_team'][i], "| Other Team:", d['other_team'][i], "| Won/Lost: ", d['won'][i], "| Year:", d['year'][i])

def Match_Up(team1, team2):
    print("")
    num_won = 0
    num_lost = 0
    years_won = []
    years_lost = []
    losing_score =[]
    winning_score =[]
    for i in range(len(d['this_team'])):
        if d['this_team'][i] == team1 and d['other_team'][i] == team2:
            if d['won'][i] == 'Win':
                num_won += 1
                years_won.append(d['year'][i])
                winning_score.append(d['score'][i])
            else:
                num_lost += 1
                years_lost.append(d['year'][i])
                losing_score.append(d['score'][i])
    if num_won != 0 or num_lost != 0:
        print("Since 2003", team1, "has won", num_won, "times, and lost", num_lost, "times against", team2, "in the NCAA Tournament")

        if len(years_won) > 0:
            print("")
            print("Years Won:")
            print(years_won, winning_score)
        if len(years_lost) > 0:
            print("")
            print("Years Lost:")
            print(years_lost, losing_score)
        
    else:
        print("Since 2003,", team1, "hasn't had a match-up against", team2, "in the NCAA Tournament (Check Spelling)")



def year_Champ(year):
    print("")
    for i in range(len(d['year'])):
        if year == 2017:
            print(year, "NCAA CHAMPION:", d['other_team'][-1])
            print("Played against:", d['this_team'][-1])
            print("Score:", d['score'][-2])
            break
        if d['year'][i] == (year + 1):
            print(year, "NCAA CHAMPION:", d['other_team'][i-1])
            print("Played against:", d['this_team'][i-1])
            print("Score:", d['score'][i-2])
            break

def history(team):
    champion = []
    final_loser = []
    print("")
    last = False
    found = False
    if team == 'North Carolina':
        last = True
    for i in range(len(d['this_team'])):
        if d['this_team'][i] == team and d['won'][i] == 'Win':
            found = True
            print("Year:", d['year'][i], "| Match against:", d['other_team'][i], "| Outcome: ", d['won'][i], "| Score:", d['score'][i])
            if d['year'][i] != 2017:
                if (d['year'][i+2]) == (d['year'][i] + 1):
                    champion.append(d['year'][i])
                    final_loser.append(d['other_team'][i])
                    print("CHAMPION")
        if d['this_team'][i] == team and d['won'][i] == 'Lose':
            founr = True
            print("Year:", d['year'][i], "| Match against:", d['other_team'][i], "| Outcome: ", d['won'][i], "| Score:", d['score'][i])
    if len(champion) > 0:
        print("")
        print("NCAA Champions in:")
        for i in range(len(champion)):
            print(champion[i], "against", final_loser[i])
    if last == True:
        print("2017 against Gonzaga")
    if found == False:
        print(team, "has not played in the NCAA tournament since 2003")


ext = False
print("Options:")
print(" --Type Winner Year to get Champion of given year (from 2003-2017)")
print(" --Type all to get all NCAA Tournament match results (from 2003-2017)")
print(" --Type Team to get results of this team's past matches of NCAA Tournament (from 2003-2017)")
print(" --Type Team 1 Team 2 to get results of NCAA Tournament matches (from 2003-2017)")
print(" --NOTE: If Team is 2 words, combine with ''")
print(" --Type exit to end program")
print(" --Type help at any time to get options")
while(ext != True):
    print("")
    inpt = input("Enter: ")
    inpt = inpt.split(" ")
    i = 0
    inpt_list = []
    if inpt != ['']:
        while i < len(inpt):
            sub = inpt[i]
            if sub[0] == "'":
                strn = inpt[i] + " " + inpt[i+1]
                length = len(strn) - 1
                new_strn = strn[1:length]
                inpt_list.append(new_strn)
                i += 2
            else:
                inpt_list.append(inpt[i])
                i += 1

    if len(inpt_list) == 1:
        if inpt_list[0] == 'help' or inpt_list[0] == 'Help':
            print("Options:")
            print(" --Type Winner Year to get Champion of given year (from 2003-2017)")
            print(" --Type all to get all NCAA Tournament match results (from 2003-2017)")
            print(" --Type Team to get results of this team's past matches of NCAA Tournament (from 2003-2017)")
            print(" --Type Team 1 Team 2 to get results of NCAA Tournament matches (from 2003-2017)")
            print(" --NOTE: If Team is 2 words, combine with ''")
            print(" --Type exit to end program")
            print(" --Type help at any time to get options")
        elif inpt_list[0] == 'all' or inpt_list[0] == 'All':
            all_matches()
        elif inpt_list[0] == 'exit' or inpt_list[0] == 'Exit':
            ext = True
        else:
            team = inpt_list[0]
            history(team)

    if len(inpt_list) == 2:
        if inpt_list[0] == 'Winner':
            yearC = inpt_list[1]
            yearI = int(yearC)
            year_Champ(yearI)
            
        else:
            team1 = inpt_list[0]
            team2 = inpt_list[1]
            Match_Up(team1, team2)

    if len(inpt_list) < 1 or len(inpt_list) > 2:
        print("Error: No teams given to compute past match-ups")
        print("")
        print("Must give proper inputs")

print("Done")
