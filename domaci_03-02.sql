------------------------------------------------------------------------ DOMAĆI ZADATAK 3.2 ------------------------------------------------------------------------

--------------------------------------------------------------------------- OSNOVNI NIVO ---------------------------------------------------------------------------

-- 1.Prikažite naziv svakog kluba i naziv stadiona na kojem igra domaće utakmice.
SELECT 
    t.team_name,
    s.stadium_name
FROM teams t
JOIN stadiums s ON t.stadium_id = s.stadium_id;


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
JOIN stadiums s ON m.stadium_id = s.stadium_id
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
WHERE m.season = '2024/25' AND me.event_type ILIKE '%yellow%'
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