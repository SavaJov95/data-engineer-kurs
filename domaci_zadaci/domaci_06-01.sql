------------------------------------------------------------------------ DOMAĆI ZADATAK 6.1 ------------------------------------------------------------------------

-- 1. Kreiranje dimenzije igrača
-- Na osnovu tabele players napravite tabelu dim_player koja
-- sadrži sledeće kolone: player_id, ime, prezime, poziciju i
-- nacionalnost igrača.
-- Koliko redova ima novokreirana tabela?
CREATE TABLE dim_player AS 
SELECT
    player_id,
    first_name,
    last_name,
    position,
    nationality
FROM players; 
-- novokreirana tabela dim_player ima 681 red kao i tabela players.


-- 2. Kreiranje dimenzije datuma i činjenične tabele
-- Napravite tabelu dim_date na isti način kao na predavanju.
-- Zatim napravite tabelu fact_player_match na osnovu tabela
-- player_match_stats i matches. Tabela treba da sadrži
-- sledeće kolone: match_id, date_key, player_id, team_id,
-- minutes_played, shots, passes i rating.
-- U tabelu uključite samo podatke koji se odnose na odigrane
-- utakmice.
-- Kolika je granularnost tabele fact_player_match, odnosno
-- šta predstavlja jedan njen red?
-- Koliko redova ima ova tabela?
CREATE OR REPLACE TABLE dim_date AS
SELECT CAST(DATE_FORMAT(d, 'yyyyMMdd') AS INT) AS date_key,
       d                                       AS full_date,
       DATE_FORMAT(d, 'EEEE')                  AS weekday_name,
       DAYOFWEEK(d) IN (1, 7)                  AS is_weekend,
       CASE WHEN MONTH(d) >= 7 THEN CONCAT(YEAR(d), '/', SUBSTRING(CAST(YEAR(d) + 1 AS STRING), 3, 2))
            ELSE CONCAT(YEAR(d) - 1, '/', SUBSTRING(CAST(YEAR(d) AS STRING), 3, 2))
       END                                     AS season
FROM (SELECT EXPLODE(SEQUENCE(DATE'2023-07-01', DATE'2025-06-30', INTERVAL 1 DAY)) AS d);
-- dim_date tabela kao sto smo radili

CREATE TABLE fact_player_match AS 
SELECT
    m.match_id, 
    CAST(DATE_FORMAT(kickoff_ts, 'yyyyMMdd') AS INT) AS date_key, 
    s.player_id, 
    s.team_id,
    s.minutes_played, 
    s.shots, 
    s.passes, 
    s.rating
FROM player_match_stats s
JOIN matches m ON s.match_id = m.match_id 
WHERE m.status = 'played';
-- jedan red tabele predstavlja statistiku jednog igraca na jednoj utakmici
-- ova tabela ima 30400 redova - 760 mečeva u dve sezone * 40 igrača po utakmici


-- 3. Prosečna ocena igrača po poziciji
-- Koristeći napravljene dimenzije i činjeničnu tabelu, izračunajte
-- prosečnu ocenu (rating) igrača za svaku poziciju tokom
-- sezone 2024/25.
-- Prikažite poziciju i odgovarajuću prosečnu ocenu.
SELECT 
    p.position,
    ROUND(AVG(rating), 2) avg_rating
FROM fact_player_match pm
JOIN dim_player p ON pm.player_id = p.player_id
JOIN dim_date d ON pm.date_key = d.date_key
WHERE d.season = '2024/25' AND rating <> 'nan'
GROUP BY p.position
ORDER BY avg_rating DESC;
-- eliminisali smo vrednosti "nan" iz kolone rating prilikom upita 
-- jer nema smisla da u računanje proseka uključimo igrače koji 
-- nisu ocenjeni zbog malog broja minuta, tj. da svedemo nan na 0. 


-- 4. Dodavanje broja golova u činjeničnu tabelu
-- Proširite tabelu fact_player_match dodavanjem kolone koja
-- predstavlja broj golova koje je svaki igrač postigao na
-- određenoj utakmici.
-- Koliki je ukupan zbir golova svih igrača u tabeli
-- fact_player_match?
ALTER TABLE fact_player_match ADD COLUMNS (total_goals INT);
-- dodavanje kolone

UPDATE fact_player_match m
SET total_goals = (
    SELECT COUNT(*)
    FROM match_events e
    WHERE event_type IN ('goal', 'penalty_goal') 
        AND m.match_id = e.match_id
        AND m.team_id = e.team_id
        AND m.player_id = e.player_id
);
-- popunjavanje nove kolone vrednostima iz postojece...mora da bude isti 
-- meč, tim i igrač da bi dobro povezali tabele i preneli podatke

SELECT SUM(total_goals) FROM fact_player_match;
SELECT COUNT(*) 
FROM match_events
WHERE event_type IN ('goal', 'penalty_goal');
-- provera tačnosti kolone, ukupan zbir je 2.043 golova