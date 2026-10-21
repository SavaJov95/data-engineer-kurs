-------------------------------------------------------------------------DOMAĆI ZADATAK 3.1-------------------------------------------------------------------------

-- 1. Za svaku sezonu prikažite ukupan broj utakmica, ukupan broj
-- postignutih golova i prosečan broj golova po utakmici.
SELECT 
    season,
    COUNT(*) AS total_games,
    SUM(home_goals + away_goals) AS total_goals,
    ROUND(AVG(home_goals + away_goals), 2) AS average_goals_per_game
FROM matches_flat
GROUP BY season;
-- 2023/24 - 381 mečeva, 1046 golova ukupno, 2,75 golova po meču
-- 2024/25 - 380 mečeva, 1092 golova ukupno, 2,87 golova po meču


-- 2. Za svaki stadion prikažite najmanju, najveću i prosečnu zabeleženu
-- posetu, kao i broj utakmica za koje je poseta poznata.
SELECT 
    stadium_name,
    MIN(attendance) AS minimum_attendance,
    MAX(attendance) AS maximum_attendance,
    ROUND(AVG(attendance), 0) AS average_attendance,
    COUNT(attendance) AS reported_attendance_games
FROM matches_flat
GROUP BY stadium_name;


-- 3. Prikažite sudije koje su sudile najmanje 10 utakmica i koje su
-- ukupno pokazale najmanje 20 žutih kartona. Prikažite ime sudije, broj
-- utakmica i ukupan broj žutih kartona.
SELECT 
    referee_name,
    COUNT(*) AS games_officiated,
    SUM(home_yellow_cards + away_yellow_cards) AS total_yellow_cards
FROM matches_flat
GROUP BY referee_name
HAVING COUNT(*) >= 10 AND SUM(home_yellow_cards + away_yellow_cards) >= 20;


-- 4. Podelite utakmice prema ukupnom broju golova na kategorije Bez
-- golova (0), Malo golova (1 ili 2) i Mnogo golova (3 ili više). Prikažite
-- broj utakmica u svakoj kategoriji i najveći broj golova na utakmici u
-- toj kategoriji.
SELECT
    CASE
        WHEN home_goals + away_goals = 0 THEN 'Bez golova'
        WHEN home_goals + away_goals <= 2 THEN 'Malo golova'
        ELSE 'Mnogo golova' END AS kategorije,
    COUNT(*) AS broj_utakmica,
    MAX(home_goals + away_goals) AS najveci_broj_golova
FROM matches_flat
GROUP BY kategorije;
-- Mnogo golova - 390/9; Malo golova - 330/2; Bez golova - 41/0;


-- 5. Za svaki klub prikažite broj utakmica koje je odigrao kao domaćin,
-- broj pobeda kod kuće i broj poraza kod kuće. U rezultat uključite
-- samo klubove koji su kod kuće odigrali najmanje 10 utakmica.
SELECT
    home_team,
    COUNT(*) AS home_games_played,
    SUM(CASE 
            WHEN home_goals > away_goals THEN 1 ELSE 0 END
        ) AS number_of_home_wins,
    SUM(CASE 
            WHEN home_goals < away_goals THEN 1 ELSE 0 END
        ) AS number_of_home_loses
FROM matches_flat
GROUP BY home_team
HAVING COUNT(*) >= 10;


-- 6. Za svakog sudiju prikažite ukupan broj utakmica, broj utakmica u
-- kojima je pokazao bar jedan crveni karton i procenat takvih utakmica
-- u odnosu na sve utakmice koje je sudio.
SELECT
    referee_name,
    COUNT(*) AS games_officiated,
    SUM(CASE WHEN home_red_cards + away_red_cards > 0 THEN 1 ELSE 0 END) AS games_with_red_card,
    ROUND(
        SUM(CASE
                WHEN home_red_cards + away_red_cards > 0 THEN 1 ELSE 0 END
            ) / COUNT(*) * 100, 2
        ) AS games_with_red_card_pct
FROM matches_flat
GROUP BY referee_name;


-- 7. Za svaku sezonu prikažite broj pobeda domaćina, broj nerešenih
-- utakmica i broj pobeda gostiju. Takođe prikažite procenat utakmica
-- koje su završene nerešenim rezultatom.
SELECT
    season,
    SUM(CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS home_wins,
    SUM(CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END) AS draws,
    SUM(CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END) AS away_wins,
    ROUND(SUM(CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END) / COUNT(*), 2) AS draw_pct
FROM matches_flat
GROUP BY season;
-- 2023/24 - 172 | 96 | 112 | 0.25; 2024/25 - 157 | 95 | 128 | 0.25