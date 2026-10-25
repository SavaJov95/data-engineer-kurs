------------------------------------------------------------------------ DOMAĆI ZADATAK 4.2 ------------------------------------------------------------------------

-- 1. Сезона у бројевима: утакмице, победе, нерешене, порази, дати и примљени голови, бодови.
WITH club AS (
    SELECT team_id, team_name 
    FROM teams 
    WHERE team_name = 'Lakeside Rangers'
), 
stats AS (
    SELECT
        c1.team_name,
        m1.home_goals goals_for, 
        m1.away_goals goals_against
    FROM club c1
    JOIN matches m1 ON m1.home_team_id = c1.team_id 
    WHERE m1.season = '2024/25' AND m1.status = 'played'
    UNION ALL
    SELECT
        c2.team_name,
        m2.home_goals goals_against, 
        m2.away_goals goals_for
    FROM club c2
    JOIN matches m2 ON m2.away_team_id = c2.team_id 
    WHERE m2.season = '2024/25' AND m2.status = 'played'
)
SELECT 
    team_name,
    COUNT(*) total_matches,
    SUM(CASE WHEN goals_for > goals_against THEN 1 ELSE 0 END) wins,
    SUM(CASE WHEN goals_for = goals_against THEN 1 ELSE 0 END) draws,
    SUM(CASE WHEN goals_for < goals_against THEN 1 ELSE 0 END) losses,
    SUM(goals_for) goals_scored,
    SUM(goals_against) goals_conceded,
    SUM(CASE WHEN goals_for > goals_against THEN 3
             WHEN goals_for < goals_against THEN 0
             ELSE 1 END) score
FROM stats
GROUP BY team_name;



-- 2. Код куће и у гостима: исти бројеви, одвојено за домаће и гостујуће утакмице.
WITH club AS (
    SELECT team_id, team_name 
    FROM teams 
    WHERE team_name = 'Lakeside Rangers'
), 
stats AS (
    SELECT
        c1.team_name,
        m1.home_goals goals_for, 
        m1.away_goals goals_against,
        'home' venue
    FROM club c1
    JOIN matches m1 ON m1.home_team_id = c1.team_id 
    WHERE m1.season = '2024/25' AND m1.status = 'played'
    UNION ALL
    SELECT
        c2.team_name,
        m2.home_goals goals_against, 
        m2.away_goals goals_for,
        'away' venue
    FROM club c2
    JOIN matches m2 ON m2.away_team_id = c2.team_id 
    WHERE m2.season = '2024/25' AND m2.status = 'played'
)
SELECT 
    team_name,
    venue,
    COUNT(*) total_matches,
    SUM(CASE WHEN goals_for > goals_against THEN 1 ELSE 0 END) wins,
    SUM(CASE WHEN goals_for = goals_against THEN 1 ELSE 0 END) draws,
    SUM(CASE WHEN goals_for < goals_against THEN 1 ELSE 0 END) loses,
    SUM(goals_for) goals_scored,
    SUM(goals_against) goals_conceded,
    SUM(CASE WHEN goals_for > goals_against THEN 3
             WHEN goals_for < goals_against THEN 0
             ELSE 1 END) score
FROM stats
GROUP BY team_name, venue;



-- 3. Стрелци: три најбоља стрелца клуба и најбољи асистент.
WITH club AS (
    SELECT team_id, team_name 
    FROM teams 
    WHERE team_name = 'Lakeside Rangers'
)
SELECT 
    p.first_name,
    p.last_name,
    COUNT(*) goals
FROM match_events me
JOIN club c ON me.team_id = c.team_id
JOIN players p ON p.player_id = me.player_id
JOIN matches m ON m.match_id = me.match_id
WHERE me.event_type IN ('penalty_goal', 'goal') AND m.season = '2024/25' AND m.status = 'played'
GROUP BY p.first_name,
         p.last_name
ORDER BY COUNT(*) DESC;
-- Jamal Kerr je najbolji golgeter kluba Lakeside Rangers u sezoni 2024/25 sa 
-- 10 pogotka, Tyler Dawson iza njega sa 7 golova a treće mesto dele Marcus 
-- Fletcher i Luke Hughes sa 6 uspešnih šuteva

WITH club AS (
    SELECT team_id, team_name 
    FROM teams 
    WHERE team_name = 'Lakeside Rangers'
)
SELECT 
    p.player_id,
    p.first_name,
    p.last_name,
    COUNT(*) assists
FROM match_events me
JOIN club c ON me.team_id = c.team_id
JOIN players p ON p.player_id = me.related_player_id
JOIN matches m ON me.match_id = m.match_id
WHERE me.event_type = 'goal' AND m.season = '2024/25' AND m.status = 'played'
GROUP BY p.player_id,
         p.first_name,
         p.last_name
ORDER BY COUNT(*) DESC;
-- Najbolji asistenta Lakeside Rangersa u sezoni 2024/25 su bili 
-- Declan Foster i Marko Jovanović sa po 3 odlučujuća dodavanja



