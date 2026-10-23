------------------------------------------------------------------------ DOMAĆI ZADATAK 3.2 ------------------------------------------------------------------------

--------------------------------------------------------------------------- OSNOVNI NIVO ---------------------------------------------------------------------------

-- 1.Prikažite naziv svakog kluba i naziv stadiona na kojem igra domaće utakmice.
SELECT 
    t.team_name,
    s.stadium_name
FROM teams t
LEFT JOIN stadiums s ON t.stadium_id = s.stadium_id; --dodat left join


-- 2.Prikažite ime i prezime igrača i naziv kluba za koji je igrao u
-- sezoni 2024/25. Uklonite duplikate iz rezultata.
SELECT DISTINCT
    p.first_name,
    p.last_name,
    t.team_name
FROM players p
JOIN player_match_stats pms ON p.player_id = pms.player_id
JOIN matches m ON pms.match_id = m.match_id
JOIN teams t ON pms.team_id = t.team_id
WHERE m.season = '2024/25';


-- 3.Prikažite datum odigravanja utakmice, naziv stadiona i broj
-- gledalaca za sve utakmice u sezoni 2024/25.
SELECT 
    m.kickoff_ts,
    s.stadium_name,
    m.attendance
FROM matches m
LEFT JOIN stadiums s ON m.stadium_id = s.stadium_id --dodat left join
WHERE m.season = '2024/25';


--------------------------------------------------------------------------- SREDNJI NIVO ---------------------------------------------------------------------------

-- 1.Prikažite sve utakmice za koje nije evidentiran broj gledalaca.
-- Prikažite datum, domaći klub i gostujući klub.
SELECT 
    m.kickoff_ts,
    h_t.team_name home_team,
    a_t.team_name away_team
FROM matches m
JOIN teams h_t ON m.home_team_id = h_t.team_id
JOIN teams a_t ON m.away_team_id = a_t.team_id
WHERE m.attendance IS NULL;
-- Postoji ukupno 17 utakmica sa neevidentiranim brojem gledalaca


-- 2.Pronađite stadione na kojima nije odigrana ni jedna utakmica
-- u sezoni 2024/25.
SELECT s.stadium_name
FROM stadiums s 
LEFT JOIN matches m ON m.stadium_id = s.stadium_id AND m.season = '2024/25'
WHERE m.stadium_id IS NULL;
-- U pitanju je stadion Fairhaven Lane, jedino na njemu nije odigrana ni 
-- jedna utakmica u toj sezoni


-- 3.Za svaki klub izračunajte ukupan broj žutih kartona koje su
-- dobili njegovi igrači u sezoni 2024/25. Rezultat sortirajte
-- opadajuće prema broju kartona.
SELECT 
    t.team_name,
    COUNT(*) total_yellow_cards
FROM matches m
JOIN match_events me ON m.match_id = me.match_id
JOIN teams t ON t.team_id = me.team_id
WHERE m.season = '2024/25' AND me.event_type IN ('yellow_card', 'second_yellow') -- ubaceno event_type IN ('yellow_card', 'second_yellow') umesto LIKE '%yellow'
GROUP BY t.team_name
ORDER BY total_yellow_cards DESC;
-- Fudbaleri Ashford Roversa su u sezoni 2024/25 dobili najviše žutih kartona - 77


--------------------------------------------------------------------------- NAPREDNI NIVO ---------------------------------------------------------------------------

-- 1.Pronađite pet igrača sa najvećim brojem asistencija u
-- sezoni 2024/25. Prikažite ime igrača i broj asistencija.
SELECT 
    p.first_name,
    p.last_name,
    COUNT(*) total_assists
FROM match_events me
JOIN matches m ON me.match_id = m.match_id
JOIN players p ON p.player_id = me.related_player_id
WHERE me.event_type = 'goal' AND m.season = '2024/25'
GROUP BY p.first_name,
         p.last_name
ORDER BY total_assists DESC;
-- Najboljih pet asistenta u sezoni 2024/25 su bili:
-- Pablo Fernández sa 9, Filip Petrović, Lucas Pereira, 
-- Eirik Solberg sa 7 i Mikkel Nielsen sa 6 (mada ih
-- ima trojica sa po 6 asistencija) 


-- 2.Pronađite tri igrača sa najvećim ukupnim brojem
-- odigranih minuta u sezoni 2024/25. Prikažite ime igrača,
-- klub i ukupan broj minuta.
SELECT 
    p.first_name,
    p.last_name,
    t.team_name,
    SUM(pms.minutes_played) total_minutes_played
FROM matches m
JOIN player_match_stats pms ON pms.match_id = m.match_id 
JOIN players p ON p.player_id = pms.player_id
JOIN teams t ON t.team_id = pms.team_id
WHERE m.season = '2024/25'
GROUP BY p.first_name,
         p.last_name,
         t.team_name
