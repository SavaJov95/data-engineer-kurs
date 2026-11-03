-------------------------------------------------------------------------DOMAĆI ZADATAK 2.2-------------------------------------------------------------------------


-- 1. Pronađite sve utakmice čiji naslov (`match_report`)
-- sadrži reč `goal`, bez obzira na velika i mala slova.
SELECT 
    match_id,
    match_report
FROM matches_flat
WHERE match_report ILIKE '%goal%';
-- ukupno ima takvih 41 utakmica i na svakom od tih mečeva 
-- se u izveštaju spominje reč 'Goalless'


-- 2. Napravite kolonu `referee_name` tako da sadrži ime
-- sudije ako postoji, a tekst `Unknown` ako nedostaje
-- podatak. Prikažite 20 utakmica.
SELECT
    match_id,
    coalesce(referee_name, 'Unknown') AS referee_name
FROM matches_flat
LIMIT 20;


-- 3. Prikažite utakmice čiji je naslov duži od 40 znakova.
-- Prikažite naslov i broj znakova u njemu.
SELECT
    match_report,
    length(match_report) AS match_report_length
FROM matches_flat
WHERE length(match_report) > 40;
-- ima ih puno, čak 537


-- 4. Prikažite utakmice odigrane od 1. do 15. januara 2025,
-- uključujući oba datuma.
SELECT
    match_id,
    kickoff_ts
FROM matches_flat
WHERE kickoff_ts >= '2025-01-01' AND kickoff_ts < '2025-01-16';
-- 31 utakmica je odigrana u tom rasponu datuma


-- 5. Prebrojte utakmice odigrane petkom. Prikažite datum i
-- dan u nedelji za svaku od njih.
SELECT
    date(kickoff_ts) AS `date`,
    dayofweek(kickoff_ts) AS day_of_the_week
FROM matches_flat
WHERE dayofweek(kickoff_ts) = 6;
-- tačno 0 utakmica je odigrano petkom


-- 6. Koliko utakmica sezone `2024/25` je imalo između
-- 20.000 i 35.000 gledalaca, uključujući obe granice?
SELECT
    match_id,
    season,
    attendance
FROM matches_flat
WHERE season = '2024/25' AND attendance BETWEEN 20000 AND 35000;
-- 188 utakmica ispunjava ove uslove


-- 7. Pronađite strelce prvog gola čije ime počinje slovom `A`
-- ili sadrži crticu. Prikažite samo različita imena.
SELECT DISTINCT
    first_goal_scorer
FROM matches_flat
WHERE first_goal_scorer LIKE 'A%' OR first_goal_scorer LIKE '%-%';
-- 22 strelaca prvog gola ima takva imena


-- 8. Prikažite utakmice sezone `2024/25` koje su počele
-- između 18:00 i 21:00, uključujući obe granice. Prikažite
-- vreme početka i nazive timova.
SELECT
    kickoff_ts,
    home_team,
    away_team
FROM matches_flat
WHERE season = '2024/25' AND hour(kickoff_ts) BETWEEN 18 AND 21;


-- 9. Prebrojte utakmice odigrane u martu, aprilu ili maju
-- 2025. godine čiji naslov sadrži reč `win`, bez obzira na
-- veličinu slova.
SELECT
    COUNT(*) AS match_count
FROM matches_flat
WHERE year(kickoff_ts) = 2025 AND month(kickoff_ts) IN (3, 4, 5) AND match_report ILIKE '%win%';
-- ima ih 5


-------------------------------------------------------------------------Dodatni zadaci (opciono)-------------------------------------------------------------------------


-- 1. Prebrojte utakmice za koje nisu evidentirani ni sudija ni poseta.
SELECT
    COUNT(*) AS match_count
FROM matches_flat
WHERE referee_name IS NULL AND attendance IS NULL;
-- nema takvih utakmica


-- 2. Prikažite sve utakmice odigrane između 1. i 31. marta 2025.
-- godine, uključujući oba datuma. Rezultate sortirajte po datumu
-- odigravanja.
SELECT
    match_id,
    kickoff_ts
FROM matches_flat
WHERE kickoff_ts >= '2025-03-01' AND kickoff_ts < '2025-04-01'
ORDER BY kickoff_ts;


-- 3. Koliko je utakmica odigrano u periodu od 20. decembra 2024.
-- do 10. januara 2025. godine, uključujući oba datuma?
SELECT
    match_id,
    kickoff_ts
FROM matches_flat
WHERE kickoff_ts >= '2024-12-20' AND kickoff_ts < '2025-01-11';
-- 51 utakmica


-- 4. Napravite kolonu attendance_status koja prikazuje broj
-- gledalaca ako je poseta evidentirana, a tekst Unknown ako
-- podatak o poseti nedostaje. Prikažite datum utakmice, domaći
-- tim, gostujući tim i novu kolonu.
SELECT
    date(kickoff_ts) AS match_date,
    home_team,
    away_team,
    coalesce(CAST(attendance AS string), 'Unknown') AS attendance_status
FROM matches_flat;


-- 5. Prikažite utakmice odigrane u periodu od 1. do 30. aprila 2025.
-- godine kod kojih je postignuto između 2 i 4 gola ukupno,
-- uključujući obe granice. Rezultate sortirajte po datumu.
SELECT
    kickoff_ts,
    home_team,
    away_team,
    home_goals,
    away_goals
FROM matches_flat
WHERE kickoff_ts >= '2025-04-01' AND kickoff_ts < '2025-05-01' AND (home_goals + away_goals) BETWEEN 2 AND 4
ORDER BY kickoff_ts;


-- 6.Pronađite utakmice kod kojih je rezultat na poluvremenu bio
-- nerešen, ali je konačni rezultat bio različit. Prikažite datum, timove,
-- rezultat na poluvremenu i konačni rezultat.
SELECT
    kickoff_ts,
    home_team,
    away_team,
    home_goals_ht,
    away_goals_ht,
    home_goals,
    away_goals
FROM matches_flat
WHERE home_goals_ht = away_goals_ht AND (home_goals_ht <> home_goals OR away_goals_ht <> away_goals);