-- 4. Дисциплина: картони клуба по утакмици у поређењу са просеком лиге по тиму по утакмици.
WITH club AS (
    SELECT team_id, team_name 
    FROM teams 
    WHERE team_name = 'Lakeside Rangers'
)
SELECT COUNT(me.event_type) / COUNT(DISTINCT me.match_id) average_cards_per_game
FROM match_events me
JOIN club c ON me.team_id = c.team_id
JOIN matches m ON m.match_id = me.match_id
WHERE me.event_type IN ('yellow_card', 'second_yellow', 'red_card') AND m.season = '2024/25' AND m.status = 'played';

SELECT 
    COUNT(me.event_type) / COUNT(DISTINCT m.match_id) average_cards_in_league
FROM matches m
LEFT JOIN match_events me ON me.match_id = m.match_id AND me.event_type IN ('yellow_card', 'second_yellow', 'red_card')
WHERE m.season = '2024/25' AND m.status = 'played';
-- prosek kartona u ligi iznosi 3.473684210526316 a 1.8275862068965518 je prosek kartona Lakeside Rangersa 



-- 5. Тренери: ко је водио клуб у сезони и са колико бодова по утакмици.
WITH club AS (
    SELECT team_id, team_name 
    FROM teams 
    WHERE team_name = 'Lakeside Rangers'
),
stats AS (
    SELECT
        c1.team_name,
        ms.manager_name,
        m1.home_goals goals_for, 
        m1.away_goals goals_against
    FROM club c1
    JOIN matches m1 ON m1.home_team_id = c1.team_id
    JOIN manager_spells ms ON ms.team_id = c1.team_id 
    WHERE m1.season = '2024/25' AND m1.status = 'played'
    UNION ALL
    SELECT
        c2.team_name,
        ms.manager_name,
        m2.home_goals goals_against, 
        m2.away_goals goals_for
    FROM club c2
    JOIN matches m2 ON m2.away_team_id = c2.team_id
    JOIN manager_spells ms ON ms.team_id = c2.team_id 
    WHERE m2.season = '2024/25' AND m2.status = 'played'
)
SELECT 
    team_name,
    manager_name,
    SUM(CASE WHEN goals_for > goals_against THEN 3
             WHEN goals_for < goals_against THEN 0
             ELSE 1 END) / COUNT(*) points_per_game
FROM stats
GROUP BY team_name,
         manager_name;
-- Vincent Kompany jedini vodio klub u sezoni 2024/25 - svih 38 mečeva (1.6 bodova po utakmici)



-- 6. Највећа победа и најтежи пораз.
WITH club AS (
    SELECT team_id, team_name 
    FROM teams 
    WHERE team_name = 'Lakeside Rangers'
),
stats AS (
    SELECT 
        c.team_name our_team,
        t.team_name opponent,
        s.stadium_name,
        m.home_goals goals_for,
        m.away_goals goals_against
    FROM matches m
    JOIN club c ON m.home_team_id = c.team_id
    JOIN teams t ON t.team_id = m.away_team_id
    JOIN stadiums s ON m.stadium_id = s.stadium_id
    WHERE m.season = '2024/25' AND m.status = 'played'
    UNION ALL
    SELECT 
        c.team_name,
        t.team_name,
        s.stadium_name,
        m.home_goals goals_against,
        m.away_goals goals_for
    FROM matches m
    JOIN club c ON m.away_team_id = c.team_id
    JOIN teams t ON t.team_id = m.home_team_id
    JOIN stadiums s ON m.stadium_id = s.stadium_id
    WHERE m.season = '2024/25' AND m.status = 'played'
),
diff AS (
    SELECT 
        *,
        CASE WHEN goals_for > goals_against THEN 'win'
            ELSE 'lose' END outcome,
        ABS(goals_for - goals_against) diff
    FROM stats
    WHERE goals_for <> goals_against
),
goal_margin AS (
    SELECT 
        outcome,
        MAX(diff) maximum_diff
    FROM diff
    GROUP BY outcome
)
select
    d.our_team,
    d.opponent,
    d.stadium_name,
    d.outcome,
    CONCAT(goals_for, '-', goals_against) score
from diff d
JOIN goal_margin gm ON d.outcome = gm.outcome AND d.diff = gm.maximum_diff
ORDER BY outcome;
-- Najubedljivija pobeda Lakeside Rangersa je bila na domacem terenu Lakeside stadionu 
-- i to u tri navrata po 5:0 (protiv Valemont United, Dunmore Celtic i Elmsworth Wanderers) 
-- a najveći poraz od Westmere Town kod kuće 3:0 i Ashford Rovers u gostima 3:0



-- 7. Публика: просечна посета и попуњеност на домаћим утакмицама, и колико утакмица нема
-- податак о посети.
WITH club AS (
    SELECT team_id, team_name 
    FROM teams 
    WHERE team_name = 'Lakeside Rangers'
)
SELECT ROUND(AVG(m.attendance), 0) average_attendance,
       ROUND(100.0 * AVG(m.attendance) / MAX(s.capacity), 2) capacity_utilization_pct,
       COUNT(*) - COUNT(m.attendance) games_with_unidentified_attendance
FROM matches m
JOIN club c ON m.home_team_id = c.team_id
JOIN stadiums s ON m.stadium_id = s.stadium_id
WHERE m.season = '2024/25' AND m.status = 'played';
-- prosecna poseta 25482, popunjenost 83.55% jer je kapacitet 30500 i svaki meč ima podatak o 
-- poseti na stadionu ekipe Lakeside Rangers