ORDER BY total_minutes_played DESC;
-- Ibrahima Ndiaye, Jonas Müller, Morgan Nolan i Aaron Lowe 
-- su upisali najviše minuta u sezoni 2024/25 - svi po 3240 minuta


-- 3.Za svaku sezonu prikažite broj isključenja po klubovima.
-- Računajte događaje red_card i second_yellow. Uključite
-- samo klubove koji su imali najmanje jedno isključenje.
SELECT 
    m.season,
    t.team_name,
    COUNT(*) total_ejections
FROM matches m
JOIN match_events me ON m.match_id = me.match_id
JOIN teams t ON me.team_id = t.team_id
WHERE me.event_type IN ('red_card', 'second_yellow')
GROUP BY m.season,
         t.team_name
HAVING total_ejections >= 1
ORDER BY m.season, 
         total_ejections DESC;

------------------------------------------------------------------------ Dodatni zadaci (opciono) ------------------------------------------------------------------------

------------------------------------------------------------------------------ OSNOVNI NIVO ------------------------------------------------------------------------------

-- 1.Za svakog sudiju prikažite njegovo ime i broj utakmica koje je sudio.
-- Uključite i sudije koje nisu sudile ni jednu utakmicu.
SELECT
    r.referee_name,
    COUNT(m.referee_id) games_officiated
FROM matches m
RIGHT JOIN referees r ON m.referee_id = r.referee_id
GROUP BY r.referee_name
ORDER BY games_officiated DESC;
-- Paul Tierney-Ross nije sudio ni jednu utakmicu


-- 2.Prikažite imena i prezimena igrača koji nemaju ni jedan zapis u
-- tabeli player_match_stats.
SELECT
    p.first_name player_first_name,
    p.last_name player_last_name
FROM players p
LEFT JOIN player_match_stats pms ON pms.player_id = p.player_id
WHERE pms.player_id IS NULL;
-- Ima ukupno 31 igrača koji nisu bili u sastavu ni za jedan meč


-- 3.Prikažite broj golova koji je svaki klub postigao kao domaćin u
-- sezoni 2024/25. Rezultat sortirajte od najvećeg ka najmanjem broju
-- golova.
SELECT 
    t.team_name,
    SUM(home_goals) home_team_total_goals
FROM matches m
JOIN teams t ON t.team_id = m.home_team_id
WHERE m.season = '2024/25'
GROUP BY t.team_name
ORDER BY home_team_total_goals DESC;
-- Kingsbridge City je postigao najviše golova kao domaćin
-- u sezoni 2024/25, i to 52 golova

------------------------------------------------------------------------------ SREDNJI NIVO ------------------------------------------------------------------------------

-- 1.Za svaku sezonu prikažite broj golova koje su postigli igrači na
-- pozicijama FW, MF i DF. Rezultat grupišite prema sezoni i poziciji
-- igrača.
SELECT 
    m.season,
    p.position,
    COUNT(*) total_goals_scored
FROM matches m
JOIN match_events me ON m.match_id = me.match_id
JOIN players p ON p.player_id = me.player_id
WHERE p.position IN ('FW', 'MF', 'DF') AND me.event_type IN ('goal', 'penalty_goal')
GROUP BY m.season,
         p.position
ORDER BY season, total_goals_scored DESC;
-- 2023/24: FW 532, MF 352, DF 126; 2024/25: FW 525, MF 370, DF 138


-- 2.Za svaki stadion prikažite njegov naziv i ukupan broj gledalaca na
-- utakmicama odigranim na njemu. Uključite i stadione za koje nema
-- evidentiranih utakmica.
SELECT 
    s.stadium_name,
    SUM(attendance) total_attendance
FROM stadiums s
LEFT JOIN matches m ON s.stadium_id = m.stadium_id
GROUP BY s.stadium_name
ORDER BY total_attendance DESC;
-- Uključeni su svi stadioni, pa čak i pojedini koji nisu imali
-- evidentiranih utakmica u nekoj od sezona, a inače najveću
-- posećenost je imao Harbourside Park 


-- 3.Za svakog sudiju prikažite broj različitih utakmica u kojima je
-- dosuđen penal, bez obzira na to da li je penal realizovan. Uključite i
-- sudije za koje nema takvih utakmica.
SELECT 
    r.referee_name,
    COUNT(DISTINCT m.match_id) penalty_awarded_games
FROM referees r
LEFT JOIN matches m ON r.referee_id = m.referee_id
JOIN match_events me ON me.match_id = m.match_id 
WHERE me.event_type ILIKE '%penalty%'
GROUP BY r.referee_name
ORDER BY penalty_awarded_games DESC;

