-------------------------------------------------------------------------DOMAĆI ZADATAK 2.1-------------------------------------------------------------------------

-- 1. Dodajte kolonu empty_seats (kapacitet stadiona minus
-- poseta) i prikažite 5 utakmica sa najviše praznih mesta.
-- Šta je zajedničko prvim trima?
SELECT
    home_team,
    away_team,
    stadium_name,
    stadium_capacity - attendance AS empty_seats
FROM matches_flat
ORDER BY empty_seats DESC
LIMIT 5;
-- ODGOVOR: Zanimljivo je da su prve 3 utakmice igrane na "National Stadium" a 
-- je da je u prve 4 utakmice domaćin bio "Oakfield Town"


-- 2. Koliko različitih sudija je sudilo domaće utakmice kluba
-- Riverton Athletic?
SELECT DISTINCT
    referee_name
FROM matches_flat
WHERE home_team = 'Riverton Athletic';
-- ODGOVOR: 15 različitih sudija je sudilo domaće utakmice kluba
-- Riverton Athletic


-- 3. U koliko utakmica je gost vodio na poluvremenu, a
-- domaćin na kraju pobedio?
SELECT
    home_team,
    away_team,
    home_goals,
    away_goals,
    home_goals_ht,
    away_goals_ht
FROM matches_flat
WHERE away_goals_ht > home_goals_ht AND home_goals > away_goals;
-- ODGOVOR: U 15 utakmica se dogodilo da je gost vodio na poluvremenu,
-- a domaćin na kraju pobedio


-- 4. U kojoj utakmici je palo najviše golova u drugom
-- poluvremenu? Ko je igrao, rezultat na poluvremenu i
-- rezultat na kraju?
SELECT
    home_team,
    away_team,
    home_goals,
    away_goals,
    home_goals_ht,
    away_goals_ht,
    home_goals - home_goals_ht + away_goals - away_goals_ht AS second_half_goals
FROM matches_flat
ORDER BY second_half_goals DESC
LIMIT 1;
-- ODGOVOR: U pitanju je utakmica između Northport United i Newbury Forest,
-- na poluvremenu je bilo 1:0 a meč se završio rezultatom 6:3 tako
-- da je u drugom poluvremenu palo 8 golova


-- 5. Koliko utakmica sezone 2023/24 je odigrano po snegu ili magli?
SELECT
    season,
    weather
FROM matches_flat
WHERE season = '2023/24' AND (weather = 'snow' OR weather = 'fog');
-- ODGOVOR: Ukupno 25 utakmica u sezoni 2023/24 je odigrano po snegu ili magli


-- 6.pitanje: Prikažite sve utakmice gradskog derbija između
-- Northport United i Northport City, bez obzira na to ko je
-- domaćin, sortirane po datumu. Ko je pobedio u kom meču?
SELECT
    home_team,
    away_team,
    kickoff_ts,
    home_goals,
    away_goals
FROM matches_flat
WHERE (home_team = 'Northport United' AND away_team = 'Northport City') OR (home_team = 'Northport City' AND away_team = 'Northport United')
ORDER BY kickoff_ts;
-- ODGOVOR: Northport United je pobedio u prvom gradskom derbiju
-- i to kao gost, naredni međusobni susret je završen
-- nerešeno, a poslednja dva derbija su otišla u korist
-- domaćina, prvo Northport City-ja pa onda Northport United-a


-- 7. Prikažite prve 3 utakmice sezone 2024/25 po vremenu
-- početka. Da li možete biti sigurni koja je druga, a koja
-- treća? Kako biste to obezbedili?
SELECT
    home_team,
    away_team,
    season,
    kickoff_ts,
    original_kickoff_ts
FROM matches_flat
WHERE season = '2024/25'
ORDER BY kickoff_ts, original_kickoff_ts;
-- ODGOVOR: Prva utakmica je zakazana u 12:30 što je započelo sezonu
-- 2024/25, nakon toga imamo 6 utakmica koje su sve zakazane u 15:00. 
-- Kolona original_kickoff_ts bi trebalo da nam da informaciju o tome 
-- kada su stvarno počele utakmice i tada bismo mogli da tvrdimo koja 
-- je druga a koja treća ali pošto u toj koloni imamo samo NULL 
-- vrednosti, ne možemo zaključiti na osnovu datih informacija


-- 8. Prikažite sve utakmice u kojima je prvi gol dao Sean
-- O'Neill. Koliko ih je?
SELECT
    home_team,
    away_team,
    first_goal_scorer
FROM matches_flat
WHERE first_goal_scorer = "Sean O'Neill";
-- ODGOVOR: Sean O'Neill je bio prvi strelac na 2 utakmice