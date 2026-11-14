import pandas as pd
R = '/Volumes/bootcamp/northern_star/raw_2025_26/'
m = pd.read_parquet(R + 'matches_2025_26.parquet')

# 1. Analiza rezultata utakmica
#   1.Pronaći sve utakmice u kojima su oba tima postigla bar po
#   jedan gol.
both_teams_scored = m[(m['home_goals'] >= 1) & (m['away_goals'] >= 1)]

#   2.Pronaći sve utakmice u kojima je domaćin pobedio sa tačno
#   jednim golom razlike.
home_win_by_one_goal_diff = m[m['home_goals'] - m['away_goals'] == 1]

#   3.Koliko utakmica je završeno rezultatom 0:0?
print((m['home_goals'] + m['away_goals'] == 0).sum()) # 26 utakmica

#   4.Prikazati 10 utakmica sa najviše ukupno postignutih golova.
m['total_goals'] = m['home_goals'] + m['away_goals']
m.nlargest(10, 'total_goals')



# 2. Analiza jednog tima. Za tim po izboru: 'GMW'
#   1.Prikazati sve utakmice u kojima je učestvovao.
gmw_m = m[(m['home_team'] == 'GMW') | (m['away_team'] == 'GMW')].copy()
gmw_m

#   2.Koliko je puta pobedio, izgubio i odigrao nerešeno?
gmw_m['venue'] = 'H'
gmw_m.loc[gmw_m['away_team'] == 'GMW', 'venue'] = 'A'

gmw_m['result'] = 'W'
gmw_m.loc[gmw_m['home_goals'] == gmw_m['away_goals'], 'result'] = 'D'
gmw_m.loc[(gmw_m['venue'] == 'H') & (gmw_m['home_goals'] < gmw_m['away_goals']) |
          (gmw_m['venue'] == 'A') & (gmw_m['home_goals'] > gmw_m['away_goals']), 'result'] = 'L'
gmw_m['result'].value_counts() # W 18, D 10, L 10

#   3.Koliko je golova postigao kao domaćin, a koliko kao gost?
scored_goals_at_home = gmw_m[gmw_m['venue'] == 'H'][['home_goals']].sum() # 26
scored_goals_at_away = gmw_m[gmw_m['venue'] == 'A'][['away_goals']].sum() # 28

#   4.Pronaći utakmicu u kojoj je postigao najviše golova.
gmw_m['our_team_goals'] = gmw_m['home_goals']
gmw_m.loc[gmw_m['venue'] == 'A', 'our_team_goals'] = gmw_m['away_goals']
gmw_m.sort_values('our_team_goals', ascending=False).head(1)



# 3. Analiza stadiona
    # 1.Prikazati sve različite stadione na kojima su odigrane utakmice.
m['stadium'].unique()

    # 2.Pronaći stadion na kojem je odigrano najviše utakmica.
m['stadium'].value_counts().head(1)

    # 3.Za svaki stadion izračunati prosečnu posećenost.
avg_attendance_by_stadium = m.groupby('stadium', as_index=False)['attendance'].mean()

    # 4.Prikazati pet stadiona sa najvećom prosečnom posećenošću.
avg_attendance_by_stadium.sort_values('attendance', ascending = False).head()