------------------------------------------------------------------------------ NAPREDNI NIVO ------------------------------------------------------------------------------

-- 1.Za svaki klub prikažite naziv kluba i broj utakmica koje je odigrao
-- kao domaćin u sezoni 2024/25. Rešite zadatak na dva načina:
-- koristeći INNER JOIN; koristeći LEFT JOIN.
-- Objasnite da li se rezultati razlikuju i zašto. Obratite pažnju na
-- klubove koji nemaju ni jednu domaću utakmicu.
SELECT 
    t.team_name,
    COUNT(*) home_games_played
FROM teams t
JOIN matches m ON t.team_id = m.home_team_id
WHERE season = '2024/25'
GROUP BY t.team_name;
-- Rezultati se razlikuju naravno. Kod INNER JOIN-a mi dobijamo samo klubove
-- koji su igrali u sezoni 2024/25 na domacem terenu, svih 20 timova
SELECT 
    t.team_name,
    COUNT(m.home_team_id) home_games_played
FROM teams t
LEFT JOIN matches m ON t.team_id = m.home_team_id AND m.season = '2024/25'
GROUP BY t.team_name;
-- Kod LEFT JOIN-a mi dobijamo pored klubova koji su igrali u sezoni 2024/25 na 
-- domacem terenu, još 4 klubova koja nisu igrala na domacem terenu u toj sezoni,
-- u pitanju su 3 kluba koja su ispala u međuvremenu: Dunmore County, Brackley 
-- Harriers i Fairhaven Town i još Harbor City FC koji je novoosnovani klub i
-- nije se još uvek takmičio


-- 2.Za svaki autogol u sezoni 2024/25 prikažite ime igrača, klub za koji
-- je igrač nastupao na toj utakmici i klub kojem je gol priznat.
SELECT
    p.first_name,
    p.last_name,
    CASE WHEN me.team_id = m.home_team_id THEN a_t.team_name
         ELSE h_t.team_name END own_goal_scorer_team,
    CASE WHEN me.team_id = m.home_team_id THEN h_t.team_name
        ELSE a_t.team_name END goal_awarded_to_team
FROM matches m
JOIN match_events me ON m.match_id = me.match_id
JOIN players p ON me.player_id = p.player_id
JOIN teams h_t ON h_t.team_id = m.home_team_id
JOIN teams a_t ON a_t.team_id = m.away_team_id
WHERE m.season = '2024/25' AND me.event_type = 'own_goal';


-- 3.Pronađite sve klubove koji imaju najmanje jednog igrača koji nema
-- ni jedan zapis u player_match_stats. Prikažite naziv kluba i broj
-- takvih igrača. Rezultat sortirajte opadajuće prema broju igrača.
SELECT
    t.team_name,
    COUNT(DISTINCT p.player_id) not_in_a_team_players_count  -- izmenjeno COUNT(*) u COUNT(DISTINCT p.player_id)
FROM players p 
LEFT JOIN player_match_stats pms ON p.player_id = pms.player_id
JOIN player_contracts pc ON p.player_id = pc.player_id
JOIN teams t ON pc.team_id = t.team_id
WHERE pms.player_id IS NULL
GROUP BY t.team_name
ORDER BY not_in_a_team_players_count DESC;
-- 8 je klubova gde ima po 2 igrača koja nikad nisu bila u sastavu za utakmicu


-- 4.Za svaki grad prikažite broj odigranih utakmica i ukupan broj
-- gledalaca. Pronađite grad sa najvećim ukupnim brojem gledalaca.
SELECT
    s.city,
    COUNT(*) games_played,
    SUM(m.attendance) total_attendance
FROM stadiums s
JOIN matches m ON s.stadium_id = m.stadium_id
GROUP BY s.city
ORDER BY total_attendance DESC;
-- Northport je grad sa najvecim ukupnim brojem gledalaca ali i
-- brojem odigranih utakmica u gradu, moguce je da ipak nije
-- na prvom mestu po prosecnoj gledanosti


-- 5.Pronađite sudije koje su sudile utakmice u sezoni 2023/24, ali nisu
-- sudile ni jednu utakmicu u sezoni 2024/25. Prikažite ime sudije i
-- njegovu nacionalnost.
SELECT DISTINCT
    r.referee_name,
    r.nationality
FROM referees r
JOIN matches m1 ON r.referee_id = m1.referee_id AND m1.season = '2023/24'
LEFT JOIN matches m2 ON r.referee_id = m2.referee_id AND m2.season = '2024/25'  -- spojena dva upita u jedan
WHERE m2.referee_id IS NULL;
-- Paul Tierney-Ross koji je Englez, nije sudio ni jednu utakmicu ni u jednoj sezoni
-- Ostali su sudili u obe sezone, tako da nemamo traženog sudiju