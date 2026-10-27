------------------------------------------------------------------------ DOMAĆI ZADATAK 5.1 ------------------------------------------------------------------------

-- 1. Za sezonu 2024/25 prikažite igrače i ukupan broj golova
-- koje su postigli. Prikažite samo igrače koji su postigli bar
-- jedan gol.
-- Pomoću DENSE_RANK() rangirajte igrače prema ukupnom broju
-- golova, od najvećeg ka najmanjem. Igrači sa istim brojem golova
-- treba da imaju isti rang.
SELECT 
    p.first_name,
    p.last_name,
    COUNT(me.event_type) goals,
    DENSE_RANK() OVER(ORDER BY COUNT(me.event_type) DESC) dense
FROM matches m
JOIN match_events me ON m.match_id = me.match_id
JOIN players p ON me.player_id = p.player_id
WHERE season = '2024/25' AND m.status = 'played' AND me.event_type IN ('goal', 'penalty_goal')
GROUP BY p.player_id,
         p.first_name,
         p.last_name
HAVING goals >= 1;


-- 2. Za sezonu 2024/25 prikažite tri igrača sa najviše
-- postignutih golova za svaki klub.
-- Prikažite naziv kluba, ime i prezime igrača i broj postignutih
-- golova. Pomoću ROW_NUMBER() odredite redosled igrača
-- unutar svakog kluba, od najvećeg ka najmanjem broju golova.
SELECT 
    t.team_name,
    p.first_name,
    p.last_name,
    COUNT(me.event_type) goals,
    ROW_NUMBER() OVER(PARTITION BY t.team_name ORDER BY COUNT(me.event_type) DESC) rn
FROM matches m
JOIN match_events me ON m.match_id = me.match_id
JOIN players p ON me.player_id = p.player_id
JOIN teams t ON me.team_id = t.team_id
WHERE season = '2024/25' AND m.status = 'played' AND me.event_type IN ('goal', 'penalty_goal')
GROUP BY t.team_name,
         p.first_name,
         p.last_name
QUALIFY rn IN (1, 2, 3);


-- 3. Za sezonu 2024/25 prikažite sve utakmice svakog kluba,
-- broj golova koje je klub postigao i broj golova koje je postigao
-- u svojoj prethodnoj utakmici.
-- Pomoću LAG() pronađite broj golova iz prethodne utakmice.
-- Izračunajte i razliku između broja golova na tekućoj i prethodnoj
-- utakmici. Rezultate sortirajte po nazivu kluba i datumu
-- utakmice.
SELECT
    t.team_name,
    m.kickoff_ts,
    CASE WHEN m.home_team_id = t.team_id THEN m.home_goals
         WHEN m.away_team_id = t.team_id THEN m.away_goals
         END game_goals_scored,
    LAG(CASE WHEN m.home_team_id = t.team_id THEN m.home_goals
             WHEN m.away_team_id = t.team_id THEN m.away_goals
             END) OVER(PARTITION BY t.team_name ORDER BY m.kickoff_ts) last_game_goals_scored,
    game_goals_scored - LAG(CASE WHEN m.home_team_id = t.team_id THEN m.home_goals
             WHEN m.away_team_id = t.team_id THEN m.away_goals
             END) OVER(PARTITION BY t.team_name ORDER BY m.kickoff_ts) goal_diff
FROM matches m
JOIN teams t ON m.home_team_id = t.team_id OR m.away_team_id = t.team_id
WHERE m.season = '2024/25'
ORDER BY t.team_name, m.kickoff_ts;