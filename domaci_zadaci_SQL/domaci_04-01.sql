------------------------------------------------------------------------ DOMAĆI ZADATAK 4.1 ------------------------------------------------------------------------

-- 1. Koliko redova ima spoj matches i player_match_stats za sezonu 2024/25? Objasnite.
SELECT *
FROM matches m
JOIN player_match_stats pms ON m.match_id = pms.match_id
WHERE m.season = '2024/25';
-- ovaj spoj ima 15200 redova zato što tabele matches i player_match_stats imaju razlicito 
-- znacenje svakog reda (različiti grain) pa tako svaki red u tabeli matches oznacava jednu 
-- utakmicu a svaki red u tabeli player_match_stats označava statistiku jednog igrača na 
-- toj utakmici. Na svakoj utakmici ima po 20 igraca, tj. ukupno 40. Imamo 10 utakmica u 
-- jednom kolu a 38 kola u sezoni pa je 40 * 10 * 38 = 15200. 1 red iz matches tabele se 
-- spaja sa 40 redova iz player_match_stats tabele.


-- 2. Koliko puta je igrač u istoj sezoni igrao za dva različita kluba?
SELECT
    pms.player_id,
    m.season,
    COUNT(DISTINCT pms.team_id) num_of_diff_teams
FROM player_match_stats pms
JOIN matches m ON pms.match_id = m.match_id
GROUP BY pms.player_id,
         m.season         
HAVING COUNT(DISTINCT pms.team_id) > 1
ORDER BY pms.player_id;
-- 35 igraca su u istoj sezoni igrali za dva razlicita kluba


-- 3. Koliko utakmica ima više kartona od prosečne utakmice? Bez kartona računajte sa 0.
WITH cards_per_game AS (
SELECT
    m.match_id,
    COUNT(me.event_type) total_cards
FROM matches m
LEFT JOIN match_events me ON m.match_id = me.match_id 
        AND me.event_type IN ('yellow_card', 'second_yellow', 'red_card')
GROUP BY m.match_id
)
SELECT COUNT(*) 
FROM cards_per_game
WHERE total_cards > (
            SELECT AVG(total_cards) overall_average_cards
            FROM cards_per_game
            );
-- Na 370 utakmica je bilo više kartona na meču od prosečnog broja datih kartona po meču (3.709141274238227)


-- 4. Koliko igrača je odigralo više od 10 utakmica u sezoni 2024/25?
SELECT 
    pms.player_id,
    COUNT(*) games_played
FROM matches m
JOIN player_match_stats pms ON m.match_id = pms.match_id
WHERE season = '2024/25' AND pms.minutes_played > 0
GROUP BY pms.player_id
HAVING COUNT(*) > 10;
-- Čak 383 igrača je odigralo vise od 10 utakmica u sezoni 2024/25


-- 5. Prikažite sve klubove koji su igrali u sezoni 2024/25, bilo kao domaćini ili kao gosti. 
--Koristite UNION, a zatim izmenite upit tako da koristi UNION ALL. Objasnite razliku u broju 
-- redova koji dobijate.
SELECT DISTINCT home_team_id
FROM matches
WHERE season = '2024/25'
UNION ALL
SELECT DISTINCT away_team_id
FROM matches
WHERE season = '2024/25';

SELECT DISTINCT home_team_id
FROM matches
WHERE season = '2024/25'
UNION
SELECT DISTINCT away_team_id
FROM matches
WHERE season = '2024/25';
-- kad koristimo UNION mi dobijemo 20 redova, toliko koliko ima i klubova koji su igrali u sezoni 2024/25, 
-- UNION briše duplikate koji se pojavljuju spajanjem dva upita

-- dok koristeći UNION ALL mi dupliramo redove, tj. dodajemo redove iako vec imamo iste u prvom delu upita,
-- UNION ALL ne brise duple redove, on uopste ne proverava duplikate vec samo vrsi spajanje po vertikali i 
-- brze se izvrsava od UNIONA jer ne proverava duplikate