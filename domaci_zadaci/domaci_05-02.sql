------------------------------------------------------------------------ DOMAĆI ZADATAK 5.2 ------------------------------------------------------------------------

-- 1. Prosek datih golova u poslednjih 5 utakmica, uz izričit
-- okvir prozora. Koja je najveća vrednost? Računajte
-- samo kada prozor zaista ima 5 utakmica.
WITH rank_avg AS (
SELECT 
    match_id,
    kickoff_ts,
    home_goals + away_goals total_goals,
    AVG(home_goals + away_goals) OVER(ORDER BY kickoff_ts, match_id ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) goals_5d_avg,
    ROW_NUMBER() OVER(ORDER BY kickoff_ts, match_id) rn
FROM matches
WHERE status = 'played'
)
SELECT 
    match_id,
    kickoff_ts,
    total_goals,
    CASE WHEN rn >= 5 THEN goals_5d_avg
         ELSE NULL END first_rows_clean
FROM rank_avg
ORDER BY first_rows_clean DESC;
-- I način
-- najveca vrednost je 5 golova u proseku u poslednjih 
-- pet utakmica, prvo sam uradio na ovaj način, ovde 
-- nisam gledao tim kao grupu već sve utakmice u sezoni

WITH rank_avg AS (
SELECT 
    match_id,
    kickoff_ts,
    team_id,
    goals_for,
    AVG(goals_for) OVER(PARTITION BY team_id ORDER BY kickoff_ts, match_id ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) goals_5d_avg
FROM team_matches
),
rank AS (
SELECT
    *,
    ROW_NUMBER() OVER(PARTITION BY team_id ORDER BY kickoff_ts, match_id) rn
FROM rank_avg
)
SELECT 
    r.kickoff_ts,
    t.team_name,
    CASE WHEN r.rn >= 5 THEN r.goals_5d_avg
         ELSE NULL END first_rows_clean
FROM rank r
JOIN teams t ON r.team_id = t.team_id 
ORDER BY first_rows_clean DESC;
-- II način
-- Ovde grupisem po timu u dobijam da je Pemberton United imao 
-- najveci iznos prosecnih golova u prethodne 5 utakmice, i da 
-- je to ostvario zaključno sa utakmicom odigranom 21.12.2024.god


-- 2. Tekući zbir datih golova svakog kluba u sezoni
-- 2024/25: ko je prvi stigao do 50 golova i kada?
WITH rank_summed_goals AS (
SELECT 
    tm.match_id,
    tm.kickoff_ts,
    t.team_name,
    SUM(tm.goals_for) OVER(PARTITION BY t.team_name ORDER BY tm.kickoff_ts, tm.match_id) goals_cummulative_sum
FROM team_matches tm
JOIN teams t ON tm.team_id = t.team_id
WHERE season = '2024/25'
)
SELECT
    kickoff_ts,
    team_name,
    goals_cummulative_sum
FROM rank_summed_goals
WHERE goals_cummulative_sum >= 50
QUALIFY ROW_NUMBER() OVER(PARTITION BY team_name ORDER BY kickoff_ts, match_id) = 1
ORDER BY kickoff_ts;
-- Kingsbridge City je u sezoni 2024/25 prvi stigao do 50+ 
-- postignutih golova u meču odigranom 18.01.2025.godine


-- 3. Za svaku domaću utakmicu izračunajte promenu
-- posećenosti u odnosu na prethodnu domaću utakmicu
-- istog kluba u istoj sezoni. Gde je najveći pad i zašto?
SELECT 
    m.season,
    t.team_name,
    m.match_id,
    m.kickoff_ts,
    m.attendance,
    LAG(m.attendance) OVER(PARTITION BY m.season, t.team_name ORDER BY m.kickoff_ts, m.match_id,) prev_match_attendance,
    m.attendance - prev_match_attendance attendance_difference
FROM matches m
JOIN teams t ON m.home_team_id = t.team_id
WHERE m.status = 'played'
ORDER BY attendance_difference NULLS LAST;
-- najveci pad je u utakmici gde je Oakfield Town igrao pred 
-- praznim stadionom verovatno zbog neke suspenzije, a u meču 
-- pre toga je na stadionu bilo 17.864 gledalaca